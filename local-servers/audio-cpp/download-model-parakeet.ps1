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
$ModelRevision = '661a224e9d9adbd49c01626f85e426f5f425d771'
$ModelFolder = 'Parakeet-TDT-0.6B-v3-GGUF'
$ModelSha256 = @{
    'q8_0' = '074e61ac1abd3d3efcfc10798d17bf9a975b31768b466fc2578364d206dde64c'
    'f16'  = '83622c44275694039e543e135ac91b40d94f48fc80a1bf187b5a1cbcd5dd8649'
}

$file = "parakeet-tdt-0.6b-v3-$Model.gguf"
Get-VerifiedFile "https://huggingface.co/$ModelRepo/resolve/$ModelRevision/$ModelFolder/$file" (Join-Path $PSScriptRoot "models/$file") $ModelSha256[$Model]
