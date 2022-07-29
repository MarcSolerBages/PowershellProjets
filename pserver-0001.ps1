$a = netsh int ipv4 show dynamicport tcp | Select-String -Pattern "Start|inicio"
$a = $a -replace '(?m)^\s*?\n'
$b = netsh int ipv4 show dynamicport tcp | Select-String -Pattern "49152"
if ($b) { 
	echo "OK: $a"
	exit 0
} else { 
	echo "KO: $a"
	exit 2
}