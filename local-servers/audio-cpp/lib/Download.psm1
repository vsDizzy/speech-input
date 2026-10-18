$Version = '0.9.2'

# Release archives per backend, with the release's asset digests; all are flat and unpack into one folder.
# The CUDA cudart archive carries the CUDA runtime DLLs.
$Runtimes = @{
    'vulkan' = [ordered]@{
        "audio-v$Version-bin-windows-x64-vulkan.zip"      = '271402eae94195b9e2204e9f07e576bd0df879c75bafb0fa2f940830648d63f9'
    }
    'cuda'   = [ordered]@{
        "audio-v$Version-bin-windows-x64-cuda13.3.zip"    = 'ddf7474656e4c47a1bc5b5a53a268709d968d87132367d646baae5a77c34391f'
        "audio-v$Version-cudart-windows-x64-cuda13.3.zip" = 'f3bb616e43f4b8aec4be7f2c2b323aec381a1993bac382401a011c121c126e59'
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

Export-ModuleMember -Function Get-VerifiedFile, Install-Runtime
