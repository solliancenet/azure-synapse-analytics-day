Param (
[Parameter(Mandatory=$true)]
[string]
$InputFile
)
Process
{
[string]$inputFilePath = Resolve-Path $InputFile -ErrorAction Stop
[string]$outputFilePath = $inputFilePath + ".hex"
$inputFileStream = [System.IO.File]::Open($inputFilePath, [System.IO.FileMode]::Open)
try
{
$reader = New-Object System.IO.BinaryReader($inputFileStream)
$writer = New-Object System.IO.StreamWriter($outputFilePath)
if ($reader -and $writer)
{
while ($inputFileStream.Position -lt $inputFileStream.Length)
{
$byte = $reader.ReadByte()
$writer.Write([System.BitConverter]::ToString($byte))
}
Write-Host "Generated '$outputFilePath'"
}
}
finally
{
if ($inputFileStream)
{
$inputFileStream.Close()
}
if ($reader)
{
$reader.Close()
}
if ($writer)
{
$writer.Close()
}
}
}