param (
    [string]$filePath,
    [switch]$verbose,
    [string]$outfile
)

if ($verbose) { Write-Output "Reading file: $filePath" }

# Read the file content
$fileContent = Get-Content -Path $filePath -Raw

if ($verbose) { Write-Output "File content read successfully." }

# Normalize newlines to `\n` for consistent splitting
$fileContent = $fileContent -replace "\r\n", "`n" -replace "\r", "`n"

# Split the content by empty lines and filter out empty or newline-only elements
$elements = ($fileContent -split "(`n){2,}").Where({ $_.Trim() -ne "" })

$length = $elements.Count

if ($verbose) { Write-Output "File content split into elements." }

# Base64 decode each element
$index = 1
$data = ""
foreach ($element in $elements) {
    try {

        $decodedBytes = [System.Convert]::FromBase64String($element)
        $decodedText = [System.Text.Encoding]::UTF8.GetString($decodedBytes).TrimEnd()
        $data += $decodedText
        if ($verbose) { Write-Output "Partition $index decoded successfully." }
        
        # Append decoded text to the outfile if provided
        if ($outfile) {
            Add-Content -Path $outfile -Value $decodedText -NoNewline
            if ($verbose) { Write-Output "Partition $index appended to outfile: $outfile " }
        }
    } catch {
        if ($verbose) { Write-Output "Failed to decode: $element " }
    }
    $index++
}
$data += "`n"

# Calculate MD5 Hashes of input and output using Linux-style line endings (LF)
$md5 = [System.Security.Cryptography.MD5]::Create()
$fileContent = Get-Content -Path $filePath -Raw
$normalizedContent = $fileContent -replace "\r\n", "`n" -replace "\r", "`n"
$normalizedBytes = [System.Text.Encoding]::UTF8.GetBytes($normalizedContent)
$hashBytes = $md5.ComputeHash($normalizedBytes)
$inputHashString = [BitConverter]::ToString($hashBytes) -replace '-', ''

$normalizedContent = $data -replace "\r\n", "`n" -replace "\r", "`n"
$normalizedBytes = [System.Text.Encoding]::UTF8.GetBytes($normalizedContent)
$hashBytes = $md5.ComputeHash($normalizedBytes)
$outputHashString = [BitConverter]::ToString($hashBytes) -replace '-', ''

Write-Output "--------------------------------------------"
Write-Output "    Finished decoding $length partitions."
Write-Output "    MD5 checksum of the input file (LF): $inputHashString"
Write-Output "    MD5 checksum of the decoded data (LF): $outputHashString"


if ($outfile) {
    # Append new line to the end of the file.
    Add-Content -Path $outfile -Value ""
    Write-Output "    Data written to: $outfile"

    Write-Output "--------------------------------------------"
}else{
    Write-Output "--------------------------------------------"
    Write-Output $data
}
    