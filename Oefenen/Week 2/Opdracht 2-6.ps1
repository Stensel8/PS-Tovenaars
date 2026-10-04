# Opdracht 2-6 : Sorteren en filteren van files
# Moeilijkheid: 1/3
# Toon de .txt files in C:\Windows\System32, gesorteerd op grootte van klein naar groot.

# Het scherm leegmaken
Clear-Host

# 1. De files in de directory ophalen
$files = Get-ChildItem -Path "C:\Windows\System32" -File

# 2. Filteren op de extensie .txt met Where-Object
$txtFiles = $files | Where-Object { $_.Extension -eq ".txt" }

# 3. Sorteren op grootte (Length), de kleinste eerst
$sortedFiles = $txtFiles | Sort-Object -Property Length

# 4. Tonen
$sortedFiles

# Hetzelfde in een pipeline (het filteren kan sneller met de parameter -Filter):
# Get-ChildItem -Path "C:\Windows\System32" -Filter *.txt | Sort-Object -Property Length
