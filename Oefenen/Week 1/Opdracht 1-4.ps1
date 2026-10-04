# Opdracht 1-4 : Vraag de gebruiker om een IP-adres in te toetsen.
# Moeilijkheid: 1/3

# Het scherm leegmaken
Clear-Host

# 1. Zoeken naar de cmdlet waarmee je gegevens kunt uitlezen. De naam is Read-Host.
Get-Help read
# Get-Command *read*

# 2. De code-voorbeelden opvragen
Get-Help -Name Read-Host -Examples

# 3. Vraag om een IP-adres en zet het antwoord in de variabele $ip.
# Zonder de variabele "$ip =" gebeurt er niets met wat je intypt.
$ip = Read-Host -Prompt "Vul je IP-adres in"

# 4. Print de variabele op het scherm
Write-Host "Het IP-adres dat je hebt ingevuld is: $ip"
