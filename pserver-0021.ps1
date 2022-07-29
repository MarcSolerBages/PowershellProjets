Write-Output "BON DIA"
Restart-Service -Name nscp
Write-Output "BRUH"

##if ($result -Match "'.'"){
##	Write-Output "No se ha podido reiniciar NSCP"
##	exit (2)
##}
##else {
##	Write-Output "Se ha reiniciado NSCP"
##	exit (0)
##}