#$patterns = "jlopez","xlopez","xangelet","jlmallo","dgalindo","rsegura","tlopez","ecastaneda","dvillora","hmarti","msoasddler"
#$lines = quser | Select-String '(\w+)' | ForEach-Object { $_.Matches[0].Groups[1].Value } | Select-Object -skip 1 | Out-String
#$ips_mal = @(Get-NetTCPConnection -State Established -LocalPort 3389 | Select-Object RemoteAddress) | Out-String
#$splitstuff = $ips_mal.split("`n")
#$length = $ips_mal.length / 6
#$ips_bien = New-Object String[] $length
#$connected_users = New-Object String[] $length
#$counter = 0
#$losOkeis = @()
#$losKaos = @()
#$users = @()
#$all_good = $true
#$ips_output


#if ($lines -eq $null) { Write-Output "Nadie conectado"
#    exit 0
#} else {
#    $ips_bien = $ips_mal.split("`n")
    #A partir del 3 és on comencen les IPs. L'1 i el 2 són "RemoteAddress" i "--------------------"
#    foreach ($ip in $ips_bien){
#        if ($counter -gt 2){
#            $ip = $ip -replace "`n" -replace "`r"
#            if ($ip -ne ""){
#                $ips_output = "$ips_output $ip - "
#            }
#        }
#        $counter = $counter + 1
#    }
#    $connected_users = $lines.split("`n")
#    foreach($user in $connected_users){
#        $user = $user -replace "`n" -replace "`r"
#        if ($patterns -Contains $user){
#            $losOkeis += $user
#        } else {
#            $losKaos += $user
#            if ($user -ne ""){
#                $losKaos += " - "
#            }
#            $all_good = $false
#        }
#    }
#}

#$ips_output = $ips_output -replace "-"
#$losKaos += $ips_output

#if (!$all_good) { 
#    Write-Output "KO: $losKaos"
#    exit 2
#} else { 
#    Write-Output "OK: todo bien"
#    exit 0
#}




    #No sé si tal com està això funcionarà, s'ha de provar.
#    foreach ($line in $lines) {
#        $users = $line.split("`n")
#        foreach ($user in $users) {
#            $trueuser = $user -replace "`n"
#            Write-Output "$trueuser PENIS"
#            if ($patterns.Contains($trueuser)) {
#                $losOkeis = $patterns
#            } else {
#                Write-Output "BRUH MOMdaENT"
#	            $ipnum = $ips_bien[$counter]
#                Write-Output "IP: $ips_bien"
#                $add = "$trueuser $ipnum"
#	            $body = $add -replace "`n" -replace "`r"
#                $losKaos += $body
#                $counter = $counter + 1
#            }
#        }
#    }
#}


#if ($losOkeis.Length -eq 0) { 
#    Write-Output "KO: $losKaos"
#    exit 2
#} else { 
#    Write-Output "OK: todo bien"
#    exit 0
#}










$patterns = 'jlopez','xlopez','xangelet','dgalindo','rsegura','jlmallo', 'tlopez', 'ecastaneda', 'msoler', 'dvillora', 'hmarti'
$lines = quser | Select-String '(\w+)' | ForEach-Object { $_.Matches[0].Groups[1].Value } | Select-Object -skip 1
#$ips_mal = @(Get-NetTCPConnection -State Established -LocalPort 3389 | Select-Object RemoteAddress) | Out-String
#$ips_bien = @()
#$counter = 0
$losOkeis = @()
$losKaos = @()

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
        }
    }
}

if ($losOkeis.Length -eq 0) { 
    Write-Output "KO: $losKaos"
    exit 2
} else { 
    Write-Output "OK: todo bien"
    exit 0
}