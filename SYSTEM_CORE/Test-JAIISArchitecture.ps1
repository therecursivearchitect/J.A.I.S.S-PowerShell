Write-Host "=========================================" -ForegroundColor Magenta
Write-Host " J.A.I.S.S. Multi-Tier Architecture Test" -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Magenta

# 1. Test Tier 1 Runtime Config
$T1ConfigPath = "C:\J.A.I.S.S\LAB\Tiers\Tier1_PublicRuntime\runtime_config.json"
if (Test-Path $T1ConfigPath) {
    Write-Host "[PASS] Tier 1 Public Runtime Config Loaded." -ForegroundColor Green
} else {
    Write-Host "[FAIL] Tier 1 Config Missing!" -ForegroundColor Red
}

# 2. Execute Tier 2 Enterprise Auditor
$T2ScriptPath = "C:\J.A.I.S.S\LAB\Tiers\Tier2_EnterpriseAuditor\Run-SiliconAudit.ps1"
if (Test-Path $T2ScriptPath) {
    Write-Host "[EXEC] Running Tier 2 Silicon Audit..." -ForegroundColor Yellow
    & $T2ScriptPath -CacheLineBytes 64 -TargetHeadroomRatio 0.20
} else {
    Write-Host "[FAIL] Tier 2 Auditor Script Missing!" -ForegroundColor Red
}

# 3. Execute Tier 3 Dormant Synthesis Handshake
$T3ScriptPath = "C:\J.A.I.S.S\LAB\Tiers\Tier3_DormantSynthesis\Invoke-SynthesisHandshake.ps1"
if (Test-Path $T3ScriptPath) {
    Write-Host "[EXEC] Triggering Tier 3 Synthesis Handshake..." -ForegroundColor Yellow
    & $T3ScriptPath -EndpointSignature "RTX_Foundry_Target"
} else {
    Write-Host "[FAIL] Tier 3 Handshake Script Missing!" -ForegroundColor Red
}

Write-Host "=========================================" -ForegroundColor Magenta
Write-Host " Multi-Tier Verification Complete." -ForegroundColor Magenta
Write-Host "=========================================" -ForegroundColor Magenta
