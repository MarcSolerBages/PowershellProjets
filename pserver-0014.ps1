#VARIABLES
#We create an array with all the files in the folders that may be compromised
$files = @(Get-ChildItem "C:\Windows\System32\IME" -Recurse -File | Select-Object FullName | findstr /i DLL)
#We start assuming that everything works properly
$all_good = $true
#We create an array where we will store any possibly harmful files
$mistakes = @()

#We check every file in the $files array for a Signature. If the signature contains the words "Microsoft Windows" and "Microsoft Corporation"
#twice (one for the issuer and one for the subject, then we will know that the file is signed by Microsoft, and therefore isn't harmful.
ForEach ($file in $files) {
    $variable = Get-AuthenticodeSignature $file | Format-List -Property  SignerCertificate | Out-String
    $occ_1 = ([regex]::Matches($variable, "Microsoft" )).count

    #If there's a potentially harmful file, we add it to the array of $mistakes and set $all_good to false
    if ($occ_1 -ne 4){
        $all_good = $false
        $mistakes += $file
    }    
}

#If we've found no potentially harmful files, i.e. no potential security threats, we return an "OK" code and a message saying that everything's fine.
if ($all_good){
    Write-Output "Everything is working correctly. No security issues here"
    exit 0
}
#If there's at least one potentially harmful files, we return a "WARNING" code and a message with said file.
else{
    Write-Output "The following files may present security issues $mistakes"
    exit 1
}