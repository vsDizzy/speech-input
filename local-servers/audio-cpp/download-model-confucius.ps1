#Requires -Version 7
<#
.SYNOPSIS
    Downloads the Confucius4-R2T2 model (NetEase Youdao's streaming Qwen3-ASR 1.7B fine-tune) for audio.cpp
    into ./models: the q8_0 package (~2.5 GB), upstream's default.
#>

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'lib/Download.psm1') -Force

# davidxifeng/Confucius4-R2T2-gguf at this revision, the repository audio.cpp's model spec names; the GGUF
# embeds config and tokenizer. Under the NetEase Youdao Model Use License (LICENSE in the repository).
$ModelRepo = 'davidxifeng/Confucius4-R2T2-gguf'
$ModelRevision = 'a8e6b385d7df7eae9519363e07034a209004797a'
$ModelSha256 = '19f5ccd624484bcb5d44301437de41560b0ecc40c430e8850dfeefefbe82ccf5'

Get-VerifiedFile "https://huggingface.co/$ModelRepo/resolve/$ModelRevision/r2t2-q8_0.gguf" (Join-Path $PSScriptRoot 'models/confucius4-r2t2-q8_0.gguf') $ModelSha256
