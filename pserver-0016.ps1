$folder1 = "C:\Program Files (x86)\nxlog\data"
$folder2 = "C:\Program Files\nxlog\data"

$result1 = Test-Path -Path $folder1
$result2 = Test-Path -Path $folder2

if ($result1 -eq $True){
    Write-Output "KO: NXLOG 64b Instalado"
    exit 2
}
elseif ($result2 -eq $True){
    Write-Output "KO: NXLOG 32b Instalado"
    exit 2
}
else{
    Write-Output "OK: NXLOG NO INSTALADO"
    exit 0
}