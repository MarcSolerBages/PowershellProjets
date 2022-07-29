#This is used to execute the command and assign the result to the $output variable
$output = repadmin /showrepl

#We count how many times each of our looked for patterns (succesful and via RPC) appear on the terminal output.
$successful_count = ([regex]::Matches($output, "successful" )).count
$rpc_count = ([regex]::Matches($output, "via RPC" )).count


#If the substring we're looking for is contained within the output, then we know that this computer will be vulnerable 
if ($rpc_count -eq $successful_count){
    Write-Output "OK"
    exit(0)
}
else{
    Write-Output "Algo falla"
    exit(2)
}
