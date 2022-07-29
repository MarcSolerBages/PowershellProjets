# SCRIPT: check_ad
# VERSION: 1.0
try{
# Cmdlet added
[CmdletBinding()]

<#
PARAMETERS:
- PathFile: string that contains the directory + file_name where data is stored. In that script we need [ADGrop: [user1, user2, ...], ADGroup2: [...]]
#>
# Param(
	#[Parameter(Mandatory = $True)]
	#[ValidateNotNullOrEmpty()] # Comment that line if this parameter will have an
	#[string]$PathFile="\\semcat.local\semftx\Nagios_Scripts\Servers\pserver.json"
	$PathFile = "\\semcat.local\semftx\Nagios_Scripts\Servers\pserver.json"
# )

<#
GLOBAL VARIABLES:
#>
# NAGIOS status
[int] $NAGIOS_OK = 0
[int] $NAGIOS_WARNING = 1
[int] $NAGIOS_CRITICAL = 2
[int] $NAGIOS_WARNING = 3

# File types
[string] $JSON_TYPE = "json"

# File name
[string] $SCRIPT_NAME = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)

<#
FUNCTIONS
#>

# FUNCTION: HandleNagiosExitCodes
# Description: this function process the exit and handles the message output. Specific for NAGIOS monitoring platform
#
# Parameters:
#   - exitCode: exit code
#   - exitMessage: output message
Function HandleNagiosExitCodes ([int] $exitCode, [string] $exitMessage) {

	# Consideration: in prevision, switch pattern has been created to handle the exit for each NAGIOS service status (in the future)
	switch ($exitCode) {
		$NAGIOS_OK {
			Write-Output $exitMessage
			exit 0 # NAGIOS: Service is OK
		}
		$NAGIOS_WARNING {
			Write-Output $exitMessage
			exit 1 # NAGIOS: Service has a WARNING
		}
		$NAGIOS_CRITICAL {
			Write-Output $exitMessage
			exit 2 # NAGIOS: Service is in a CRITICAL status.
		}
		Default {
			# Number 3
			Write-Output $exitMessage
			exit 3 # NAGIOS: Service status is UNKNOWN
		}
	}
	# FUNCTION END
}

# FUNCTION: CheckPathFile
# Description: this function checks if the specifiqued [directory + file] exists
#
# Parameters:
#   - PathFile: location of the file to check
Function CheckPathFile ([string] $PathFile) {
	$exists = Test-Path $PathFile -PathType Leaf
	return $exists # Retrun: false or true

	# FUNCTION END
}

# FUNCTION: GetJSONfromFile
# Description: this function converts JSON text format into a Power Shell Object
#
# Parameters:
#   - PathFile: location of the file with JSON (must have specific type (.json) and structure (JSON))
Function GetJSONfromFile ([string] $PathFile) {

	# Check file type
	$fileType = $PathFile.Split(".")
	$fileType = $fileType[$fileType.Length - 1]

	if (!($fileType -contains $JSON_TYPE)) {
		HandleNagiosExitCodes $NAGIOS_WARNING "KO - Provided file it's not a JSON type (*.json)"
	}

	# Gets content [JSON -> Object]
	try {
		$JSON_Object = Get-Content -Raw -Path $PathFile | ConvertFrom-Json
	}
 	catch {
		HandleNagiosExitCodes $NAGIOS_WARNING "KO - JSON format is incorrect."
	}
	
	return $JSON_Object
	# FUNCTION END
}

<#
BODY:
	Script structure:
	-----------------------------
	0. Parameters + functions
	(...)
	1. Check path file
	2. Loading Data (from JSON file)
	3. Check [AD Groups - users]
#>


	# 1. Check path file
	if (!(CheckPathFile($PathFile))) {
		HandleNagiosExitCodes $NAGIOS_WARNING "KO - File/directory not found [$PathFile]"
	}

	# 2. JSON Data from a specific file to a Powershell Object
	$JSON_Object = GetJSONfromFile($PathFile)

	# 3. For each AD Droup, it verifies the authorised users (JSON file)
	$UnauthorizedProfiles = "" # Inicialitzation with a empty string
	foreach ($ADGroupName in $JSON_Object.$SCRIPT_NAME.psobject.Properties.name) {
		$AuthorisedMembers = $JSON_Object.$SCRIPT_NAME.$ADGroupName.Username
		
		try {
			# Gets specific identity profiles - Active Directory
			$ADIdentity = Get-ADGroupMember -identity $ADGroupName | Select-Object name 
		}
		catch {
			HandleNagiosExitCodes $NAGIOS_WARNING "KO - Invalid Active Directory query: $_"
		}

		# Compares two arrays: authoried members vs unauthoried ones (exclusion pattern)
		$tmp = $ADIdentity | Where-Object { $AuthorisedMembers -NotContains $_.name }
		if ($null -ne $tmp) { $UnauthorizedProfiles += "-" + $ADGroupName + ": " + ($tmp.name -join ', ') }
	}

	# Check unauthorised profiles inside the
	if ("" -ne $UnauthorizedProfiles) {
		$msg = "KO - Unauthorized  profile/s {" + $UnauthorizedProfiles + "}"
		HandleNagiosExitCodes $NAGIOS_CRITICAL $msg
	}

	# All good
	HandleNagiosExitCodes $NAGIOS_OK "OK: AD Profiles checked"
}
catch {
	HandleNagiosExitCodes $NAGIOS_WARNING ("GLOBAL ERROR: " + $_)
}
# END