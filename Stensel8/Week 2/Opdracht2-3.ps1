# Het scherm leeghalen
Clear-Host

# Alle processen ophalen en in een variabele zetten
$processes = Get-Process

# Informatie over de properties van processen bekijken (om het virtual memory property te vinden)
# $processes | Get-Member

# Processen sorteren op virtueel geheugen (VM) in aflopende volgorde
$selectedProcesses = $processes | Sort-Object -Property VM -Descending

# De eerste 10 processen met het hoogste virtuele geheugengebruik tonen
$selectedProcesses | Select-Object -First 10

# De gesorteerde processen converteren naar HTML en opslaan in een bestand
$selectedProcesses | 
    Select-Object Name, Id, CPU, VM, WorkingSet, Description |
    ConvertTo-Html -Title "Processen gesorteerd op virtueel geheugengebruik" -Body "<h2>Overzicht van processen gesorteerd op virtueel geheugengebruik</h2>" |
    Out-File -FilePath "$env:USERPROFILE\Documents\ProcessenRapport.html"

Write-Host "Het HTML rapport is aangemaakt in $env:USERPROFILE\Documents\ProcessenRapport.html"
