#Aquest script comprova el FileHash de dos fitxers i comprova que siguin iguals

#Creem la variable file, que deixarem buida.
$file = ""
$result = ""

#Comprovem si hi ha arguments
if ($args.count -gt 0) { 
    $file = $($args[0])
}
if ($args.count -gt 1) {
    $result = $($args[1])
}
# Comanda del HashFile.
$filehash = Get-FileHash $file -Algorithm SHA256 | Select-Object -Property Hash
$resulthash = Get-FileHash $result -Algorithm SHA256 | Select-Object -Property Hash

if ($filehash -Match $resulthash) {
    Write-Output "OK"
    exit 0
}
else {
    Write-Output "KO: El fitxer $file no es correspon amb el fitxer $result"
    exit 2
}