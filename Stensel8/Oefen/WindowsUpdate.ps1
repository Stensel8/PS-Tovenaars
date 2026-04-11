Clear-Host
$studentNaam   = "Sten Tijhuis"
$studentNummer =  550600

Write-Host "Even geduld..."
Start-Sleep -Seconds 1
Clear-Host

Write-Host "Gemaakt door $studentNaam" -ForegroundColor Green
Write-Host $studentNummer -ForegroundColor Green


# Windows Update module ophalen
try {
    "Installing the required depencencies..."
    Install-Module -Name PSWindowsUpdate -Confirm
}
catch {
    Write-Error "Er is iets misgegaan bij het ophalen van de WindowsUpdate module."
}
finally {
    Write-Output "Opening settings..."
    Start-Process ms-settings:windowsupdate
}
