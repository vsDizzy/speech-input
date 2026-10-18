#Requires -Version 7
<#
.SYNOPSIS
    Runs the audio.cpp server on Vulkan. Parameters: lib/serve.ps1.
.EXAMPLE
    ./serve-vulkan.ps1
.EXAMPLE
    ./serve-vulkan.ps1 -VoxtralModel q8_0 -Port 9090
#>
& (Join-Path $PSScriptRoot 'lib/serve.ps1') -Backend vulkan @args
exit $LASTEXITCODE
