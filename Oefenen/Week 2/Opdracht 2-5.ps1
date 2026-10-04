# Opdracht 2-5 : Objecten als uitkomst - lees tijdelijke bestanden
# Moeilijkheid: 2/3
# (PowerUp) : Hoe kun je de bestanden ook verwijderen, en hoe doe je dat veilig?

# Het scherm leegmaken
Clear-Host

# 1. De inhoud van de temp-folder opvragen, inclusief alle subfolders (-Recurse).
# $env:TEMP is een omgevingsvariabele (PSDrive Env:). -Force neemt ook verborgen bestanden mee.
$tempfiles = Get-ChildItem -Path $env:TEMP -Recurse -Force -ErrorAction SilentlyContinue

# 2. Variabelen voor de totalen
$fileCount = 0
$folderCount = 0
$totalSize = 0

# 3. Loop door de lijst en verhoog de tellers op basis van de objecteigenschappen.
# PSIsContainer is $true voor folders. (Alternatief: $_.Mode -match "d")
$tempfiles | ForEach-Object {
    if ($_.PSIsContainer) {
        $folderCount++
    }
    else {
        $fileCount++
        $totalSize += $_.Length
    }
}

# 4. De aantallen naar het scherm schrijven
Write-Host "Aantal bestanden: $fileCount"
Write-Host "Aantal folders: $folderCount"
Write-Host "Totale bestandsgrootte: $totalSize bytes"

# 5. (PowerUp) Bestanden verwijderen kan met de methode Delete() (zie Get-Member) of met Remove-Item.
# Veilig doen we dat door eerst met -WhatIf te laten zien wat er zou gebeuren,
# en alleen bestanden te kiezen die al lang niet meer gebruikt zijn.
$oudeBestanden = $tempfiles | Where-Object { -not $_.PSIsContainer -and $_.LastWriteTime -lt (Get-Date).AddDays(-30) }
Write-Host "Bestanden ouder dan 30 dagen: $(@($oudeBestanden).Count)"
$oudeBestanden | Select-Object -First 5 | Remove-Item -WhatIf
# Pas als je zeker weet dat het goed gaat: vraag eerst bevestiging met -Confirm
# $oudeBestanden | Remove-Item -Confirm
