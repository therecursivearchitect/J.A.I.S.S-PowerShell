# ==============================================================================
# Line 001: Core Root Architecture: [SAIHV-KERNEL-ROOT-001] Direct Native Memory & Hardware Interop Layer
# ==============================================================================

param([switch]$VerboseBoot)

$JAISS_Root = "C:\J.A.I.S.S"
$CoreModule = "$JAISS_Root\Core\JAISS.Engine.psm1"

Write-Host "`n========================================================" -ForegroundColor DarkCyan
Write-Host "       [J.A.I.S.S KERNEL BOOTSTRAPPER INITIALIZING]      " -ForegroundColor Cyan
Write-Host "========================================================`n" -ForegroundColor DarkCyan

if (Test-Path $CoreModule) {
    try {
        Import-Module $CoreModule -Force -ErrorAction Stop
        Write-Host " [+] Core Engine Module Loaded : $CoreModule" -ForegroundColor Green
    } catch {
        Write-Host " [!] FAILED to import Core Engine Module: $_" -ForegroundColor Red
        return
    }
} else {
    Write-Host " [!] Core Engine Module NOT FOUND at $CoreModule" -ForegroundColor Yellow
    return
}

try {
    $BootTimestamp = (Get-Date).ToUniversalTime().ToString("o")
    [JAISS.Engine.ContextBuffer]::Push("System Kernel", "J.A.I.S.S Session Bootstrapped at $BootTimestamp")
    $History = [JAISS.Engine.ContextBuffer]::GetHistory()
    Write-Host " [+] Context Buffer Memory Ring : ACTIVE ($($History.Count) Entry/Entries Cached)" -ForegroundColor Green
} catch {
    Write-Host " [!] Memory Ring Initialization Failed: $_" -ForegroundColor Red
}

$LocalCheck = Invoke-JAISSFullPipeline -userInput "dir C:\J.A.I.S.S\Core"
$CloudCheck = Invoke-JAISSFullPipeline -userInput "Synthesize quantum computing architectures and compare against classical silicon transformers in depth"

Write-Host " [+] Local Route Test            : $($LocalCheck.Target) (Score: $($LocalCheck.Route.ComplexityScore))" -ForegroundColor Green
Write-Host " [+] Cloud Route Test            : $($CloudCheck.Target) (Score: $($CloudCheck.Route.ComplexityScore))" -ForegroundColor Green

Write-Host "`n[J.A.I.S.S KERNEL READY] - System initialized in secure local scope.`n" -ForegroundColor Cyan
