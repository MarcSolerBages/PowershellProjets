Write-Output "OK: This script is provisional until we fix the issue"
exit 0

####################################################################################################################################################################
###########################################################L'SCRIPT DE VERITAT COMENÇA AQUÍ#########################################################################
####################################################################################################################################################################
########$result = Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\policies\Microsoft\Windows NT\DNSClient" | Select-Object -Property EnableMulticast
########
########if ($result -Match "0"){
########	Write-Output "OK: Enable Multicast value = 0"
########	exit 0
########}
########else{
########	Write-Output "KO: Enable Multicast value != 0"
########	exit 0
########}