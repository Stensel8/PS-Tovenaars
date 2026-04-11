Clear-Host

$bestand = $null

while (-not $bestand) {
    $bestand = Read-Host "Geef de naam van het bestand op"
    if (Test-Path $bestand) {
        Write-Host "Het bestand bestaat."
    } else {
        Write-Host "Het bestand bestaat niet. Probeer opnieuw."
    }
}
