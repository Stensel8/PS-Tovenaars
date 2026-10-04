# Opdracht 2-4 : Het gebruik van pipelining in commands
# Moeilijkheid: 1/3
# Gebruik: & ".\Opdracht 2-4.ps1" C:\Windows
#          De directory C:\Windows bevat 117 files en directories

# De map waarvan we de objecten tellen is een parameter van het script
param (
    [string]$directoryPath
)

# Het scherm leegmaken
Clear-Host

# 1. Als er geen parameter is opgegeven, vraag dan om invoer
if (-not $directoryPath) {
    $directoryPath = Read-Host -Prompt "Geef de map op waarvan je het aantal objecten wilt tellen"
}

# 2. Tel de objecten met een pipeline: Get-ChildItem | ForEach-Object
$aantal = 0
Get-ChildItem -Path $directoryPath | ForEach-Object { $aantal++ }

Write-Host "De directory $directoryPath bevat $aantal files en directories"

# Hetzelfde kan ook met Measure-Object
# Get-ChildItem -Path $directoryPath | Measure-Object | ForEach-Object { Write-Host "De directory $directoryPath bevat $($_.Count) files en directories" }
