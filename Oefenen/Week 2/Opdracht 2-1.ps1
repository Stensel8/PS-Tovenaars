# Opdracht 2-1 : Het ophalen van een lijst met processen en opslaan in een variabele
# Moeilijkheid: 1/3

# Het scherm leegmaken
Clear-Host

# 1. Alle processen ophalen en opslaan in de variabele $myProcesses
$myProcesses = Get-Process

# 2. Print het eerste element van de lijst. Let op: een array begint op indexnummer 0.
$myProcesses[0]

# Extra: alleen een paar kolommen tonen
$myProcesses[0] | Format-Table -Property Name, Id, CPU, NPM, PM, WS -AutoSize
