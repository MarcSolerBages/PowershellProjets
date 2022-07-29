$a = w32tm /query /source
$b = hostname
# Write-Output $b
if ($b -match "SEMCD0[1234567]" -or $b -match "SEMDC08") {
    if ($a -match "rhel.pool.ntp.org" -or $a -match "nettime" -or $a -match "SEMCD0[1234567]") {
        echo "El servidor horario es: $a"
        exit 0
    } else {
        echo "El servidor horario no es el adecuado por B: $a"
        exit 2    
    }

} else {
    #if ($a -match "SEMCD0[1234567]" -or $a -match "SEMDC08") {
    if ($a -match "SEMCD0[1234567]" -or $a -match "SEMDC08" -or $a -match "SEMFTX") { 
        echo "El servidor horario es: $a"
        exit 0
    } else { 
        echo "El servidor horario no es el adecuado por A: $a"
        exit 2
    }
}