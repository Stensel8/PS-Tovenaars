# This script should be run after configuring the network interfaces
Write-Output ""
Write-Output ("Status:           {0,-40}" -f "04-Install-Routing.ps1")

# Get the public network interface
$natIPConfiguration = Get-NetIPConfiguration -Detailed | Where-Object {
    ($null -ne $_.IPv4DefaultGateway) 
}
# Enable forwarding
Set-NetIPInterface -InterfaceIndex $natIPConfiguration.InterfaceIndex -Forwarding Enabled

# Get the internal network interface
$lanIPConfiguration = Get-NetIPConfiguration -Detailed | Where-Object {
    ($null -eq $_.IPv4DefaultGateway)
}
# Derive network address from IP address and prefix length
$lanPrefixLength=$lanIPConfiguration.IPv4Address.prefixLength

# Create subnet mask in dotted decimal notation. That feature does not exist in Powershell, we'll have to write our own functionality for this.
# Convert the prefix length into a 32 bit integer, starting with <prefixLength> 1's and filled out with (32-<prefixLength>) 0's
$subnetMaskNumber = [UInt32](([Math]::Pow(2,$lanPrefixLength)-1) * [Math]::Pow(2,32-$lanPrefixLength)) 
# Split this number into 4 bytes:
$subnetMaskBytes=[System.BitConverter]::GetBytes($subnetMaskNumber)
# Reverse the order, needed on Intel based CPUs.
[Array]::Reverse($subnetMaskBytes)
# No need to join the bytes of the subnetmask into a dotted decimal string this time

# Split the IP address of the LAN interface into 4 numbers, convert those numbers to bytes and store them in a byte array
$IPAddressBytes=$lanIPConfiguration.IPv4Address.IPAddress.Split(".") |ForEach-Object { [byte]$_ }

# Create a new array of bytes for the network ID
$networkIDBytes = @()
# Perform a logical AND between the IP address and the subnet mask by octet, store the result in the Network ID bytes
for ($i = 0; $i -lt 4; $i++) {
    $networkIDBytes += $IPAddressBytes[$i] -band $subnetMaskBytes[$i]
}
$networkID= $NetworkIDBytes -join "."

# Now we can use the network ID for setting up routes

$internalIPInterfaceAddressPrefix = $networkID + "/" + $lanPrefixLength

# Now, enable a NAT routing rule
New-NetNAT -Name "NAT" -InternalIPInterfaceAddressPrefix $internalIPInterfaceAddressPrefix