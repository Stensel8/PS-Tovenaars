#Requires -RunAsAdministrator

# Opdracht 3-2 : Het updaten van registry settings via PSdrive HKLM.
# Moeilijkheid: 1/3
# Let op: dit script past het Windows Update beleid van deze computer aan (policy NoAutoUpdate).
# Dat werkt alleen als administrator en kan door beleid van school of werk overschreven worden.
# Het script vraagt daarom eerst om bevestiging en laat zien hoe je de wijziging terugdraait.

# Het scherm leegmaken
Clear-Host

# 1. Check welke drives er zijn en welke PSDrives voor de registry worden gebruikt (Provider 'Registry')
Get-PSDrive -PSProvider Registry

# 2. Bevestiging vragen voordat we de registry aanpassen
$antwoord = Read-Host -Prompt "Dit past het Windows Update beleid van deze computer aan. Doorgaan? (j/n)"
if ($antwoord -ne "j") {
    Write-Host "Afgebroken, er is niets gewijzigd."
    exit
}

# 3. Ga naar de PSDrive HKLM: (alleen via Set-Location, niet met alleen "HKLM:" typen)
$huidigePlek = Get-Location
Set-Location -Path HKLM:

# 4. De registry-key voor de Windows Update policies. Maak de keys aan als ze nog niet bestaan.
$WUPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
$AUPath = "$WUPath\AU"

if (-not (Test-Path -Path $WUPath)) {
    New-Item -Path $WUPath -Force | Out-Null
}

if (Test-Path -Path $AUPath) {
    Write-Host "De AU key bestaat al."
}
else {
    New-Item -Path $AUPath -Force | Out-Null
    Write-Host "De AU key is aangemaakt."
}

# 5. Maak de items (values) NoAutoUpdate en AUOptions met waarde 1.
# Let op: New-Item maakt een key aan, voor een value gebruik je New-ItemProperty.
New-ItemProperty -Path $AUPath -Name "NoAutoUpdate" -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $AUPath -Name "AUOptions" -Value 1 -PropertyType DWord -Force | Out-Null

# 6. Controleer de waardes (of open regedit via Start -> regedit)
Get-ItemProperty -Path $AUPath | Select-Object -Property NoAutoUpdate, AUOptions

# 7. Terug naar de plek waar we begonnen
Set-Location -Path $huidigePlek

# Terugdraaien kan met:
# Remove-ItemProperty -Path $AUPath -Name "NoAutoUpdate", "AUOptions"
