Write-Output ""
Write-Output ("Status:           {0,-40}" -f "03-Install-DHCP.ps1")

# Install DHCP Server feature
Install-WindowsFeature -Name DHCP -IncludeManagementTools

# Authorize DHCP server in Active Directory
$DomainControllerName=[System.Net.Dns]::GetHostByName($env:COMPUTERNAME).HostName
Add-DhcpServerInDc -DnsName $DomainControllerName


# Retrieve IP address of LAN network interface
$lanIPConfiguration = Get-NetIPConfiguration -Detailed | Where-Object {
    ($null -eq $_.IPv4DefaultGateway) 
}
# Extract server IP address and subnet mask
$DHCPServerIP = $lanIPConfiguration.IPv4Address.IPAddress

$prefixLength = $lanIPConfiguration.IPv4Address.prefixLength
# Create subnet mask in dotted decimal notation. That feature does not exist in Powershell, we'll have to write our own functionality for this.
# Convert the prefix length into a 32 bit integer, starting with <prefixLength> 1s and filled out with (32-<prefixLenghts) 0s
$subnetMaskNumber = [UInt32](([Math]::Pow(2,$prefixLength)-1) * [Math]::Pow(2,32-$prefixLength)) 
# Split this number into 4 bytes:
$octets=[System.BitConverter]::GetBytes($subnetMaskNumber)
# Reverse the orde, needed on Intel based CPUs.
[Array]::Reverse($octets)
# And join the bytes together to a dotted decimal string
$subnetMask=$octets -join "."

# Get start and end address from server IP address
$octets=$DHCPServerIP.split(".")
$octets[-1]=128
$startAddress=$octets -join "."
$octets[-1]=253
$endAddress=$octets -join "."

# Add the scope
Add-DhcpServerV4Scope -Name $lanIPConfiguration.InterfaceAlias -StartRange $startAddress -EndRange $endAddress -SubnetMask $subnetMask
# Get the scope ID from the newly created scope
$scopeID = (Get-DhcpServerV4Scope | Where-Object -Property Name -eq $lanIPConfiguration.InterfaceAlias).ScopeID
# Set gateway for clients. Gateway is the same as DHCP server, so same IP
Set-DhcpServerV4OptionValue -OptionId 3 -Value $DHCPServerIP -ScopeId $scopeID
# Set DNS server for clients. DNS server is the same as DHCP server, so same IP.
Set-DhcpServerV4OptionValue -OptionId 6 -Value $DHCPServerIP -ScopeId $scopeID