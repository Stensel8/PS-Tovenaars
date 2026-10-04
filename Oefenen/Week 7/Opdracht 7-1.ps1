# Opdracht 7-1 : Zelf een PowerShell module maken van je eigen scripts
# Moeilijkheid: 2/3
# We hebben een module PSTovenaars gemaakt (map PSTovenaars naast dit script) met van elke week de mooiste scripts:
#   - PSTovenaars.psm1 : het modulebestand met de functies. Het heet precies hetzelfde als de module.
#                        Onderaan staat Export-ModuleMember, daarmee bepaal je wat de gebruiker mag gebruiken.
#   - PSTovenaars.psd1 : het manifest. Dat kun je genereren met New-ModuleManifest, bijvoorbeeld:
#       New-ModuleManifest -Path .\PSTovenaars.psd1 -RootModule PSTovenaars.psm1 -ModuleVersion "1.0.0" -Author "PS-Tovenaars"
# Dit script zet de map in je PSModulePath, laadt de module en test hem.

# Het scherm leegmaken
Clear-Host

$scriptMap = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$moduleBron = Join-Path -Path $scriptMap -ChildPath "PSTovenaars"

# 1. In welke mappen zoekt PowerShell naar modules? De eerste is de map voor jouw gebruiker.
$env:PSModulePath -split [System.IO.Path]::PathSeparator
$moduleMap = ($env:PSModulePath -split [System.IO.Path]::PathSeparator)[0]

# 2. Zet de map met de module (met daarin beide bestanden) in je PSModulePath
New-Item -Path $moduleMap -ItemType Directory -Force | Out-Null
Copy-Item -Path $moduleBron -Destination $moduleMap -Recurse -Force
Write-Host "De module is geinstalleerd in: $(Join-Path -Path $moduleMap -ChildPath 'PSTovenaars')"

# 3. Controleer het manifest en laad de module. -Force laadt hem opnieuw, bijvoorbeeld na een wijziging.
Test-ModuleManifest -Path (Join-Path -Path $moduleMap -ChildPath "PSTovenaars\PSTovenaars.psd1")
Import-Module -Name PSTovenaars -Force -Verbose

# 4. Test je module :-) Welke commando's zitten erin?
Get-Module -Name PSTovenaars
Get-Command -Module PSTovenaars

# De help komt uit de comment-based help boven elke functie
Get-Help -Name Get-Dobbelsteen -Examples

# Een paar functies uitproberen
Get-Dobbelsteen
Test-ParameterValidation -Leeftijd 30
Get-DirectoryObjectCount -Path $scriptMap

# Verwijderen kan zo:
# Remove-Module -Name PSTovenaars
# Remove-Item -Path (Join-Path -Path $moduleMap -ChildPath "PSTovenaars") -Recurse
