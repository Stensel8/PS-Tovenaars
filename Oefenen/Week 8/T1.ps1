# Proeftoets Scripting met PowerShell - Opgave 1 : Basiselementen (25 punten)
# Een beheerder wil informatie verzamelen over zijn systeem om te kijken of zijn systeem geschikt is
# om bepaalde beheertaken uit te kunnen voeren.
# Let op: vul bij a) je eigen naam en studentnummer in.

# Het scherm leegmaken
Clear-Host

# Het resultaatbestand komt naast dit script te staan
$scriptMap = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$resultaatBestand = Join-Path -Path $scriptMap -ChildPath "T1.result"

# a) Twee variabelen met je eigen gegevens. Laat ze op het scherm zien in een groen lettertype.
$studentnaam = "Voornaam Achternaam"
$studentnummer = "123456"
Write-Host $studentnaam -ForegroundColor Green
Write-Host $studentnummer -ForegroundColor Green

# b) De variabele $modulepath met de waarde van de omgevingsvariabele PSModulePath
$modulepath = $env:PSModulePath

# c) Controleer of de poorten 5985 en 5986 openstaan en zet "Ja" of "Nee" in $5985 en $5986.
# Met -Quiet geeft Test-Connection alleen $true of $false terug.
# (localhost is hier bedoeld: we controleren de poorten van de eigen computer, het is geen testcode)
if (Test-Connection -TargetName localhost -TcpPort 5985 -Count 1 -Quiet) { # DevSkim: ignore DS162092
    $5985 = "Ja"
}
else {
    $5985 = "Nee"
}

if (Test-Connection -TargetName localhost -TcpPort 5986 -Count 1 -Quiet) { # DevSkim: ignore DS162092
    $5986 = "Ja"
}
else {
    $5986 = "Nee"
}

# d) Alle services in $services en het aantal gestarte services in $started.
# Hint: sluit de services McpManagementService en dcsvc uit (WaaSMedicSvc en NPSMSvc* geven soms ook problemen).
$services = Get-Service -Exclude McpManagementService, dcsvc, WaaSMedicSvc, NPSMSvc* -ErrorAction SilentlyContinue
$started = @($services | Where-Object { $_.Status -eq "Running" }).Count

# e) Doorloop alle items van het pad U:\ en zet alleen de namen van bestanden (geen mappen) in de array $files.
# Let op: het attribuut 'a' (archive) zegt NIET dat het item een bestand is. Gebruik PSIsContainer.
# Op een computer zonder U-schijf gebruiken we de map van dit script.
$pad = "U:\"
if (-not (Test-Path -Path $pad)) {
    Write-Warning "Er is geen U-schijf, we gebruiken in plaats daarvan: $scriptMap"
    $pad = $scriptMap
}
$files = @()
foreach ($item in Get-ChildItem -Path $pad) {
    if (-not $item.PSIsContainer) {
        $files += $item.Name
    }
}

# f) Een functie "Resultaat" die alle variabelen naar het bestand T1.result schrijft, in deze volgorde:
# $studentnaam, $studentnummer, $started, $5985, $5986, $files, $modulepath, $services
# De eerste regel maakt het bestand opnieuw aan (-Force), de rest voegt toe (-Append).
function Resultaat {
    $studentnaam | Out-File -FilePath $resultaatBestand -Force
    $studentnummer | Out-File -FilePath $resultaatBestand -Append
    $started | Out-File -FilePath $resultaatBestand -Append
    $5985 | Out-File -FilePath $resultaatBestand -Append
    $5986 | Out-File -FilePath $resultaatBestand -Append
    $files | Out-File -FilePath $resultaatBestand -Append
    $modulepath | Out-File -FilePath $resultaatBestand -Append
    $services | Out-File -FilePath $resultaatBestand -Append
}

# g) Zorg dat het script de functie "Resultaat" aanroept. Controleer handmatig of T1.result is aangemaakt.
Resultaat
Write-Host "Het resultaat is opgeslagen in: $resultaatBestand"
