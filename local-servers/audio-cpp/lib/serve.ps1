#Requires -Version 7
<#
.SYNOPSIS
    Runs the audio.cpp server with every streaming model downloaded into ./models: Voxtral Realtime as
    "voxtral-realtime" (the app provider's default), Nemotron 3.5 ASR as "nemotron-asr" and Confucius4-R2T2
    as "confucius-r2t2". The client picks one by id. Called by serve-vulkan.ps1 / serve-cuda.ps1, which pass
    their other arguments here.
#>
param(
    [Parameter(Mandatory)]
    [ValidateSet('vulkan', 'cuda')]
    [string]$Backend,

    # The package served when several are downloaded; by default the first one listed in $families.
    [ValidateSet('q4_k', 'q8_0')]
    [string]$VoxtralModel,

    [ValidateSet('q8_0', 'f16')]
    [string]$NemotronModel,

    [string]$BindAddress = '127.0.0.1',

    # 8080 is the NeMo Speech server's, so both can run at once.
    [int]$Port = 8081,

    # Voxtral only. Encoder steps decoded together: fewer GPU round trips, each word up to n x 80 ms
    # later. Upstream recommends 4 for live sources; 1 does not keep up on a GTX 960.
    [ValidateRange(1, 16)]
    [int]$StreamBatchTokens = 4,

    # Confucius4-R2T2 only. Audio decoded per step; each step re-decodes the unstable tail, so shorter steps
    # show words sooner at more GPU work per second. On a GTX 960 only 2000 keeps up with real time
    # (upstream's default is 320).
    [ValidateRange(80, 2000)]
    [int]$ConfuciusChunkMs = 2000
)

$ErrorActionPreference = 'Stop'

$root = Split-Path $PSScriptRoot
$families = @(
    @{
        Id       = 'voxtral-realtime'
        Family   = 'voxtral_realtime'
        Models   = @('q4_k', 'q8_0')
        Pick     = $VoxtralModel
        File     = 'voxtral-mini-4b-realtime-2602-{0}.gguf'
        Download = './download-model-voxtral.ps1 -Model {0}'
        Options  = @{ 'voxtral_realtime.stream_batch_tokens' = $StreamBatchTokens }
    }
    @{
        Id       = 'nemotron-asr'
        Family   = 'nemotron_asr'
        Models   = @('q8_0', 'f16')
        Pick     = $NemotronModel
        File     = 'nemotron-3.5-asr-streaming-0.6b-{0}.gguf'
        Download = './download-model-nemotron.ps1 -Model {0}'
        Options  = @{}
    }
    @{
        Id       = 'confucius-r2t2'
        Family   = 'confucius4_r2t2'
        Models   = @('q8_0')
        File     = 'confucius4-r2t2-{0}.gguf'
        Download = './download-model-confucius.ps1'
        Options  = @{ 'confucius4_r2t2.chunk_size_ms' = $ConfuciusChunkMs }
    }
)

$exe = Join-Path $root "runtime/$Backend/audiocpp_server.exe"
if (-not (Test-Path $exe)) { throw "No $Backend runtime. Run: ./download-$Backend.ps1" }

function Get-ModelPath($spec, [string]$model) { Join-Path $root ("models/" + ($spec.File -f $model)) }

$models = foreach ($spec in $families) {
    if ($spec.Pick) {
        $path = Get-ModelPath $spec $spec.Pick
        if (-not (Test-Path $path)) { throw "No $($spec.Id) $($spec.Pick) model. Run: $($spec.Download -f $spec.Pick)" }
    }
    else {
        $path = $spec.Models | ForEach-Object { Get-ModelPath $spec $_ } | Where-Object { Test-Path $_ } | Select-Object -First 1
        if (-not $path) { continue }
    }
    Write-Host "serve     $($spec.Id)  $(Split-Path -Leaf $path)"
    [ordered]@{
        id              = $spec.Id
        family          = $spec.Family
        path            = (Resolve-Path $path).Path
        task            = 'asr'
        mode            = 'streaming'
        session_options = $spec.Options
    }
}
if (-not $models) { throw 'No model downloaded. Run one of ./download-model-*.ps1' }

# The server takes its model list only from a config file; it is generated, never committed.
# Two models do not fit a 4 GB GPU together: with several, each loads on its first request and
# replaces the one in memory, so the first request after a switch waits for the load.
$config = [ordered]@{
    host              = $BindAddress
    port              = $Port
    backend           = $Backend
    device            = 0
    threads           = 4
    lazy_load         = @($models).Count -gt 1
    max_loaded_models = 1
    ui                = $false
    models            = @($models)
}
$configPath = Join-Path $root 'runtime/server.json'
$config | ConvertTo-Json -Depth 5 | Set-Content -Encoding utf8NoBOM $configPath

& $exe --config $configPath
exit $LASTEXITCODE
