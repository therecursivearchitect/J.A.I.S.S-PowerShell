class JAISSFHEWrapper {
    [string] $CipherScheme
    
    JAISSFHEWrapper([string]$scheme) {
        $this.CipherScheme = $scheme
    }

    [string] EncryptPayload([string]$PlainText) {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($PlainText)
        for ($i = 0; $i -lt $bytes.Length; $i++) {
            $bytes[$i] = ($bytes[$i] + 7) -bxor 0xA5
        }
        
        $cipherPacket = @{
            Scheme        = $this.CipherScheme
            Timestamp     = (Get-Date).ToString("o")
            Ciphertext    = [Convert]::ToBase64String($bytes)
            IntegrityHash = ([security.cryptography.sha256]::Create().ComputeHash($bytes) | ForEach-Object { $_.ToString("x2") }) -join ""
        } | ConvertTo-Json -Compress

        return $cipherPacket
    }

    [string] DecryptPayload([string]$CipherJson) {
        $packet = $CipherJson | ConvertFrom-Json
        $bytes = [Convert]::FromBase64String($packet.Ciphertext)

        for ($i = 0; $i -lt $bytes.Length; $i++) {
            $bytes[$i] = ($bytes[$i] -bxor 0xA5) - 7
        }

        return [System.Text.Encoding]::UTF8.GetString($bytes)
    }
}
