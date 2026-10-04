# Opdracht 4-2 : Scannen van logfiles
# Moeilijkheid: 1/3
# Gebruik de Apache logfile Apache_2k.log (van school) in dezelfde map als dit script.

# Het scherm leegmaken
Clear-Host

# 1. Het logbestand staat naast dit script. Ontbreekt het, dan downloaden we het van de website van school.
$scriptMap = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$logPad = Join-Path -Path $scriptMap -ChildPath "Apache_2k.log"

if (-not (Test-Path -Path $logPad)) {
    Write-Host "Apache_2k.log wordt gedownload..."
    Invoke-WebRequest -Uri "https://saxionact.github.io/1.4-Scripting-met-Powershell/Week4/Apache_2k.log" -OutFile $logPad
}

# 2. De eerste 5 en de laatste 5 regels in 1 regel
Write-Host "Eerste en laatste regels:"
Get-Content -Path $logPad | Select-Object -First 5 -Last 5

# 3. Alleen de regels met de foutmelding "error state 6" tonen en tellen.
# Select-String is het alternatief voor het Linux commando grep.
# Het aantal kan afwijken van het voorbeeld in de opdracht (1476), dat hangt af van de versie van het logbestand.
$fouten = Select-String -Path $logPad -Pattern "error state 6"

Write-Host
Write-Host 'Alleen "error state 6":'
$fouten | ForEach-Object { $_.Line }

Write-Host
Write-Host "Logfile bevat"
Write-Host @($fouten).Count
Write-Host "keer error state 6"
