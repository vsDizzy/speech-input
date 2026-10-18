#Requires -Version 7
<#
.SYNOPSIS
    Runs the audio.cpp server on CUDA. Parameters: lib/serve.ps1.
.EXAMPLE
    ./serve-cuda.ps1
.EXAMPLE
    ./serve-cuda.ps1 -VoxtralModel q8_0 -Port 9090
#>
& (Join-Path $PSScriptRoot 'lib/serve.ps1') -Backend cuda @args
exit $LASTEXITCODE
