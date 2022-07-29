$result = Get-NetFirewallProfile -all | Select-Object Name, Enabled | Out-String

$occurrences = [regex]::matches($result,"True").count


if($occurrences -eq 3) {
    Write-Output "OK: Todo bien"
    exit 0
}
else {
     Write-Output "KO: Algo falla"
     exit 2
}