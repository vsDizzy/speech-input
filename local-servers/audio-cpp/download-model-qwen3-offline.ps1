#Requires -Version 7
<#
.SYNOPSIS
    Downloads the Qwen3-ASR 1.7B model for audio.cpp into ./models, served offline (whole recordings, no
    live text), with the Silero VAD it uses to split long recordings at pauses.
.EXAMPLE
    ./download-model-qwen3-offline.ps1              # q8_0 (~2.5 GB), upstream's default package
.EXAMPLE
    ./download-model-qwen3-offline.ps1 -Model f16   # ~4.1 GB
#>
param(
    # q8_0 fits a 4 GB GPU; f16 alone is larger than one.
    [ValidateSet('q8_0', 'f16')]
    [string]$Model = 'q8_0'
)

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'lib/Download.psm1') -Force

# audio-cpp/audio.cpp-gguf at this revision; the GGUF embeds config, processor config and tokenizer.
$ModelRepo = 'audio-cpp/audio.cpp-gguf'
$ModelRevision = '235f70e17d42a43ff234d29059d4f57393db4bff'
$ModelFolder = 'Qwen3-ASR-1.7B-GGUF'
$ModelSha256 = @{
    'q8_0' = 'da4fc2ac7f24dee784d1684eb1f35836cdbf559519452ae11777670734c0a4f8'
    'f16'  = 'f12537d4ea56df4e1dcca64a902e0b37fb1111f8ef7fc8e554fd00110be047d0'
}

# The release archives leave out upstream's assets/framework/models, where the model spec looks for it.
$VadUrl = "https://raw.githubusercontent.com/0xShug0/audio.cpp/v$Version/assets/framework/models/silero_vad/silero_vad_16k.safetensors"
$VadSha256 = 'c59271c284ae9c8335d795d60e0bfdb71aaaceec578d9bd9ffc1b8153c319ea1'

$file = "qwen3-asr-1.7b-$Model.gguf"
Get-VerifiedFile "https://huggingface.co/$ModelRepo/resolve/$ModelRevision/$ModelFolder/$file" (Join-Path $PSScriptRoot "models/$file") $ModelSha256[$Model]
Get-VerifiedFile $VadUrl (Join-Path $PSScriptRoot 'models/silero_vad/silero_vad_16k.safetensors') $VadSha256
