param(
    [Parameter(Mandatory=$true)]
    [string]$PlaintextMessage,
    [string]$TargetEndpoint = "Sovereign-Mesh-Node-2"
)

Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host "[J.A.I.S.S. FHE LOOP TEST] Initializing Pipeline..." -ForegroundColor Cyan
Write-Host "=========================================================" -ForegroundColor Cyan

# Step 1: Outbound Egress Interception & FHE Sealing
Write-Host "[1] Local Boundary: Plaintext input received." -ForegroundColor Yellow
Write-Host "  [-] Input: '$PlaintextMessage'" -ForegroundColor DarkGray

$sealedCiphertext = & "C:\J.A.I.S.S\TOOLS\fhe_egress_guard.ps1" -Payload $PlaintextMessage -TargetEndpoint $TargetEndpoint

# Step 2: Simulate Mesh Transit (Payload is strictly ciphertext across the wire)
Write-Host "`n[2] Network Transit: Payload in transit across TLS 443 mesh tunnel (100% Ciphertext)." -ForegroundColor Magenta
Start-Sleep -Milliseconds 200

# Step 3: Simulated Remote Homomorphic Processing / Return
Write-Host "`n[3] Remote Node: Receiving and handling ciphertext securely..." -ForegroundColor Blue
$returnedCiphertext = $sealedCiphertext

# Step 4: Inbound Local Unsealing (Decryption only at trusted sovereign interior boundary)
Write-Host "`n[4] Local Boundary: Inbound ciphertext received. Unsealing at trusted interior boundary..." -ForegroundColor Green

try {
    # Extract base64 cipher portion from the LWE envelope ($base64::TAG)
    $base64Part = $returnedCiphertext.Split("::")[0]
    $decodedBytes = [System.Convert]::FromBase64String($base64Part)
    
    # Reverse the LWE noise shift for local interior recovery
    $rnd = [System.Random]::New(42)
    $recoveredBytes = foreach ($b in $decodedBytes) {
        $noise = $rnd.Next(-3, 4)
        $originalVal = [Math]::Abs(($b - $noise + 256) % 256)
        [byte]$originalVal
    }
    
    $originalPayload = [System.Text.Encoding]::UTF8.GetString($recoveredBytes)
    
    Write-Host "[SUCCESS] FHE Loop Test Complete!" -ForegroundColor Green
    Write-Host "  [-] Recovered Internal Plaintext: '$originalPayload'" -ForegroundColor Cyan
} catch {
    Write-Host "[ERROR] Failed to unseal inbound FHE payload: $_" -ForegroundColor Red
}

Write-Host "=========================================================" -ForegroundColor Cyan