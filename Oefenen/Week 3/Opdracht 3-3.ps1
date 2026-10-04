# Opdracht 3-3 : Het opvragen van Firewall regels met de module NetSecurity.
# Moeilijkheid: 2/3
# (PowerUp) : Laat voor elke firewall-regel ook de gebruikte poort zien
# Sommige firewall commando's werken pas als je PowerShell als administrator start.

# Het scherm leegmaken
Clear-Host

# 1. Welke commando's zijn er rondom modules? Vraag de help op van Get-Module.
# Get-Help Get-Module

# 2. Welke modules gaan over security?
Get-Module -ListAvailable *security*

# 3. Alle commando's van de module NetSecurity, gefilterd op het woord Firewall
Get-Command -Module NetSecurity | Where-Object { $_.Name -like "*Firewall*" }

# 4. Alle firewall regels voor HTTP verkeer: filter op de DisplayName en toon het in een tabel
Get-NetFirewallRule | Where-Object { $_.DisplayName -like "*HTTP*" } |
    Format-Table -Property DisplayName, Direction, Action, Enabled -AutoSize

# 5. De poorten staan niet in de regel zelf maar in het port filter: Get-NetFirewallPortFilter.
# Combineer beide: begin bij de port filters en haal per filter de bijbehorende regel op.
Get-NetFirewallPortFilter | Where-Object { $_.LocalPort -eq "80" } |
    Get-NetFirewallRule |
    Format-Table -Property DisplayName, Direction, Action, Enabled -AutoSize

# 6. Met ForEach-Object laat je per regel ook de poort zien (PowerUp)
Get-NetFirewallPortFilter | Where-Object { $_.LocalPort -eq "80" } | ForEach-Object {
    $regel = $_ | Get-NetFirewallRule
    [PSCustomObject]@{
        DisplayName = $regel.DisplayName
        Direction   = $regel.Direction
        Action      = $regel.Action
        Protocol    = $_.Protocol
        LocalPort   = $_.LocalPort
    }
} | Format-Table -AutoSize
