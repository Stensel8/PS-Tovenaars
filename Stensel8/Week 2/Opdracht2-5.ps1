# Begin met een leeg scherm
Clear-Host

# Lees de tijdelijke bestanden en mappen
$tempfiles = Get-ChildItem -Path $env:TEMP -Recurse -Force
# Met -Recurse en -Force worden ook de onderliggende mappen en verborgen bestanden meegenomen

# Zet de tellers op nul
$fileCount = 0
$folderCount = 0
$totalSize = 0

# Loop door alle items
$tempfiles | ForEach-Object {
    if ($_.PSIsContainer) {
        # Het item is een folder
        $folderCount++
    }
    else {
        # Het item is een bestand
        $fileCount++
        $totalSize += $_.Length
    }
}

# Optioneel: toon de resultaten
Write-Output "Aantal bestanden: $fileCount"
Write-Output "Aantal mappen: $folderCount"
Write-Output "Totale bestandsgrootte: $totalSize bytes"

# Het veilig verwijderen van tijdelijke bestanden
