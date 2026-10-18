#Requires -Version 7
<#
.SYNOPSIS
    Downloads the Nemotron 3.5 ASR Streaming 0.6B model for audio.cpp into ./models.
.EXAMPLE
    ./download-model-nemotron.ps1              # q8_0 (~0.9 GB), upstream's recommended package
.EXAMPLE
    ./download-model-nemotron.ps1 -Model f16   # ~1.3 GB
#>
param(
    [ValidateSet('q8_0', 'f16')]
    [string]$Model = 'q8_0'
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'lib/Download.psm1') -Force

# audio-cpp/audio.cpp-gguf at this revision; the GGUF embeds config, processor config and tokenizer.
$ModelRepo = 'audio-cpp/audio.cpp-gguf'
$ModelRevision = 'f861648c0c1f4da9f18e9a0ce5e217b0679bb2f5'
$ModelFolder = 'Nemotron-3.5-ASR-Streaming-0.6B-GGUF'
$ModelSha256 = @{
    'q8_0' = 'c58b62c1bdd6c5d7b14b08126c5bd16c1289fee6e0d6ac0761dbd3aa6d714935'
    'f16'  = 'f02bb2fa14ad74b1deb2c63c36777fd81b546a696df096cd29ea3fe271b05c09'
}

$file = "nemotron-3.5-asr-streaming-0.6b-$Model.gguf"
Get-VerifiedFile "https://huggingface.co/$ModelRepo/resolve/$ModelRevision/$ModelFolder/$file" (Join-Path $PSScriptRoot "models/$file") $ModelSha256[$Model]
