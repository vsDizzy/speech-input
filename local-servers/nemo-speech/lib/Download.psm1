$Version = '0.2.0'

$curl = $IsWindows ? 'curl.exe' : 'curl'

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
    & $curl --fail --location --continue-at - --output $part $Url
    if ($LASTEXITCODE -ne 0) { throw "Download failed: $Url" }
    if (-not (Test-Sha256 $part $Sha256)) {
        Remove-Item $part
        throw "SHA-256 mismatch for $Url"
    }
    Move-Item -Force $part $Destination
}

function Install-Runtime([string]$Backend) {
    if (-not $IsWindows) { throw 'The prebuilt runtime is Windows-only here; on Linux use the Docker image.' }

    $root = Split-Path $PSScriptRoot
    $name = "nemo-speech-$Version-windows-x86_64-$Backend"
    $target = Join-Path $root "runtime/$Backend"
    $marker = Join-Path $target '.version'
    if ((Test-Path $marker) -and (Get-Content $marker) -eq $name) {
        Write-Host "ok        $target"
        return
    }

    $base = "https://github.com/NVIDIA/NeMo-Speech.cpp/releases/download/v$Version"
    $sha256 = ((& $curl --fail --silent --location "$base/$name.zip.sha256") -split '\s+')[0]
    if ($LASTEXITCODE -ne 0 -or -not $sha256) { throw "Cannot read $base/$name.zip.sha256" }

    $zip = Join-Path $root "runtime/$name.zip"
    Get-VerifiedFile "$base/$name.zip" $zip $sha256

    $staging = Join-Path $root 'runtime/.extract'
    if (Test-Path $staging) { Remove-Item -Recurse -Force $staging }
    Expand-Archive $zip $staging
    if (Test-Path $target) { Remove-Item -Recurse -Force $target }
    Move-Item (Join-Path $staging $name) $target
    Remove-Item -Recurse -Force $staging, $zip
    Set-Content $marker $name
    Write-Host "installed $target"
}

Export-ModuleMember -Function Get-VerifiedFile, Install-Runtime
