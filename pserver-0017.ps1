#Comprovem si hi ha arguments
if ($args.count -gt 0) { 
    $file = $($args[0])
}
# Write-Output $file
##No està implementat, però en un futur es podria modificar per dir-li quants minuts de límit volem
#if ($args.count -gt 1) {
#    $timeLimit = $($args[1])
#}


$fileDate = (Get-Item $file).LastWriteTime
$currentDate = Get-Date

$dateDiff = $currentDate - $fileDate

if ($dateDiff.TotalMinutes -lt 1){
    Write-Output "Todo bien. Hace $($dateDiff.TotalSeconds) segundos que se ha actualizado"
    exit 0
}

else{
    Write-Output "Algo falla. No se actualiza desde hace $($dateDiff.TotalSeconds) segundos"
    exit 2
}