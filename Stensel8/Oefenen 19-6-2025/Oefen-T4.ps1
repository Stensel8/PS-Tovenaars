#Het scherm leegmaken
Clear-Host

$studentnaam = "Sten Tijhuis"
$studentnummer = "550600"

Write-Host -ForegroundColor Green $studentnaam
Write-Host -ForegroundColor Green $studentnummer

# (Invoke-WebRequest -URI stentijhuis.nl).Headers werkt uiteraard ook als voorbeeld. Maar dit is geen function

function Get-WebContent {
    param (
        $filename
    )
    $request = "stentijhuis.nl/$filename"
    
}
