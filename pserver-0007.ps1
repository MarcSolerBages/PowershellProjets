# SCRIPT: check_admin
# VERSION: 1.0

# Cmdlet added
[CmdletBinding()]

<#
PARAMETERS:
(null)
#>

<#
CONSTANTS:
#>
# This array contains the authorised Administrators
$VALID_ADMINS =  @("Administrador", "Admins. del dominio", "Administradores de empresas") 

<#
BODY:
#>
$ADAdmins = Get-ADGroupMember -identity Administradores | Select-Object name # Get admin profiles - Active Directory

$ADAdmins | ForEach-Object {
	if(!($VALID_ADMINS -contains $_.name)) {
		$username = $_.name
		Write-Output "KO: Unauthorized  ADMIN [username: $username]"
		exit 2 # NAGIOS: Critical status
	}
}

Write-Output "OK: Admins checked"
exit 0 # NAGIOS: Service is OK

# END