# Opdracht 1-5 : Start een applicatie en geef argumenten mee
# Moeilijkheid: 2/3
# (PowerUp) : Open naast de Saxion website ook een andere website in een apart tabblad

# Het scherm leegmaken
Clear-Host

# 1. Maak vooraf een variabele voor elk argument.
# Pas $filePath aan als je een andere browser gebruikt (bijv. Brave of Edge).
$filePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$saxionUrl = "https://www.saxion.nl"
$extraUrl = "https://learn.microsoft.com/powershell"

# Stop netjes als de browser niet op deze plek staat
if (-not (Test-Path -Path $filePath)) {
    Write-Warning "De browser is niet gevonden op: $filePath. Pas de variabele `$filePath aan."
    exit
}

# 2. De browser starten met de Saxion website
# Start-Process -FilePath $filePath -ArgumentList $saxionUrl

# 3. (PowerUp) ArgumentList is een array: elke website opent in een eigen tabblad
Start-Process -FilePath $filePath -ArgumentList $saxionUrl, $extraUrl
