# Opdracht 3-4 : Try-catch met typed exceptions gebruiken
# Moeilijkheid: Filled Filled Outlined
# Schrijf een Powershell script dat het volgende doet:

# Vraag om een bestandsnaam (met Read-Host)
# Probeer dit bestand te importeren (met Import-Csv) Het importeren kan op minstens 2 manieren verkeerd gaan:
# het bestand bestaat niet;
# het bestand bestaat wel, maar is geen geldig CSV bestand
# Het script moet blijven proberen een bestandsnaam op te vragen en als CSV te importeren, totdat
# ofwel de gebruiker alleen een Enter intypt (lege string): geef dan als output “Het script is afgebroken”
# ofwel een geldig CSV bestand is geimporteerd: geef dan als output “Het aantal geimporteerde regels is “ + het aantal
# Maak gebruik van de try-catch constructie en -ErrorAction Stop
# Geef voor beide soorten fouten een passende foutmelding op het scherm
# Na een geslaagde import moet het script de inhoud van het CSV bestand weergeven als een lijst
# Het zal opvallen dat een “ongeldige” CSV toch wordt ingelezen en tot een “lijst” van 1 kolom breed leidt.

# (PowerUp) : Zorg dat je in de Catch alleen de fout “Bestand niet gevonden” afvangt.
# Gebruik hiervoor het type System.IO.FileNotFoundException
# Vang daarna overige fouten af met een catch all
# (PowerUp 2) : Als het bestand gevonden is, maar ongeldige inhoud bevat (test op lege inhoud, of slechts 1 kolom) dan moet een exception gegenereerd worden
# Check op ongeldige inhoud
Clear-Host

# Opdracht 3-4 : Try-catch met typed exceptions gebruiken

$ErrorActionPreference = "Stop"
$continue = $true

while ($continue) {
    # Vraag om een bestandsnaam
    $fileName = Read-Host "Voer de bestandsnaam in (of druk op Enter om af te breken)"

    # Controleer of de gebruiker alleen Enter heeft ingetypt
    if ([string]::IsNullOrWhiteSpace($fileName)) {
        Write-Host "Het script is afgebroken"
        break
    }

    try {
        # Probeer het bestand te importeren
        $data = Import-Csv -Path $fileName -ErrorAction Stop

        # Controleer of het bestand leeg is of slechts 1 kolom bevat
        if ($data.Count -eq 0) {
            throw "Het bestand is leeg."
        }
        elseif ($data[0].PSObject.Properties.Count -eq 1) {
            throw "Het bestand bevat slechts 1 kolom."
        }

        # Geef het aantal geïmporteerde regels weer
        Write-Host "Het aantal geïmporteerde regels is: $($data.Count)"
        
        # Geef de inhoud van het CSV-bestand weer als een lijst
        $data | Format-List

        # Stop de loop als de import succesvol was
        $continue = $false
    }
    catch [System.IO.FileNotFoundException] {
        Write-Host "Fout: Het opgegeven bestand bestaat niet."
    }
    catch {
        Write-Host "Fout: $_"
    }
}

