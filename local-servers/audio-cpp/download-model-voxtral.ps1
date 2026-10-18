#Requires -Version 7
<#
.SYNOPSIS
    Downloads the Voxtral Mini 4B Realtime model for audio.cpp into ./models.
.EXAMPLE
    ./download-model-voxtral.ps1               # q4_k (~3.1 GB)
.EXAMPLE
    ./download-model-voxtral.ps1 -Model q8_0   # ~5.1 GB
#>
param(
    # q4_k fits a 4 GB GPU; q8_0 needs about 9 GB while streaming.
    [ValidateSet('q4_k', 'q8_0')]
    [string]$Model = 'q4_k'
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'lib/Download.psm1') -Force

# mistral-experimental/AudioCPP-Voxtral-Mini-4B-Realtime-2602-GGUF at this revision.
$ModelRepo = 'mistral-experimental/AudioCPP-Voxtral-Mini-4B-Realtime-2602-GGUF'
$ModelRevision = '4c3212f91349c32211172ce332f266a6e9501018'
$ModelSha256 = @{
    'q4_k' = '8cafef18ea3e4cad81da8ffc4e72b69d2eab2c159c2e68428e2e088accbfc7f8'
    'q8_0' = '0312a5ceafc6ee4a19a32da458cab6485e3b86b1b563c7bb7150aeae295c1769'
}

$file = "voxtral-mini-4b-realtime-2602-$Model.gguf"
Get-VerifiedFile "https://huggingface.co/$ModelRepo/resolve/$ModelRevision/$file" (Join-Path $PSScriptRoot "models/$file") $ModelSha256[$Model]
