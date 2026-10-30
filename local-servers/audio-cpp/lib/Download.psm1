$Version = '0.9.3'

# Release archives per backend, with the release's asset digests; all are flat and unpack into one folder.
# The CUDA cudart archive carries the CUDA runtime DLLs.
$Runtimes = @{
    'vulkan' = [ordered]@{
        "audio-v$Version-bin-windows-x64-vulkan.zip"      = 'd1741e16154f99ef96382a36d5e89ccf12fd4fda6ec7dcdcdbd122d82f525c11'
    }
    'cuda'   = [ordered]@{
        "audio-v$Version-bin-windows-x64-cuda13.3.zip"    = '0bd3988be10c31ec078c40df2bd0d4266e660804f6d5083aeb05d1309d091e43'
        "audio-v$Version-cudart-windows-x64-cuda13.3.zip" = '839eb20f684a8aab64895b1e466b32ce9b29dfc19dc1ce15b2ef35218512ac0a'
    }
}

function Test-Sha256([string]$Path, [string]$Expected) {
    (Test-Path $Path) -and (Get-FileHash -Algorithm SHA256 $Path).Hash -eq $Expected.ToUpperInvariant()
}

# curl resumes an interrupted .part file; the hash decides whether the result is kept.
function Get-VerifiedFile([string]$Url, [string]$Destination, [string]$Sha256) {
    if (Test-Sha256 $Destination $Sha256) {
        Write-Host "ok        $Destination"
        return
    }
    New-Item -ItemType Directory -Force (Split-Path $Destination) | Out-Null
    $part = "$Destination.part"
    Write-Host "download  $Url"
    & curl.exe --fail --location --continue-at - --output $part $Url
    if ($LASTEXITCODE -ne 0) { throw "Download failed: $Url" }
    if (-not (Test-Sha256 $part $Sha256)) {
        Remove-Item $part
        throw "SHA-256 mismatch for $Url"
    }
    Move-Item -Force $part $Destination
}

function Install-Runtime([string]$Backend) {
    if (-not $IsWindows) { throw 'The prebuilt runtime here is Windows-only.' }

    $root = Split-Path $PSScriptRoot
    $archives = $Runtimes[$Backend]
    $name = @($archives.Keys) -join ' '
    $target = Join-Path $root "runtime/$Backend"
    $marker = Join-Path $target '.version'
    if ((Test-Path $marker) -and (Get-Content $marker) -eq $name) {
        Write-Host "ok        $target"
        return
    }

    foreach ($zip in $archives.Keys) {
        Get-VerifiedFile "https://github.com/0xShug0/audio.cpp/releases/download/v$Version/$zip" (Join-Path $root "runtime/$zip") $archives[$zip]
    }
    if (Test-Path $target) { Remove-Item -Recurse -Force $target }
    foreach ($zip in $archives.Keys) {
        Expand-Archive (Join-Path $root "runtime/$zip") $target -Force
        Remove-Item (Join-Path $root "runtime/$zip")
    }
    Set-Content $marker $name
    Write-Host "installed $target"
}

Export-ModuleMember -Function Get-VerifiedFile, Install-Runtime -Variable Version
