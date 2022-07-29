# SCRIPT: check_DNS_temps_resolucio

<#PARAMETERS:
- domini: Domini on s'executa l'script
- dnsserver: Servidor al que farem el ping
#>

##AGAFEM LA IP DEL HOST
$ip = Test-Connection -ComputerName (hostname) -Count 1  | Select-Object IPV4Address | Select-String -Pattern "10.79"
$regex = [regex] "\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b"
$ip = $regex.Matches($ip) | %{ $_.value}



if ($ip -eq "10.79.10.50"){
	$domini = "contingencia.local"
} else{
	$domini = "semcat.local"
}


<#
VARIABLES:
- measurement -> Cadascuna de les mesures
- totalmeasurement -> Aquí sumarem per trobar la mesura total
- timeout -> 3 segons de timeout
#>
$measurement

<#
GLOBAL VARIABLES: 0 = OK, 1 = WARNING, 2 = CRITICAL, 3 = UNKNOWN (Unused for now)
#>
# NAGIOS status
[int] $NAGIOS_OK = 0
[int] $NAGIOS_WARNING = 1
[int] $NAGIOS_CRITICAL = 2
[int] $NAGIOS_UNKNOWN = 3


# FUNCTION: HandleNagiosExitCodes
# Description: Aquesta funció s'encarrega d'agafar el que tenim d'output i processar la sortida.
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
			echo $exitMessage
			exit 1 # NAGIOS: Service has a WARNING
		}
		$NAGIOS_CRITICAL {
			echo $exitMessage
			exit 2 # NAGIOS: Service is in a CRITICAL status.
		}
		Default {
			echo $exitMessage
			exit 3 # NAGIOS: Service status is UNKNOWN
		}
	}
	# FUNCTION END
}


try {
	$timing = Measure-Command {Resolve-DnsName $domini -Server $ip}
	$measurement = $timing.TotalSeconds
	##$totalmeasurement += $measurement
	##$totalmeasurement = $totalmeasurement / $numberoftests
	$rabo = "DNS Server: " + $ip + ", Response time: " + $measurement + " seconds" 
	HandleNagiosExitCodes $NAGIOS_OK $rabo
} 
catch {
    HandleNagiosExitCodes $NAGIOS_CRITICAL "KO Couldn't reach DNS"
}
