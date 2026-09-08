class JAISSSessionAttestation {
    [string]$NodeId
    [string]$SessionId
    [string]$SessionKey

    JAISSSessionAttestation([string]$id) {
        $this.NodeId = $id
        $this.SessionId = [Guid]::NewGuid().ToString()
        $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::Create()
        $randomBytes = New-Object byte[] 32
        $rng.GetBytes($randomBytes)
        
        $sessionSalt = [BitConverter]::ToString($randomBytes).Replace("-", "").ToLower()
        $dateStr = (Get-Date -UFormat %s)
        $nid = $this.NodeId
        $sid = $this.SessionId
        $combined = "$nid`:$sid`:$sessionSalt`:$dateStr"
        
        $sha = [System.Security.Cryptography.SHA256]::Create()
        $this.SessionKey = [BitConverter]::ToString($sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($combined))).Replace("-", "").ToLower()
    }

    [hashtable] GenerateSessionToken([string]$Payload) {
        $timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        $nid = $this.NodeId
        $sid = $this.SessionId
        $rawMessage = "$nid`:$sid`:$timestamp`:$Payload"
        
        $hmac = [System.Security.Cryptography.HMACSHA256]::new([System.Text.Encoding]::UTF8.GetBytes($this.SessionKey))
        $hashBytes = $hmac.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($rawMessage))
        $signature = [BitConverter]::ToString($hashBytes).Replace("-", "").ToLower()

        return @{
            NodeId        = $this.NodeId
            SessionId     = $this.SessionId.Substring(0, 8) + "..."
            Timestamp     = $timestamp
            ProofSig      = $signature
            PortTunnel    = "443/HTTPS (Firewall & AV Transparent)"
            StateValidity = "Session-Scoped Cryptographic Proof (Portable)"
        }
    }

    [bool] VerifySessionToken([hashtable]$Token, [string]$OriginalPayload, [string]$CheckSessionId) {
        $nid = $Token.NodeId
        $ts = $Token.Timestamp
        $rawMessage = "$nid`:$CheckSessionId`:$ts`:$OriginalPayload"
        $hmac = [System.Security.Cryptography.HMACSHA256]::new([System.Text.Encoding]::UTF8.GetBytes($this.SessionKey))
        $hashBytes = $hmac.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($rawMessage))
        $expectedSig = [BitConverter]::ToString($hashBytes).Replace("-", "").ToLower()

        return ($Token.ProofSig -eq $expectedSig)
    }
}