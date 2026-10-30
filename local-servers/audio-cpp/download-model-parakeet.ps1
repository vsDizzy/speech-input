#Requires -Version 7
<#
.SYNOPSIS
    Downloads the Parakeet TDT 0.6B v3 model for audio.cpp into ./models, served both streaming (buffered
    windows) and offline.
.EXAMPLE
    ./download-model-parakeet.ps1              # q8_0 (~0.9 GB), upstream's recommended package
.EXAMPLE
    ./download-model-parakeet.ps1 -Model f16   # ~1.3 GB
#>
param(
    [ValidateSet('q8_0', 'f16')]
    [string]$Model = 'q8_0'
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'lib/Download.psm1') -Force

# audio-cpp/audio.cpp-gguf at this revision; the GGUF embeds config, processor config and tokenizer.
$ModelRepo = 'audio-cpp/audio.cpp-gguf'
$ModelRevision = '874fcb41ececda20bcbc0782d6b4ea7f7d069ea8'
$ModelFolder = 'Parakeet-TDT-0.6B-v3-GGUF'
$ModelSha256 = @{
    'q8_0' = '6fa498f10f8cb606f041aa9512733cfee842a932359b00b0c45b9b723c4f4f4b'
    'f16'  = '1720770887bbb6ae633b3375c6ce4b76b3eaff9cd4efd7b890db734cc0adfe80'
}

$file = "parakeet-tdt-0.6b-v3-$Model.gguf"
Get-VerifiedFile "https://huggingface.co/$ModelRepo/resolve/$ModelRevision/$ModelFolder/$file" (Join-Path $PSScriptRoot "models/$file") $ModelSha256[$Model]
