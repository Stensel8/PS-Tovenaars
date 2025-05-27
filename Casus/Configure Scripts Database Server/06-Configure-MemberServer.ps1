# Install Powershell 7, latest version
Invoke-Expression "& { $(Invoke-RestMethod 'https://aka.ms/install-powershell.ps1') } -UseMSI -Quiet"

# Convert DHCP address to static IP address
# Get current network configuration
$IPConfiguration = Get-NetIPConfiguration -Detailed | Where-Object {
    ($null -ne $_.IPv4DefaultGateway) -and ("Enabled" -eq $_.NetIPv4Interface.DHCP)
}
#region Set up Internet network interface
# split IP address of internet interface into octets:
$octets = $IPConfiguration.IPv4DefaultGateway.NextHop.Split('.')

# loop forever until we break out of it
while ($true) {
# define new IP address setting the last octet to the domain controller host ID +1
    $octets[-1] = ([int]$octets[-1]+1).ToString()
    $newIPAddress=$octets -join "."
    try {
        # check if this IP address is in use
        [System.Net.Dns]::GetHostByAddress($newIPAddress) |Out-Null
    }
    catch {
        # GetHostByAddress failed, so this IP address is free
        # Exit the loop
        break
    }
}
# get the current default gateway, we'll reuse it
$gateway=$IPConfiguration.IPv4DefaultGateway.NextHop
# get the current CIDR prefix length, we'll reuse it
$prefixLength = $IPConfiguration.IPv4Address.prefixLength
# get the list of DNS server addresses specified on this adapter, we'll reuse the list:
$DNSServerArray=(Get-DnsClientServerAddress -InterfaceIndex $IPConfiguration.InterfaceIndex -AddressFamily IPv4).ServerAddresses
# Rename network adapter
Rename-NetAdapter -Name $IPConfiguration.InterfaceAlias -NewName "LAN"
# set IP address
New-NetIPAddress  -InterfaceAlias "LAN" -AddressFamily IPv4 -IPAddress $newIPAddress -DefaultGateway $gateway -PrefixLength $prefixLength
# set DNS server addresses. 
Set-DnsClientServerAddress -InterfaceAlias "LAN" -ServerAddresses $DNSServerArray

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
# Select new computer name. Default name is SXN-DB-01, but it can be changed by the user. Repeat until a valid name is chosen
$defaultComputerName = "SXN-DB-01"
do {
    $newComputerName = Read-Host -Prompt "Enter the new name for this computer (default is $defaultComputerName)"
    if ($newComputerName -eq '') { $newComputerName=$defaultComputerName }    
    $result = Assert-ValidComputerName -computerName $newComputerName
}
while (!$result) 

$domainName='scripting.local' #No elegant way to discover domain, unlike in Windows 11

# Rename the computer, join the domain, and reboot.
Add-Computer -ComputerName $env:COMPUTERNAME -DomainName $domainName -NewName $newComputerName -Credential administrator@$domainName -Restart