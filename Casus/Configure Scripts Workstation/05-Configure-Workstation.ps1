#region Check for running as admin
# Verify Running as Admin. Needed to change system properties, install powershell7 and so on.

$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
If (-not $isAdmin) {
    Write-Host "-- Restarting as Administrator" -ForegroundColor Cyan ; Start-Sleep -Seconds 1

    if($PSVersionTable.PSEdition -eq "Core") {
        Start-Process pwsh.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs 
    } else {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs 
    }

    exit
}
#endregion

# Install Powershell 7, latest version
Invoke-Expression "& { $(Invoke-RestMethod 'https://aka.ms/install-powershell.ps1') } -UseMSI -Quiet"

# Choose new computer name
# Helper function to check whether a computer name is valid. Used when asking for a new computer name
function Assert-ValidComputerName {
    param (
        [String] $computerName
    )

    # Check length: minimum 2, maximum 14
    . {$valid = ($computerName.Length -ge 2) -and ($computerName.Length -le 14)
    # check for invalid characters using regular expressions. 
    # Valid characters are: first and last character alphanumeric, characters in between alphanumeric or '-'
    $valid = $valid -and ($computerName -match "^[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9]$") 
    } | Out-Null
    return $valid
}

# Select new computer name. Default name is SXN-WS-01, but it can be changed by the user. Repeat until a valid name is chosen
$defaultComputerName = "SXN-WS-01"
do {
    $newComputerName = Read-Host -Prompt "Enter the new name for this computer (default is $defaultComputerName): "
    if ($newComputerName -eq '') { $newComputerName=$defaultComputerName }    
    $result = Assert-ValidComputerName -computerName $newComputerName
    if (!$result) {
        Write-Host "Invalid computer name"
    }
}
while (!$result) 
# Inform the user about the impending reboot and ask for permission
Write-Host "The computer will be renamed to '$newComputerName' and will need to reboot. Do you want to continue? (Y/N)" -ForegroundColor Yellow
$confirmation = Read-Host

if ($confirmation -match '^[Yy]') {
    # Rename the computer and reboot
    Rename-Computer -NewName $newComputerName -Force -Restart
    exit
} else {
    Write-Host "Operation cancelled. The computer will not be renamed or rebooted." -ForegroundColor Cyan
    exit
}

# Install Active Directory management tools, needed to detect running Active Directory domains
Add-WindowsCapability -Online -Name RSAT.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 

# Import module ActiveDirectory
Import-Module -Name ActiveDirectory

# Get the IP address of our DNS server
$IPConfiguration = Get-NetIPConfiguration -Detailed | Where-Object {
    ($null -ne $_.IPv4DefaultGateway) -and ("Enabled" -eq $_.NetIPv4Interface.DHCP)
}
# The first entry in the list of DNS servers should be the IP address of the DNS server running Active Directory
$DNSServerAddress=(Get-DnsClientServerAddress -InterfaceIndex $IPConfiguration.InterfaceIndex -AddressFamily IPv4).ServerAddresses[0]

# Get the host name of the DNS server - it should be the Active Directory Domain Controller
$serverName = [System.Net.Dns]::GetHostByAddress($DNSServerAddress).HostName

# Get the domain name from the host
$domainName = (Get-ADDomain -Server $serverName -Credential (Get-Credential)).DNSRoot

# Rename the computer, join the domain, and reboot.
Add-Computer -ComputerName $env:COMPUTERNAME -DomainName $domainName -NewName $newComputerName -Credential administrator@$domainName -Restart