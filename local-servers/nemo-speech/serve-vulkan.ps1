#Requires -Version 7
<#
.SYNOPSIS
    Runs the native Windows NeMo Speech server on Vulkan. Parameters: lib/serve.ps1.
.EXAMPLE
    ./serve-vulkan.ps1
.EXAMPLE
    ./serve-vulkan.ps1 -Port 9090
#>
& (Join-Path $PSScriptRoot 'lib/serve.ps1') -Backend vulkan @args
exit $LASTEXITCODE
