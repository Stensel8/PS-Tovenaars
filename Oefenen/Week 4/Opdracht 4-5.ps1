#Requires -RunAsAdministrator

# Opdracht 4-5 : Execution Policy
# Moeilijkheid: 1/3
# 1. Laat zien in welke modus de execution policy staat
# 2. Zet de execution policy op AllSigned (alleen gesigneerde scripts mogen draaien)
# 3. Zorg dat een willekeurig script toch uitgevoerd kan worden zonder de execution policy te veranderen
# Let op: AllSigned geldt voor de hele computer. Dit script zet daarom na afloop de oude waarde terug.

# Het scherm leegmaken
Clear-Host

# 1. Toon de huidige status van de execution policy op alle niveaus (scopes)
Get-ExecutionPolicy -List

# Onthoud de oude waarde, zodat we die kunnen terugzetten
$oudePolicy = Get-ExecutionPolicy -Scope LocalMachine

try {
    # 2. Zet de execution policy op AllSigned
    # (De execution policy aanpassen is het onderwerp van deze opdracht, en we zetten hem na afloop terug.)
    Set-ExecutionPolicy -ExecutionPolicy AllSigned -Scope LocalMachine -Force # DevSkim: ignore DS113853
    Get-ExecutionPolicy -List

    # 3. Maak een testscript. Dit script is niet gesigneerd.
    $testScript = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "test-policy.ps1"
    'Write-Host "Het script is uitgevoerd."' | Out-File -FilePath $testScript

    # We starten het testscript met dezelfde PowerShell (pwsh of powershell) als waarin dit script draait
    $powershell = (Get-Process -Id $PID).Path

    # Met AllSigned wordt het script geblokkeerd...
    Write-Host "Poging 1: gewoon starten (wordt geblokkeerd door AllSigned)"
    & $powershell -NoProfile -File $testScript

    # ...maar je kunt de policy voor 1 proces omzeilen met -ExecutionPolicy Bypass, zonder de policy zelf te wijzigen
    Write-Host "Poging 2: starten met -ExecutionPolicy Bypass"
    & $powershell -NoProfile -ExecutionPolicy Bypass -File $testScript
}
finally {
    # De oude waarde terugzetten en het testscript opruimen
    Set-ExecutionPolicy -ExecutionPolicy $oudePolicy -Scope LocalMachine -Force # DevSkim: ignore DS113853
    if ($testScript -and (Test-Path -Path $testScript)) {
        Remove-Item -Path $testScript
    }
    Write-Host "De execution policy is teruggezet naar: $oudePolicy"
}
