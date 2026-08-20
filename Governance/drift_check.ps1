# J.A.I.S.S Drift Governor
# Monitors for directory drift and namespace consistency
Write-Host "Running Governance Drift Check..." -ForegroundColor Yellow
if (Test-Path "C:\J.A.I.S.S\LAB\Core\Logic\Kernel_Logic.ps1") {
    Write-Host "[STATUS] Kernel Logic Stable" -ForegroundColor Green
} else {
    Write-Host "[ALERT] Kernel Logic missing or moved!" -ForegroundColor Red
}
