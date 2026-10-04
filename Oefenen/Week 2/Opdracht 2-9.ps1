# Opdracht 2-9 : Combinatie van commandlets
# Moeilijkheid: 2/3
# (PowerUp) : Hoe voeg je een extra host toe aan de hosts-file? Mag elke gebruiker dat?

# Het scherm leegmaken
Clear-Host

# 1. De inhoud van de hostfile ophalen. $env:windir is een omgevingsvariabele (PSDrive Env:).
$hostsPad = "$env:windir\System32\drivers\etc\hosts"
$hosts = Get-Content -Path $hostsPad

# 2. Filter de lijst: sla de commentaarregels (beginnen met #) en lege regels over
$hostsZonderCommentaar = $hosts | Where-Object { $_ -notmatch "^\s*#" -and $_.Trim() -ne "" }

# 3. Exporteer de lijst naar hosts.txt in de folder $env:TEMP
$hostsZonderCommentaar | Out-File -FilePath "$env:TEMP\hosts.txt" -Encoding utf8

# 4. Wijzig de huidige directory naar $env:TEMP
Set-Location -Path $env:TEMP

# 5. Controleer met Test-Path of de file bestaat
$bestaat = Test-Path -Path ".\hosts.txt"
Write-Host "hosts.txt bestaat: $bestaat"

# 6. Importeer de file en stuur door naar een gridview
if ($bestaat) {
    Get-Content -Path ".\hosts.txt" | Out-GridView -Title "Hosts zonder commentaar"
}
else {
    Write-Warning "hosts.txt is niet gevonden"
}

# 7. (PowerUp) Een host toevoegen kan met Add-Content (het rijmt op Get-Content).
# Lezen mag iedere gebruiker, maar schrijven naar de hosts-file mag alleen een administrator.
# Add-Content -Path $hostsPad -Value "192.168.1.11`tDC01"
