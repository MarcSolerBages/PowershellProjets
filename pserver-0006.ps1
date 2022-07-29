$returnState = 0

# $DNS = Get-WmiObject -ComputerName '10.79.5.20' -Namespace 'root\MicrosoftDNS' -Class MicrosoftDNS_AType -Filter "ContainerName='SEMCAT.LOCAL'" | Group-Object IPAddress | Where-Object {$_.Count -gt 1}
$DNS = Get-WmiObject -Namespace 'root\MicrosoftDNS' -Class MicrosoftDNS_AType -Filter "ContainerName='SEMCAT.LOCAL'" | Group-Object IPAddress | Where-Object {$_.Count -gt 1}
$Conocidas = "10.79.17.69", "10.79.12.4", "10.79.5.21", "10.79.5.20", "10.79.64.23", "10.79.3.181", "10.79.3.182", "10.79.5.19", "10.79.4.247", "10.79.4.26", "10.79.6.105", "10.79.6.243", "10.79.6.237", "10.79.6.238", "10.79.5.36", "10.79.5.37", "10.79.6.164", "10.79.6.166", "10.79.64.13", "10.79.4.38"

foreach ($item in $DNS) {
   If ($conocidas -notcontains $item.Name) {
      Write-host "Se ha encontrado el DNS" $item.Name "repetido" $item.count "veces"
      $returnState = 1
   }
}

if ($returnState -eq 0){
   Write-Host "Todo Correcto!"
}

exit $returnState