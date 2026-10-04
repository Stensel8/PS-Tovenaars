# Opdracht 3-4 : Try-catch met typed exceptions gebruiken
# Moeilijkheid: 2/3
# Het script vraagt om een bestandsnaam en probeert het bestand te importeren met Import-Csv.
# Het blijft vragen totdat:
#   - de gebruiker alleen Enter intypt: "Het script is afgebroken"
#   - een geldig CSV bestand is geimporteerd: "Het aantal geimporteerde regels is <aantal>"
# (PowerUp)   : in de catch alleen de fout "Bestand niet gevonden" afvangen (System.IO.FileNotFoundException),
#               daarna alle overige fouten met een catch all
# (PowerUp 2) : als het bestand gevonden is maar ongeldige inhoud heeft (leeg of maar 1 kolom), gooi dan zelf een exception

# Het scherm leegmaken
Clear-Host

$continue = $true

while ($continue) {
    # 1. Vraag om een bestandsnaam
    $fileName = Read-Host -Prompt "Voer de bestandsnaam in (of druk op Enter om af te breken)"

    # 2. Alleen Enter: het script stoppen
    if ([string]::IsNullOrWhiteSpace($fileName)) {
        Write-Host "Het script is afgebroken"
        break
    }

    try {
        # 3. Probeer het bestand te importeren. -ErrorAction Stop maakt van een fout een exception die we kunnen afvangen.
        $csvData = Import-Csv -Path $fileName -ErrorAction Stop

        # 4. (PowerUp 2) Check op ongeldige inhoud: leeg bestand, of maar 1 kolom
        if ($null -eq $csvData -or @($csvData).Count -eq 0) {
            throw [System.IO.InvalidDataException]::new("Het bestand is leeg.")
        }
        if (@($csvData)[0].PSObject.Properties.Name.Count -le 1) {
            throw [System.IO.InvalidDataException]::new("Het bestand bevat maar 1 kolom, dat is geen geldig CSV bestand.")
        }

        # 5. Na een geslaagde import: het aantal regels en de inhoud als lijst tonen
        Write-Host "Het aantal geimporteerde regels is $(@($csvData).Count)"
        $csvData | Format-List

        # 6. Stop de lus: de import is gelukt
        $continue = $false
    }
    catch [System.IO.FileNotFoundException] {
        # (PowerUp) Alleen de fout "Bestand niet gevonden"
        Write-Host "Fout: het bestand '$fileName' bestaat niet. Probeer het opnieuw." -ForegroundColor Red
    }
    catch [System.IO.InvalidDataException] {
        # Onze eigen exception voor ongeldige inhoud
        Write-Host "Fout: $($_.Exception.Message) Probeer het opnieuw." -ForegroundColor Red
    }
    catch {
        # Catch all voor alle overige fouten
        Write-Host "Er is een onverwachte fout opgetreden: $($_.Exception.Message)" -ForegroundColor Red
    }
}
