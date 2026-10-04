# Opdracht 5-1 : Het ophalen en uitvoeren van een installatiebestand.
# Moeilijkheid: 2/3
# Haal een installatiebestand op van het Internet (Chrome), sla het op in de map voor tijdelijke bestanden,
# start de installatie en wacht tot die klaar is, en verwijder daarna het tijdelijke bestand.

# Het scherm leegmaken
Clear-Host

Write-Host "Dit programma start het installatieproces voor de Google Chrome browser."

# Dit script installeert echt software, dus eerst om bevestiging vragen
$antwoord = Read-Host -Prompt "Wil je Chrome downloaden en installeren? (j/n)"
if ($antwoord -ne "j") {
    Write-Host "Afgebroken, er is niets geinstalleerd."
    exit
}

# 1. De downloadlink. De link uit de opdracht (versie 375.126) is oud, deze link geeft altijd de laatste versie.
$url = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"

# 2. Het installatiebestand komt in de gebruikelijke map voor tijdelijke bestanden (omgevingsvariabele TEMP)
$installatieBestand = Join-Path -Path $env:TEMP -ChildPath "chrome_installer.exe"

try {
    # 3. Het bestand ophalen met Invoke-WebRequest
    Invoke-WebRequest -Uri $url -OutFile $installatieBestand -ErrorAction Stop

    # 4. De installatie starten. -Wait zorgt dat het script wacht totdat de installatie klaar is.
    Start-Process -FilePath $installatieBestand -ArgumentList "/silent", "/install" -Wait

    Write-Host "De installatie is voltooid."
}
catch {
    Write-Error "De installatie is mislukt: $($_.Exception.Message)"
}
finally {
    # 5. Het tijdelijke bestand weer weghalen
    if (Test-Path -Path $installatieBestand) {
        Remove-Item -Path $installatieBestand
    }
}
