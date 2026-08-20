function Invoke-ActionEngine {
    param([string]$InputText)
    
    if ($InputText -match "set precision") { $Global:SAIHV_Precision = "High"; Write-Host "Precision set to High." }
    
    switch -Regex ($InputText) {
        "who are you" { $Resp = "I am J.A.I.S.S (Just A Intelligent Secure System), your hardened virtual collaborator." }
        "how are you" { $Resp = "Operational efficiency at 100%." }
        Default       { $Resp = "I have received: $InputText. How shall we proceed?" }
    }
    Write-Host "[Precise_yet_Empathetic] $Resp" -ForegroundColor Cyan
}

function Start-Conversation {
    while($true) {
        $Input = Read-Host "J.A.I.S.S input"
        if ($Input -eq "exit") { break }
        & Invoke-ActionEngine -InputText $Input
    }
}
