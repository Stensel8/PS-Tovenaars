# Opdracht 2-7 : WhatIf en Confirm parameters gebruiken
# Moeilijkheid: 1/3
# Probeer dit script ook met dot sourcing te starten (extra punt): . ".\Opdracht 2-7.ps1"
# Daarna kun je de variabelen gebruiken in je venster, bijvoorbeeld $service.Status

# Het scherm leegmaken
Clear-Host

# 1. Sla de service op in een variabele en vraag de status op met de dot-notatie
$service = Get-Service -Name bits
Write-Host "De huidige status van '$($service.DisplayName)' is: $($service.Status)"

# 2. WhatIf: laat zien wat er zou gebeuren, maar voer het niet uit
$service | Stop-Service -WhatIf

# 3. Confirm: vraag eerst om toestemming. Antwoord N als je de service niet echt wilt stoppen.
$service | Stop-Service -Confirm
