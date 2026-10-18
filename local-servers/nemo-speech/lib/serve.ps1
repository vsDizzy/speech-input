#Requires -Version 7
<#
.SYNOPSIS
    Runs the native Windows NeMo Speech server with Nemotron 3.5 ASR. Called by serve-vulkan.ps1 /
    serve-cuda.ps1, which pass their other arguments here.
.DESCRIPTION
    Set NEMO_SPEECH_HTTP_API_KEY in the environment to require a bearer key; the server reads it itself.
#>
param(
    [Parameter(Mandatory)]
    [ValidateSet('vulkan', 'cuda')]
    [string]$Backend,

    [string]$BindAddress = '127.0.0.1',

    [int]$Port = 8080
)

$ErrorActionPreference = 'Stop'

$root = Split-Path $PSScriptRoot
$exe = Join-Path $root "runtime/$Backend/bin/nemo-speech.exe"
$modelPath = Join-Path $root 'models/nemotron-3.5-asr-streaming-0.6b.q8_0.gguf'
if (-not (Test-Path $exe)) { throw "No $Backend runtime. Run: ./download-$Backend.ps1" }
if (-not (Test-Path $modelPath)) { throw 'No model. Run: ./download-model-nemotron.ps1' }

& $exe serve --host $BindAddress --port $Port --asr-model $modelPath
exit $LASTEXITCODE
