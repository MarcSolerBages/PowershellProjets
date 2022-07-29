if ($args.count -gt 0) {
	$sName = $($args[0])
}
if ($args.count -gt 1) {
	$sName = "$sName [$($args[1])]"
}

$cName = HOSTNAME



$sb = [scriptblock]::create("Get-Service -computername $cName -Name $sName")
$job = Start-Job -ScriptBlock $sb | Wait-Job -Timeout 10
if($job -eq $null) {
    Write-Output "KO: Algo falla"
    exit 2
}
else {
     Write-Output "OK: Todo bien"
     exit 0
}