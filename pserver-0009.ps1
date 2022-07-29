# SCRIPT: check_ad
# VERSION: 1.0

# Cmdlet added
[CmdletBinding()]

<#
GLOBAL VARIABLES:
#>
# NAGIOS status
[int] $NAGIOS_OK = 0
[int] $NAGIOS_WARNING = 1
[int] $NAGIOS_CRITICAL = 2
[int] $NAGIOS_UNKNOWN = 3

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
			exit $NAGIOS_OK # NAGIOS: Service is OK
		}
		$NAGIOS_WARNING {
			Write-Output $exitMessage
			exit $NAGIOS_WARNING # NAGIOS: Service has a WARNING
		}
		$NAGIOS_CRITICAL {
			Write-Output $exitMessage
			exit $NAGIOS_CRITICAL # NAGIOS: Service is in a CRITICAL status.
		}
		Default {
			# Number 3
			Write-Output $exitMessage
			exit $NAGIOS_UNKNOWN # NAGIOS: Service status is UNKNOWN
		}
	}
	# END
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

try {
	
	# List of unauthorised profiles with DoesNotRequirePreAuth activated
	$notAuthProfiles = Get-ADUser -Filter * -Properties DoesNotRequirePreAuth | Where-Object DoesNotRequirePreAuth -eq $True

	# For each unauthorized profiles gets its name
	$unauthorizedProfiles = ""
	foreach ($user in $notAuthProfiles) {
		$unauthorizedProfiles += $unauthorizedProfiles + ", " + $user.Name 
	}

	# Check unauthorised profiles inside the
	if ("" -ne $unauthorizedProfiles) {
		$msg = "KO - Unauthorized (DoesNotRequirePreAuth) profile/s => {" + $unauthorizedProfiles + "}"
		HandleNagiosExitCodes $NAGIOS_CRITICAL $msg
	}

	# All good
	HandleNagiosExitCodes $NAGIOS_OK "OK: DoesNotRequirePreAuth profiles checked"
}
catch {
	# Global error 
	HandleNagiosExitCodes $NAGIOS_UNKNOWN ("GLOBAL ERROR: " + $_)
}
# END