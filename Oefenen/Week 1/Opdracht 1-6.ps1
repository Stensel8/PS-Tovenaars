# Opdracht 1-6 : Doorloop een lijst met IP-adressen en geef een opdracht om deze te pingen.
# Moeilijkheid: 1/3

# Het scherm leegmaken
Clear-Host

# 1. Get-Help ping geeft geen resultaat. Het PowerShell alternatief voor ping is Test-Connection.
# (Cheat-Sheet: ping -> Test-Connection)
# Get-Help Test-Connection -Examples
# Get-Help Test-Connection -Online

# 2. Maak een lijstvariabele $ipaddresses en vul deze met een aantal IP-adressen
$ipaddresses = @("192.168.2.1", "192.168.2.123", "192.168.1.135")

# 3. Doorloop de lijst: print elk IP-adres en ping het 3x via IPv4
# Let op: Test-Connection heeft in PowerShell 5.1 andere parameters dan in PowerShell 7.
foreach ($ip in $ipaddresses) {
    Write-Host $ip
    Test-Connection -TargetName $ip -IPv4 -Count 3
    Write-Host "Klaar met pingen van $ip" -ForegroundColor Blue
    Write-Host # lege regel
}
