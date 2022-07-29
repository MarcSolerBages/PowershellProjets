$connected_users = quser

for ($i=1; $i -lt $connected_users.Count;$i++) {
  # using regex to find the IDs
  $temp = [string]($connected_users[$i] | Select-String -pattern "\s ACTIVO \s").Matches
  $temp = $temp.Trim()
  Write-Output $temp
  if ($connected_users[$i] -NotMatch "\s ACTIVO \s"){
    logoff $temp
  }
}

$users_now = quser

if ($users_now.Count -eq 0){
  Write-Output "OK: Se ha desconectado a los usuarios inactivos y ahora no hay usuarios conectados"
  exit 0
}

else{
  exit 2
}