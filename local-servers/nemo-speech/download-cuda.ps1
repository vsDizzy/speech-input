#Requires -Version 7
<#
.SYNOPSIS
    Downloads the NeMo-Speech.cpp Windows CUDA runtime into ./runtime/cuda. Upstream builds it with CUDA 13:
    Turing (RTX 20) or newer and a driver with CUDA 13.
#>

$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'lib/Download.psm1') -Force
Install-Runtime cuda
