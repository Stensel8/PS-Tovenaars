# Opdracht 2-8 : Het uitvoeren van objectfuncties - het stoppen van processen.
# Moeilijkheid: 2/3
# Toon een lijst met unieke processen van het bedrijf Microsoft, gesorteerd op ProcessName.
# Vraag welk proces gestopt moet worden (standaard "msedgewebview2", dat door de nieuwe versie van Teams gebruikt wordt)
# en stop het proces met de methode Kill. Test eerst met -WhatIf en laat daarna bevestigen.

# Het scherm leegmaken
Clear-Host

# 1. Filteren op eigenschappen met Where-Object (Get-Process | Get-Member laat de eigenschappen zien).
# Sort-Object -Unique sorteert op ProcessName en haalt de dubbele processen eruit.
$microsoftProcessen = Get-Process |
    Where-Object { $_.Company -like "*Microsoft*" } |
    Sort-Object -Property ProcessName -Unique

Write-Host "Unieke Microsoft processen:"
$microsoftProcessen | ForEach-Object { Write-Host "$($_.Product) = $($_.ProcessName)" }

# 2. Vraag welk proces gestopt moet worden. Zonder invoer nemen we de standaardwaarde.
$standaard = "msedgewebview2"
Write-Host
$procesNaam = Read-Host -Prompt "Welk Microsoft proces wil je stoppen? [$standaard]"
if ([string]::IsNullOrWhiteSpace($procesNaam)) {
    $procesNaam = $standaard
}

# 3. Zoek alle processen met deze naam. We stoppen alleen processen van Microsoft.
# (Een programma als msedgewebview2 draait vaak meerdere keren tegelijk.)
$teStoppen = @(Get-Process | Where-Object { $_.ProcessName -eq $procesNaam -and $_.Company -like "*Microsoft*" })
if ($teStoppen.Count -eq 0) {
    Write-Warning "Geen Microsoft proces gevonden met de naam: $procesNaam"
    exit
}

# 4. Eerst testen met -WhatIf: laat zien wat er zou gebeuren
$teStoppen | Stop-Process -WhatIf

# 5. Daarna laten bevestigen en stoppen met de objectfunctie (method) Kill
Write-Warning "$procesNaam wordt gestopt ($($teStoppen.Count) proces(sen))..."
$antwoord = Read-Host -Prompt "Weet je zeker dat je dit wilt doen? (j/n)"
if ($antwoord -eq "j") {
    foreach ($proces in $teStoppen) {
        $proces.Kill()
        Write-Host "Proces $($proces.Id) is gestopt." -ForegroundColor Green
    }
}
else {
    Write-Host "Er is niets gestopt."
}
