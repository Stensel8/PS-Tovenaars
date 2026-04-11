# Het scherm leegmaken
Clear-Host

#Opdracht 3-3 : Het opvragen van Firewall regels met de module NetSecurity.


#  Help opvragen voor Get-Module
# Get-Help Get-Module

# Firewall rules opvragen

Get-NetFirewallPortFilter | Where-Object { $_.LocalPort -eq 80} | Get-NetFirewallRule | Select-Object -Property Name, Displayname

# En om verder te verfijnen met Select-Object
Get-NetFirewallPortFilter | Where-Object { $_.LocalPort -eq 80} | Get-NetFirewallRule | Select-Object -Property Name, Displayname, Direction, PrimaryStatus
