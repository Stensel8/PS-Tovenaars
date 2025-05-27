# get-command *Module*
# get-help get-module -Full

# get-module -ListAvailable *security*

# get-command -module *Netsecurity* | where-object {$_.Name -like "*firewall*"}

# Get-NetFirewallRule

Get-NetFirewallPortFilter | where-object localport -eq 80 | 
ForEach-Object {
    get-netfirewallrule -instanceid $_.InstanceID
} | format-table InstanceID, Protocol, LocalPort, RemotePort -AutoSize

Get-NetFirewallPortFilter 