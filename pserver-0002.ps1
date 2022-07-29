$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

try {
    $a = (Get-LocalUser | Select "Name", "Enabled" | Select-String -Pattern "True") -replace '(?m)^\s*?\n'

}
catch {

    Write-Output "Hay algo raro en los caracteres"
    exit 2
}

$b = $a.count

if ($a -match "no se reconoce") {
    Write-Output "Hay algo raro"
    exit 2
}

if ($b -eq 1) { 
    $c = (($a | Select-String -Pattern "Administra[td]or") -replace '(?m)^\s*?\n').count
    if ($c -eq 1) { 
        Write-Output "Todo ok: $a"
        exit 0
    } else {
        Write-Output "Hay algo raro: $a"
        exit 2
    }
} else { Write-Output "Hay algo raro: $a"
    exit 2
}

