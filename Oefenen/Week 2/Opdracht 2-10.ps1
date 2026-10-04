# Opdracht 2-10 : Aliases
# Moeilijkheid: 2/3
# Controleer of de alias "fw" al in gebruik is en maak een alias "fire" die het advanced
# configuratiescherm van de ingebouwde Windows Firewall opent.

# Het scherm leegmaken
Clear-Host

# 1. Alle standaard aliassen opvragen kan met Get-Alias (bijvoorbeeld: dir en ls zijn aliassen van Get-ChildItem)
# Get-Alias

# 2. Controleer of de alias "fw" al bestaat
if (Get-Alias -Name fw -ErrorAction SilentlyContinue) {
    Write-Host "Alias 'fw' bestaat al."
}
else {
    Write-Host "Alias 'fw' bestaat nog niet."
}

# 3. Maak de alias "fire" voor Windows Defender Firewall met geavanceerde beveiliging (wf.msc)
Write-Host "Alias 'fire' wordt aangemaakt..."
Set-Alias -Name fire -Value "$env:windir\System32\wf.msc"
Write-Host "Alias 'fire' is aangemaakt."

# 4. Test de alias: het firewall configuratiescherm moet starten
fire

# De alias verdwijnt na afloop van het script. Wil je hem in je venster houden, start het script dan
# met dot sourcing: . ".\Opdracht 2-10.ps1"
