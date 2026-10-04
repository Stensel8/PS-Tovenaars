# Opdracht 5-2 : Het aanroepen van een bestaande API
# Moeilijkheid: 2/3
# Haal bij de RDW service informatie op over een kenteken met Invoke-WebRequest.
# Workshop: laat de agent zien welk automerk en welke kleur bij het kenteken hoort.

# Het scherm leegmaken
Clear-Host

Write-Host "Dit programma doet een GET request op een API endpoint van de RDW webservice."

# 1. Het endpoint van de RDW API. Parameters (query-variabelen) komen achter een vraagteken: ?kenteken=...
$endpoint = "https://opendata.rdw.nl/resource/m9d7-ebf2.json"

# 2. Vraag de gebruiker om een kenteken. De RDW verwacht hoofdletters zonder streepjes.
$kenteken = (Read-Host -Prompt "Voer kenteken in").ToUpper().Replace("-", "").Trim()

# Een kenteken bestaat alleen uit letters en cijfers. Zo komt er geen vreemde tekst in de url.
if ($kenteken -notmatch '^[A-Z0-9]{1,8}$') {
    Write-Warning "Dit is geen geldig kenteken."
    exit
}

# 3. De GET request uitvoeren
$uri = "${endpoint}?kenteken=$kenteken"
$response = Invoke-WebRequest -Uri $uri -Method Get

# 4. Het resultaat (een JSON tekst) op het scherm printen
Write-Host
Write-Host "Het resultaat van de API aanroep met kenteken: $kenteken"
$response.Content

# 5. Workshop: van de JSON tekst een object maken en het merk en de kleur tonen
$voertuig = $response.Content | ConvertFrom-Json
if ($voertuig) {
    Write-Host
    Write-Host "Merk : $($voertuig.merk)"
    Write-Host "Kleur: $($voertuig.eerste_kleur)"
}
else {
    Write-Warning "Er is geen voertuig gevonden met kenteken $kenteken."
}
