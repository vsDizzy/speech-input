#Requires -Version 7
<#
.SYNOPSIS
    Runs the native Windows NeMo Speech server on CUDA. Parameters: lib/serve.ps1.
.EXAMPLE
    ./serve-cuda.ps1
.EXAMPLE
    ./serve-cuda.ps1 -Port 9090
#>
& (Join-Path $PSScriptRoot 'lib/serve.ps1') -Backend cuda @args
exit $LASTEXITCODE
