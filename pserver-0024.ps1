$processes = @(Get-WmiObject win32_PerfFormattedData_PerfProc_Process -Filter "Name like 'WmiPrv%'" | select Name, PercentProcessorTime, idProcess);

$allGood = 1;

foreach ($process in $processes){
    if ($process.PercentProcessorTime -gt 10){
        Stop-Process -Id $process.idProcess;
	$allGood = 0;
    }
}

if ($allGood -eq 1){
    Write-Output ("No hay ningún proceso ralentizando el sistema");
    exit 0;
}
else{
    Write-Output ("Se ha parado el proceso que ralentizaba");
    exit 0;
}