#Requires -Version 7
<#
.SYNOPSIS
    Downloads the audio.cpp Windows CUDA 13.3 runtime with its CUDA DLLs into ./runtime/cuda (~850 MB):
    Turing (RTX 20) or newer and a driver with CUDA 13.
#>

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'lib/Download.psm1') -Force
Install-Runtime cuda
