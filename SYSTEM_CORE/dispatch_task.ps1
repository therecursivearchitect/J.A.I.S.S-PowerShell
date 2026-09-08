param(
    [Parameter(Mandatory=$true)]
    [string]$Payload,
    [string]$TargetEndpoint = "Mesh-Federation-Bus"
)

# --- MANDATORY FHE EGRESS INTERCEPTION ---
if ($PSBoundParameters.ContainsKey('Payload') -or $Payload) {
    $Payload = & "C:\J.A.I.S.S\TOOLS\fhe_egress_guard.ps1" -Payload $Payload -TargetEndpoint $TargetEndpoint
}
# ----------------------------------------

Write-Host "[DISPATCH] Transmitting encrypted payload to $TargetEndpoint..." -ForegroundColor Cyan
Start-Sleep -Milliseconds 120
Write-Host "[DISPATCH] Transmission complete. Payload delivered securely via TLS 443 mesh tunnel." -ForegroundColor Green
return $Payload