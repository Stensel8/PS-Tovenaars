# Make sure Write-Informatino also writes to screen
$InformationPreference="Continue"

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


#region Configure network environment
# First, inspect network environment. It SHOULD consist of 2 network adapters, 1 connected to NAT with DHCP, 1 connected to Host-Only without DHCP
# If environment is set up correctly, assign the correct IP parameters to the network interfaces and rename them

# Get IP configuration of network adapter with DHCP and IPv4 default gateway - this will be the Internet interface, using the NAT virtual network
$natIPConfiguration = Get-NetIPConfiguration -Detailed | Where-Object {
    ($null -ne $_.IPv4DefaultGateway) -and ("Enabled" -eq $_.NetIPv4Interface.DHCP)
}
# Get IP configuration of network adapter without IPv4 default gateway - this will be the LAN interface, using a Host-Only virtual network
$lanIPConfiguration = Get-NetIPConfiguration -Detailed | Where-Object {
    ($null -eq $_.IPv4DefaultGateway) 
}

#region Check NAT network
switch ($natIPConfiguration.Count) {
    0 {
         # No DHCP / gateway combination found
         Write-Information "Not connected to VMWare NAT interface, or VMWare NAT interface not configured to provide DHCP addresses"
         Write-Information "Correct this in the VMWare Network Editor and/or the settings of this virtual machine"
         Write-Information "Start this script again after fixing. Rebooting the VM is not necessary."
         Write-Information "Now exiting script."
         exit
    }
    1 { # NAT IP correctly configured. Now checking for second network interface. It should NOT have its IP address provided by DHCP, and it should NOT have a default gateway
        # Break out of switch statement, we'll check the LAN configuration after switch is completed
        # No statement needed here
    }
    Default {
        # 2 or more network interfaces having DHCP + default gateway. This configuration is also not correct and has to be fixed before continuing.
        Write-Information "Multiple interfaces have IP address AND default gateway provided by DHCP - not able to select NAT interface"
        Write-Information "There should only be 1 network interface with both IP and default gateway provided by DHCP."
        Write-Information "The second interface should NOT have an IP address provided by DHCP"
        Write-Information "Correct this in the VMWare Network Editor and/or the settings of this virtual machine"
        Write-Information "Start this script again after fixing. Rebooting the VM is not necessary."
        Write-Information "Now exiting script."
        exit
    }
}
#endregion Check NAT configuration

#region Check LAN configuration

# There should be only one interface without default gateway
switch ($lanIPConfiguration.Count) {
    0 {
        # No 2nd interface
        Write-Information "Not connected to host-only network."
        Write-Information "Correct this in the settings of this virtual machine"
        Write-Information "Start this script again after fixing. Rebooting the VM is not necessary."
        Write-Information "Now exiting script."
        exit
    }
    1 {
        # 1 additional interface detected. Check for DHCP provided IP address.
        if ("Enabled" -eq $lanIPConfiguration.NetIPv4Interface.DHCP) {
            # DHCP enabled, now check for APIPA address
            # If no APIPA address, IP address is provided by DHCP, which is wrong.
            if (!$lanIPConfiguration.IPv4Address.IPAddress.StartsWith("169.254")) { 
                #not an APIPA address, so have the user correct this
                Write-Information "Host-only network is DHCP enabled, which will interfere with the setup."
                Write-Information "Disable DHCP on the host only network in the virtual network editor."
                Write-Information "Start this script again after fixing. Rebooting the VM is not necessary."
                Write-Information "Now exiting script."
                exit
            }
            # Correctly configured, continue
        }
        # Correctly configured, continue
    }
    Default {
        # More than 1 additional interface, have the user correct this.
        Write-Information "More than 1 network interface connected to host-only network."
        Write-Information "Correct this in the settings of this virtual machine"
        Write-Information "Start this script again after fixing. Rebooting the VM is not necessary."
        Write-Information "Now exiting script."
        exit
    }
}
#endregion Check LAN configuration
#region Install Powershell 7
# Downloads the install-powershell script from Microsoft and executes it, using the MSI installer, in quiet mode.
# This is an example of invoking a REST API - more on that later in this course.
# Download and installation are called before setting up the network interfaces, since that setup takes place asynchronously
# Starting Invoke-RestMethod while the network setup hasn't been completed will not work.
Invoke-Expression "& { $(Invoke-RestMethod 'https://aka.ms/install-powershell.ps1') } -UseMSI -Quiet"

#endregion

#region Set up Internet network interface
# split IP address of internet interface into octets:
$octets = $natIPConfiguration.IPv4Address.IPAddress.split(".")
# define new IP address by setting the last octet to 11
$octets[-1] = "11"
$newIPAddress=$octets -join "."
# get the current default gateway, we'll reuse it
$gateway=$natIPConfiguration.IPv4DefaultGateway.NextHop
# get the current CIDR prefix length, we'll reuse it
$prefixLength = $natIPConfiguration.IPv4Address.prefixLength
# get the list of DNS server addresses specified on this adapter, we'll reuse the list:
$DNSServerAddresses=Get-DnsClientServerAddress -InterfaceIndex $natIPConfiguration.InterfaceIndex -AddressFamily IPv4
# Copy the list into a string array, so we can add the Google DNS servers to the list
$DNSServerArray=@() # declare empty array
foreach($address in $DNSServerAddresses.ServerAddresses) {
    $DNSServerArray+=$address
}
# Add the Google DNS servers, if they are not present yet.
if (!$DNSServerArray.contains("8.8.8.8")) {
    $DNSServerArray+="8.8.8.8"
}
if (!$DNSServerArray.contains("8.8.4.4")) {
    $DNSServerArray+="8.8.4.4"
}
# Now set up the adapter
# rename interface
Rename-NetAdapter -Name $natIPConfiguration.InterfaceAlias -NewName "Internet"
# set IP address
New-NetIPAddress  -InterfaceAlias "Internet" -AddressFamily IPv4 -IPAddress $newIPAddress -DefaultGateway $gateway -PrefixLength $prefixLength
# set DNS server addresses. 
Set-DnsClientServerAddress -InterfaceAlias "Internet" -ServerAddresses $DNSServerArray
#endregion Set up Internet network interface

#region Configure LAN interface
#endregion Configure LAN interface

# specify new IP address for LAN interface
# by default, use 192.168.100.11
# if in use for Internet interface, use 192.168.200.11
if ("192.168.100.11" -eq $newIPAddress) {
    $newIPAddress = "192.168.200.11"
} else {
    $newIPAddress = "192.168.100.11"
}
Rename-NetAdapter -Name $lanIPConfiguration.InterfaceAlias -NewName "LAN"
New-NetIPAddress -InterfaceAlias "LAN" -AddressFamily IPv4 -IPAddress $newIPAddress -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias "Internet" -ServerAddresses $DNSServerArray

#endregion Configure network environment




# Next section: rename computer and reboot

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

# Select new computer name. Default name is SXN-DC-01, but it can be changed by the user. Repeat until a valid name is chosen
$defaultComputerName = "SXN-DC-01"
do {
    $newComputerName = Read-Host -Prompt "Enter the new name for this computer (default is $defaultComputerName): "
    if ($newComputerName -eq '') { $newComputerName=$defaultComputerName }    
    $result = Assert-ValidComputerName -computerName $newComputerName
}
while (!$result) 

# Rename and reboot the local computer.  After reboot, Powershell 7 is available by running "pwsh" from the command prompt,
Rename-Computer -NewName $newComputerName -Restart


