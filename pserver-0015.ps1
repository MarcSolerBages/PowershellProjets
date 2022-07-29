$result = Get-CimInstance SoftwareLicensingProduct -Filter "Name like 'Windows%'" | where { $_.PartialProductKey } | select LicenseStatus

if ($result -Match "1"){
    Write-Output "OK: Windows activado"
    exit 0
} else {
    Write-Output "KO: Windows no activado"
    exit 2
}