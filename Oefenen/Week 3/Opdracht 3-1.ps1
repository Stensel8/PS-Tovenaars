# Opdracht 3-1 : Het ophalen van een lijst met mp4-files van lokale drive D.
# Moeilijkheid: 1/3
# (PowerUp) : Welke mp4-bestanden zijn groter dan 500 Mb?

# Het scherm leegmaken
Clear-Host

# 1. Check welke drives er zijn. De 'echte' schijven hebben als Provider 'FileSystem'.
Get-PSDrive | Where-Object { $_.Provider.Name -eq "FileSystem" }

# 2. Ga naar de juiste PSDrive met Set-Location (alias cd). Heb je geen D-schijf, dan gebruiken we je map Video's.
$schijf = "D:\"
if (-not (Test-Path -Path $schijf)) {
    Write-Warning "Er is geen D-schijf, we gebruiken in plaats daarvan de map Video's."
    $schijf = Join-Path -Path $HOME -ChildPath "Videos"
}
Set-Location -Path $schijf

# 3. Alle objecten opvragen en met Get-Member controleren of er een property voor de extensie is
# Get-ChildItem
# Get-ChildItem | Get-Member -MemberType Property

# 4. Maak voor de test een .mp4 bestand aan in de huidige folder
"TEST" > test.mp4

# 5. Alle mp4-bestanden opvragen, ook uit alle sub-directories (-Recurse), en opslaan in $files
$files = Get-ChildItem -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Extension -eq ".mp4" }

# 6. Alleen de kolommen Name en Length tonen
$files | Select-Object -Property Name, Length

# 7. (PowerUp) Welke mp4-bestanden zijn groter dan 500 MB? PowerShell kent de eenheid MB (1MB = 1048576 bytes).
$files | Where-Object { $_.Length -gt 500MB } | Select-Object -Property Name, Length

# 8. Het testbestand weer opruimen
Remove-Item -Path ".\test.mp4"
