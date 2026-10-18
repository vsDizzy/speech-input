#Requires -Version 7
<#
.SYNOPSIS
    Downloads the audio.cpp Windows Vulkan runtime into ./runtime/vulkan. Runs on any GPU with a Vulkan
    driver, Maxwell (GTX 900) included.
#>

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'lib/Download.psm1') -Force
Install-Runtime vulkan
