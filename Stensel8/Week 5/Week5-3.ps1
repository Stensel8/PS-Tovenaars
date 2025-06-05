Write-Host "Dit programma doet een GET request op een API endpoint van de Petstore demo"
Write-Host "Informatie op https://editor.swagger.io/"

# Set-variables
$baseUrl = "https://petstore.swagger.io/v2"
$endpoint = "/pet/findByStatus"
$status = "available"

