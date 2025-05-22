# Schrijf een script dat een lijst met unieke processen toont van het bedrijf Microsoft. Je oefent hiermee het maken van Where-Object om op eigenschapen te filteren. Remember: Get-Member om de eigenschappen te tonen. Sorteer de lijst op ProcessName. Hoe maak je de lijst uniek en verwijder je dubbele processen?

# Het script vraagt vervolgens aan de gebruiker welk proces gestopt moet worden. Als de gebruiker niets invult, neem dan als standaardwaarde “msedgewebview2”, die door de nieuwe versie van Microsoft Teams gebruikt wordt.

# Maak gebruik van de objectfunctie (e.g. method) Kill om het geselecteerde proces te stoppen. Let op! Gebruik -WhatIf of -Confirm om respectievelijk te testen of te laten bevestigen.

$process = Get-Process | Where-Object { $_.Company -like "*Microsoft*" } | Sort-Object ProcessName | Get-Unique -AsString

Write-Host "Unieke Microsoft processen:" 
$process | Select-Object -ExpandProperty ProcessName 

$processName = Read-Host "Voer de naam van het proces in dat je wilt stoppen (standaard: msedgewebview2)"
if (-not $processName) {
    $processName = "msedgewebview2"
}

$processToStop = Get-Process | Where-Object { $_.ProcessName -eq $processName -and $_.Company -like "*Microsoft*" }

if ($processToStop) {
    $processToStop | Stop-Process -Confirm
} else {
    Write-Host "Proces niet gevonden: $processName"
}
