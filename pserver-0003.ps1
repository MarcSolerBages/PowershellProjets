$server = HOSTNAME

#Per als servidors de CITRIX caldrà afegir-hi els usuaris que treballen en aquests servidors. El problema és que no sé els noms.
if ($server -Match "CITRIX") {
    $patterns = 'jlopez','xlopez','xangelet','dgalindo','rsegura','jlmallo', 'tlopez', 'ecastaneda', 'msoler', 'dvillora', 'hmarti', 'acd'
}
else {
    $patterns = 'jlopez','xlopez','xangelet','dgalindo','rsegura','jlmallo', 'tlopez', 'ecastaneda', 'msoler', 'dvillora', 'hmarti'
}

$lines = quser | Select-String '(\w+)' | ForEach-Object { $_.Matches[0].Groups[1].Value } | Select-Object -skip 1

$losOkeis = @()
$losKaos = @()
$longitud = 0

# Quan es toqui aquest script: imprimir $lines per veure si quan no hi ha ningú connectat surt "Todo bien" o "No existe usuario para *"

if ($lines -eq $null) { 
    Write-Output "Nadie conectado"
    exit 0
} else {
    foreach ($line in $lines) {
        if ($patterns -Match $line) {
            $losOkeis = $line
        } else {
            $losKaos += $line
            $temp = quser | Select-String -pattern "\s\d+\s"
	    if ($temp -Match "Activo" -or $temp -Match "Active") {
	        $losKaos += ": Active - "
	    } else {
	        $losKaos += ": Inactive - "
            }
        }
    }
}

if ($losOkeis.Length -eq 0) { 
	foreach ($kao in $losKaos) {
		$longitud = $longitud + $kao.Length
		$toPrint = "$($toPrint) $($kao)"
	}
	#Se li ha de sumar la longitud de la llista "losKaos" a la variabke longitud perquè quan s'ajunta la llista es fica un espai entre cada membre de la llista.
	$longitud = $longitud + ($losKaos.Length)
	#Creem la substring de toPrint per eliminar l'últim " - " que hi ha a la string.
    $toPrint = $toPrint.Substring(0, $longitud - 2)
    Write-Output "KO: $toPrint"
    exit 2
} else { 
    Write-Output "OK: todo bien"
    exit 0
}