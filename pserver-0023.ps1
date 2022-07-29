########Mete un check en servidor güidous que mire lo siguiente:
########Get-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\policies\Microsoft\Windows NT\DNSClient"
########Si la clave EnableMulticast existe y es 0
########Verde
########Por ahora ponlo siempre verde
########Tiene que llamarse Sec_LLMNR_Stat
Get-Item -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces\tcpip*"
El valor de este tiene que ser 2
Pero hay que ver como ligarlo con la interfaz de red
Se llamará Sec_NetBT_Stat
Correcto
Uno verifica si el estado del LLMNR está disabled y el otro revisar el NetBT
Con checkearlo una vez al día llega
Por ahora te saldrán todos en rojo
Ni correo por ahora
No quiero llenar los buzones
Iremos arreglando la config poco a poco y luego cuando terminemos lo habilitamos para ver que está mal configurado
Y resolver los flecos pendientes
El segundo check hay que ver como ligarlo con la interfaz pública
Dale una vuelta


$result = Get-Item -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces\tcpip*"

if ($result -Match "2"){
	Write-Output "OK: El valor es 2"
	exit 0
}
else{
	Write-Output "KO: El valor no es 2"
	exit2
}
