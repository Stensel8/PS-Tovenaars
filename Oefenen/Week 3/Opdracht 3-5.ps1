# Opdracht 3-5 : Overzicht van alle TCP/IP-poorten die momenteel in gebruik zijn op poort 443, met bijbehorend proces.
# Moeilijkheid: 3/3

# Het scherm leegmaken
Clear-Host

# 1. Welke commando's heeft de module NetTCPIP? Get-NetTCPConnection toont de TCP connecties.
# Get-Command -Module NetTCPIP
# Get-Help Get-NetTCPConnection

# 2. Welke properties heeft een connectie? RemoteAddress en RemotePort laten de externe kant zien.
# Get-NetTCPConnection | Get-Member

# 3. Filter op remote port 443 en toon de ip-adressen met het proces (id) dat het verkeer veroorzaakt
Get-NetTCPConnection -RemotePort 443 | Select-Object -Property RemoteAddress, OwningProcess

# 4. Zet de proces-id's in een lijst. Je krijgt objecten in plaats van getallen, dus gebruik haakjes en
# de dot-notatie om maar 1 eigenschap te selecteren: (commando).OwningProcess
$processIds = (Get-NetTCPConnection -RemotePort 443).OwningProcess | Sort-Object -Unique

# 5. Zoek de bijbehorende procesnamen: een filter met -in vergelijkt een waarde met een lijst
Get-Process | Where-Object { $_.Id -in $processIds } |
    Select-Object -Property ProcessName, Id |
    Sort-Object -Property ProcessName
