#This is used to execute the command and assign the result to the $output variable
$output =  dfsrdiag PollAD

$output = $output -replace '(?m)^\s*?\n'

$output = $output | Select-String -Pattern "correctamente"

#If the substring we're looking for is contained within the output, then we know that the files have been properly transfered
if ($output -match $sentence){
    Write-Output "La replica va perfectamente"
    exit(0)
}
else{
    Write-Output "No se han transferido correctamente los ficheros"
    exit(2)
}