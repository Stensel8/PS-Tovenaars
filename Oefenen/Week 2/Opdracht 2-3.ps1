# Opdracht 2-3 : Geef een lijst met de processen die het meeste geheugen gebruiken en exporteer deze naar een HTML-bestand.
# Moeilijkheid: 2/3

# Het scherm leegmaken
Clear-Host

# 1. Alle processen ophalen en aflopend sorteren op Virtual Memory (VM).
# Met Get-Process | Get-Member zie je dat VM de property is voor het gebruikte virtuele geheugen.
$processes = Get-Process | Sort-Object -Property VM -Descending

# 2. De eerste 30 processen selecteren en alleen de gewenste kolommen houden
$selectedProcesses = $processes | Select-Object -Property ProcessName, Id, VM, Path -First 30

# 3. Tonen op het scherm
$selectedProcesses

# 4. Converteren naar HTML en opslaan in een bestand (ConvertTo-Html en Out-File)
$selectedProcesses |
    ConvertTo-Html -Title "Processen gesorteerd op virtueel geheugengebruik" |
    Out-File -FilePath ".\Processes.html"

Write-Host "Het HTML rapport is aangemaakt: $((Resolve-Path -Path '.\Processes.html').Path)"
