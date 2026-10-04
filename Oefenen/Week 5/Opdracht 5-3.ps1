# Opdracht 5-3 : Het aanroepen van een bestaande API via REST
# Moeilijkheid: 2/3
# Haal bij de Petstore demo informatie op over een huisdier met een RESTful API en Invoke-RestMethod.
# Tip: voeg eerst handmatig een huisdier toe via https://editor.swagger.io/ (POST op /pet, "Try it out" en
# "Execute") en lees het id uit de Response body. Of kijk met GET op /pet/findByStatus?status=available.

# Het scherm leegmaken
Clear-Host

Write-Host "Dit programma doet een GET request op een API endpoint van de Petstore demo"
Write-Host "Informatie op https://editor.swagger.io/"

# 1. Werk met variabelen voor het endpoint en het Petid.
# Een GET op /pet/{petId} geeft de gegevens van 1 huisdier, een GET op /pet een lijst.
$baseUrl = "https://petstore.swagger.io/v2"
$endpoint = "/pet"

# 2. Vraag de gebruiker om een huisdier id
$petId = Read-Host -Prompt "Voer het id van een huisdier in"
if ($petId -notmatch '^\d+$') {
    Write-Warning "Een huisdier id bestaat alleen uit cijfers."
    exit
}

# 3. De GET request. Invoke-RestMethod zet de JSON uit het antwoord meteen om naar een PowerShell object.
try {
    $pet = Invoke-RestMethod -Uri "$baseUrl$endpoint/$petId" -Method Get -ErrorAction Stop
}
catch {
    # De Petstore geeft status 404 als het huisdier niet bestaat
    if ($_.Exception.Response -and [int]$_.Exception.Response.StatusCode -eq 404) {
        Write-Warning "Er is geen huisdier gevonden met id $petId."
    }
    else {
        Write-Error "De API aanroep is mislukt: $($_.Exception.Message)"
    }
    exit
}

# 4. Print het resultaat (als JSON) op het scherm
Write-Host
Write-Host "Het resultaat van de API aanroep met huisdier id: $petId"
$pet | ConvertTo-Json -Depth 5

# Extra: een huisdier toevoegen met een POST (de body is JSON, het Content-Type moet application/json zijn)
# $nieuwHuisdier = @{ id = 0; name = "Tovenaar"; photoUrls = @("string"); status = "available" } | ConvertTo-Json
# Invoke-RestMethod -Uri "$baseUrl$endpoint" -Method Post -Body $nieuwHuisdier -ContentType "application/json"
