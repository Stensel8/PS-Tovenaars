# Opdracht 4-1 : File handling, grote bestanden zoeken
# Moeilijkheid: 2/3
# Toon alle bestanden groter dan 500 MB op de C: schijf die ouder zijn dan 30 dagen.
# Gebruik de pipeline en Where-Object.

# Het scherm leegmaken
Clear-Host

# 1. De datum van 30 dagen geleden
$grens = (Get-Date).AddDays(-30)

# 2. Alle bestanden op C: ophalen (-File slaat folders over, -ErrorAction SilentlyContinue negeert mappen waar je
# geen toegang toe hebt). Dit kan even duren.
# 3. Filter met Where-Object: groter dan 500 MB en laatst gewijzigd langer dan 30 dagen geleden.
# Let op: "ouder dan" betekent een LastWriteTime die kleiner is dan de grens (-lt).
Get-ChildItem -Path C:\ -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Length -gt 500MB } |
    Where-Object { $_.LastWriteTime -lt $grens } |
    Select-Object -Property FullName, @{ Name = "GrootteMB"; Expression = { [math]::Round($_.Length / 1MB) } }, LastWriteTime
