$exit_status = 0
$exit_msg = "OK"

if (Test-NetConnection www.google.es -Port 443 | Select -ExpandProperty TcpTestSucceeded) {
	$exit_msg = "KO: El equipo navega"
	$exit_status = 2
}

Write-Output $exit_msg
exit $exit_status