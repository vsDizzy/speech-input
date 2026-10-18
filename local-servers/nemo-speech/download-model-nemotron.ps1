#Requires -Version 7
<#
.SYNOPSIS
    Downloads the Nemotron 3.5 ASR Streaming 0.6B model (q8_0, ~740 MB) into ./models, for the native server
    and the Docker image alike.
#>

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'lib/Download.psm1') -Force

# Revision and hash come from share/nemo-speech/model-index.json of the release in lib/Download.psm1.
$Repo = 'nvidia/nemotron-3.5-asr-streaming-0.6b'
$Revision = '1c8deaecc64b91f034d73e08dd8b64625eb3395d'
$File = 'nemotron-3.5-asr-streaming-0.6b.q8_0.gguf'
$Sha256 = 'a5c435f294eea8f88ce68dd27b8c3bfea7f777cb2fbba04fcd30eaa555f429ae'

Get-VerifiedFile "https://huggingface.co/$Repo/resolve/$Revision/$File" (Join-Path $PSScriptRoot "models/$File") $Sha256
