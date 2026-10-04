# Opdracht 2-2 : Het ophalen van een lijst met services en twee kolommen selecteren
# Moeilijkheid: 1/3
# (PowerUp) : Sorteer de lijst op de kolommen Status en Name

# Het scherm leegmaken
Clear-Host

# 1. Kijk met Get-Member welke kolommen (properties) een service heeft
# Get-Service | Get-Member

# 2. Alle services ophalen en met pipelining de kolommen Status en Name selecteren
$myServices = Get-Service | Select-Object -Property Status, Name

# 3. De lijst tonen door de variabele aan te roepen. Is de lijst gesorteerd op Status? Nee.
Write-Host "========= UNSORTED LIST USING VARIABLE ==========="
$myServices

# 4. (PowerUp) Sorteer de lijst op Status en Name met nog een pipeline
Write-Host "========= SORT BY STATUS ==========="
$myServices | Sort-Object -Property Status, Name
