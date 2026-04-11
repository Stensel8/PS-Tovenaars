# 1. Laat alle file system-diensten zien en filter op ‘Provider’ FileSystem.
Get-PSDrive | Where-Object Provider -eq 'FileSystem'

# 2. Ga vervolgens naar de gewenste PSdrive (bijv. C:)
Set-Location C:

# 3. Bekijk alle objecten in de huidige directory.
#Get-ChildItem

# 4. Controleer met Get-Member of de objecten een property ‘Extension’ hebben.
#Get-ChildItem | Get-Member

# 5. Maak een test .mp4 bestand aan in de huidige folder.
"TEST" > test.mp4

# 6. Haal met Get-ChildItem alle objecten (ook in sub-directories) op, 
# en filter met Where-Object op bestanden met de extensie '.mp4'.
$files = Get-ChildItem -Recurse | Where-Object Extension -eq '.mp4'

# 7. Bekijk met Select-Object alleen de Name en Length properties.
$files | Select-Object Name, Length

# 8. Filter en toon welke mp4-bestanden groter zijn dan 500 MB.
# (500 MB = 500 * 1024 * 1024 = 524288000 bytes)
$files | Where-Object { $_.Length -gt 524288000 }
