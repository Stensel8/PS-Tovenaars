Write-Host "Dit programma doet een GET request op een API endpoint van de Petstore demo"
Write-Host "Informatie op https://editor.swagger.io/"

# Set-variables
$baseUrl = "https://petstore.swagger.io/v2"
$endpoint = "/pet/findByStatus"
$status = "available"

$uri = "${baseUrl}${endpoint}?status=${status}"

try {
    $pets = Invoke-RestMethod -Uri $uri -Method Get -ErrorAction Stop
    Write-Host "Aantal pets met status '$status': $($pets.Count)"
}
catch {
    Write-Warning "De request naar $uri is mislukt: $($_.Exception.Message)"
}
