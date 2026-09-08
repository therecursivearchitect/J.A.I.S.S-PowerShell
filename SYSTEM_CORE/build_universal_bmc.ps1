# J.A.I.S.S Universal Self-Assembling Bootstrap-Manifest-Compile (BMC) Engine
param(
    [string]$InstallRoot = $(if ($IsWindows) { "C:\J.A.I.S.S" } else { "$env:HOME/.local/share/jaiss" })
)

Write-Host "=== J.A.I.S.S UNIVERSAL BMC BOOTSTRAPPER ===" -ForegroundColor Cyan
Write-Host "Target Installation Root: $InstallRoot"

# 1. Introspect Host OS & ISA
$os = if ($IsWindows) { "Windows" } elseif ($IsMacOS) { "Darwin" } else { "Linux" }
$arch = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString().ToLower()
Write-Host "[SYS-PROBE] Detected OS: $os | Architecture: $arch" -ForegroundColor Green

# 2. Provision Workspace
if (-not (Test-Path $InstallRoot)) {
    New-Item -ItemType Directory -Force -Path $InstallRoot | Out-Null
    New-Item -ItemType Directory -Force -Path "$InstallRoot\Voice" | Out-Null
    New-Item -ItemType Directory -Force -Path "$InstallRoot\Config" | Out-Null
    New-Item -ItemType Directory -Force -Path "$InstallRoot\Core" | Out-Null
}

Write-Host "[SUCCESS] Local heuristic vault environment initialized for $os-$arch." -ForegroundColor Green
