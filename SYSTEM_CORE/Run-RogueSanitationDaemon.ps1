# Autonomous Rogue Sanitation Daemon
# Runs continuous sweeps to purge unmanaged transient files from the J.A.I.S.S. workspace.
Stop = 'SilentlyContinue'
C:\J.A.I.S.S = 'C:\J.A.I.S.S'
 = @(
    'C:\J.A.I.S.S\Procedure_Library',
    'C:\J.A.I.S.S\Logs',
    'C:\J.A.I.S.S\Cloud_Anchor',
    'C:\J.A.I.S.S\Scripts'
)

while (True) {
     = Get-ChildItem -Path C:\J.A.I.S.S -Recurse -File
    foreach (C:\J.A.I.S.S\Procedure_Library\Silicon_Telemetry_Harvest.txt in ) {
         = False
        foreach ( in ) {
            if (C:\J.A.I.S.S\Procedure_Library\Silicon_Telemetry_Harvest.txt.DirectoryName -like "*") {
                 = True
                break
            }
        }
        if (-not ) {
            Remove-Item -Path C:\J.A.I.S.S\Procedure_Library\Silicon_Telemetry_Harvest.txt.FullName -Force
            Add-Content -Path "C:\J.A.I.S.S\Logs\rogue_sanitation_daemon.log" -Value "2026-08-30T12:53:33.9945295-07:00 | PURGED ROGUE FILE: C:\J.A.I.S.S\Procedure_Library\Silicon_Telemetry_Harvest.txt"
        }
    }
    Start-Sleep -Seconds 60 # Sweep every 60 seconds
}
