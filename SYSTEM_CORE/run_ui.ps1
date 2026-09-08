# J.A.I.S.S Tactical HUD Runtime with Piper ONNX Voice Integration
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

function Speak-JaceOutput {
    param([string]$text)
    $piperPath = "C:\J.A.I.S.S\Voice\piper.exe"
    $modelPath = "C:\J.A.I.S.S\Voice\en_US-amy-medium.onnx"
    $outWav = "$env:TEMP\jace_voice.wav"
    if ((Test-Path $piperPath) -and (Test-Path $modelPath)) {
        & $piperPath --model $modelPath --output_file $outWav --text "$text"
        if (Test-Path $outWav) {
            (New-Object Media.SoundPlayer $outWav).PlaySync()
        }
    } else {
        Write-Host "Voice assets missing. Text output: $text" -ForegroundColor Yellow
    }
}

Write-Host "Firing up J.A.I.S.S GUI runtime with sovereign voice integration..." -ForegroundColor Cyan
Speak-JaceOutput "J.A.I.S.S heuristic vault online. All systems nominal."
