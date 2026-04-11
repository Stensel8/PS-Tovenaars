# De naam van het commando wat we zoeken is Read-Host

# Het scherm leegmaken
Clear-Host

# Code-voorbeelden opvragen met de Get-Help cmdlet
Get-Help -Name Read-Host -Examples

# Voer het cmdlet uit en kijk of je wat kunt intypen
$ip = Read-Host -Prompt "Wat is je IP-adres?"
Clear-Host
Write-Host "IP-adres: $ip"

