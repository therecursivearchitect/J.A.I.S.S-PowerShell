Clear-Host
Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host "         J.A.I.S.S. PRODUCTION NODE STATUS MONITOR         " -ForegroundColor Cyan
Write-Host "=========================================================" -ForegroundColor Cyan

# Check Task State
$task = Get-ScheduledTask -TaskName "JAISS_Autonomous_Engine" -ErrorAction SilentlyContinue
Write-Host "[*] Scheduled Task: " -NoNewline; Write-Host ($task.State -eq 'Ready' ? 'ACTIVE / READY' : $task.State) -ForegroundColor Green

# Check Port Binding (TCP 8485)
$portConn = Get-NetTCPConnection -LocalPort 8485 -ErrorAction SilentlyContinue
if ($portConn) {
    Write-Host "[*] TCP Listener (Port 8485): " -NoNewline; Write-Host "BOUND (PID: $($portConn.OwningProcess))" -ForegroundColor Green
} else {
    Write-Host "[*] TCP Listener (Port 8485): " -NoNewline; Write-Host "UNBOUND / OFFLINE" -ForegroundColor Red
}

# Check Queue Size
$queuePath = "C:\J.A.I.S.S\LAB\offline_queue.dat"
if (Test-Path $queuePath) {
    $queueLines = (Get-Content $queuePath -ErrorAction SilentlyContinue | Where-Object { $_.Trim() }).Count
    Write-Host "[*] Offline FHE Queue: " -NoNewline; Write-Host "$queueLines encrypted items waiting" -ForegroundColor Yellow
} else {
    Write-Host "[*] Offline FHE Queue: " -NoNewline; Write-Host "Empty (0 items)" -ForegroundColor DarkCyan
}

Write-Host "---------------------------------------------------------" -ForegroundColor DarkGray
Write-Host "Live Mesh Federation Tunnels:" -ForegroundColor Yellow
$meshModule = "C:\J.A.I.S.S\TOOLS\mesh_federation.ps1"
if (Test-Path $meshModule) {
    . $meshModule
    $mesh = New-JAISSMeshFederation
    foreach ($provider in $mesh.Endpoints.Keys) {
        $res = Test-MeshEndpointLive -Mesh $mesh -Provider $provider
        Write-Host "  [+] $provider -> $($res.Status) ($($res.LatencyMs)ms)" -ForegroundColor Cyan
    }
} else {
    Write-Host "  Mesh federation module not found in TOOLS." -ForegroundColor Red
}

Write-Host "---------------------------------------------------------" -ForegroundColor DarkGray
Write-Host "Recent Daemon Activity Log (Tail 3):" -ForegroundColor Yellow
$logPath = "C:\J.A.I.S.S\daemon_activity.log"
if (Test-Path $logPath) {
    Get-Content $logPath -Tail 3
} else {
    Write-Host "No log file found." -ForegroundColor Red
}
Write-Host "=========================================================" -ForegroundColor Cyan