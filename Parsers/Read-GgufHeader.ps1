function Read-GgufHeader {
    param(
        [Parameter(Mandatory = $true)]
        [string]$GgufFilePath
    )

    if (-not (Test-Path $GgufFilePath)) { throw "GGUF file not found at $GgufFilePath" }

    $FileStream = [System.IO.File]::OpenRead($GgufFilePath)
    $BinaryReader = New-Object System.IO.BinaryReader($FileStream)

    $Magic = $BinaryReader.ReadUInt32()
    if ($Magic -ne 0x46554747) {
        $BinaryReader.Close()
        $FileStream.Close()
        throw "Invalid file format. Magic byte mismatch."
    }

    $Version = $BinaryReader.ReadUInt32()
    $TensorCount = $BinaryReader.ReadUInt64()
    $MetadataKVCount = $BinaryReader.ReadUInt64()

    Write-Host "[+] GGUF HEADER VALIDATED:" -ForegroundColor Green
    Write-Host "    - Format Version:  $Version"
    Write-Host "    - Total Tensors:   $TensorCount"
    Write-Host "    - Metadata Items:  $MetadataKVCount"

    $BinaryReader.Close()
    $FileStream.Close()
}
