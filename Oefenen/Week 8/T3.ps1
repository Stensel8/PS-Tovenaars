# Proeftoets Scripting met PowerShell - Opgave 3 : Beheerscripts (15 punten)

# Het scherm leegmaken
Clear-Host

# De bestanden Klantmachines.json en SystemUpdate.log staan naast dit script
$scriptMap = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }

# a) Lees "Klantmachines.json" in en converteer het naar een lijst. Laat een overzicht zien met de kolommen
# "computernaam" en "ip" en exporteer dit naar het HTML-bestand "Klantmachines.html".
$klantmachines = (Get-Content -Path (Join-Path -Path $scriptMap -ChildPath "Klantmachines.json") -Raw | ConvertFrom-Json).klantmachine
$klantmachines | Format-Table -Property computernaam, ip -AutoSize
$klantmachines |
    ConvertTo-Html -Property computernaam, ip -Title "Klantmachines" |
    Out-File -FilePath (Join-Path -Path $scriptMap -ChildPath "Klantmachines.html")

# b) Een functie "Test-Log" die een zoekwoord aan de gebruiker vraagt en checkt op hoeveel regels dit woord
# voorkomt in de logfile "SystemUpdate.log". Het resultaat: "Het zoekwoord <zoekwoord> komt <aantal>x voor."
# Het resultaat wordt getoond en ook teruggegeven, zodat het in een variabele opgeslagen kan worden.
function Test-Log {
    param (
        [string]$Zoekwoord
    )

    # Is er geen zoekwoord meegegeven, dan vragen we erom
    if ([string]::IsNullOrWhiteSpace($Zoekwoord)) {
        $Zoekwoord = Read-Host -Prompt "Zoekwoord"
    }

    # Tel de regels waarin het zoekwoord voorkomt (Select-String geeft 1 resultaat per regel)
    $aantal = @(Select-String -Path (Join-Path -Path $scriptMap -ChildPath "SystemUpdate.log") -Pattern $Zoekwoord -SimpleMatch).Count

    $resultaat = "Het zoekwoord $Zoekwoord komt ${aantal}x voor."
    Write-Host $resultaat
    return $resultaat
}

# Test de functie met het zoekwoord "Heartbeat" en vul de variabele $heartbeat met het resultaat
$heartbeat = Test-Log -Zoekwoord "Heartbeat"
Write-Host "Opgeslagen in `$heartbeat: $heartbeat"

# c) Een PSSession naar de server, opgeslagen in $session. De sessie moet over SSL, en er is een session option
# nodig met -SkipCACheck en -SkipCNCheck. Zonder SSL of session option werkt de sessie NIET.
# Met Invoke-Command vragen we de naam van de server op en bewaren die in $serverName.
$server = "powershell-scripting.westeurope.cloudapp.azure.com"
$cred = Get-Credential -Message "Inloggegevens voor $server"
$sessionOption = New-PSSessionOption -SkipCACheck -SkipCNCheck

try {
    $session = New-PSSession -ComputerName $server -Credential $cred -UseSSL -SessionOption $sessionOption -ErrorAction Stop
    # In het scriptblock vragen we de naam van de server zelf op (MachineName is hetzelfde als $env:COMPUTERNAME)
    $serverName = Invoke-Command -Session $session -ScriptBlock { [System.Environment]::MachineName }
    Write-Host "Verbonden met de server: $serverName"
}
catch {
    Write-Warning "Geen verbinding met $server : $($_.Exception.Message)"
}
finally {
    # De sessie netjes sluiten
    if ($session) {
        Remove-PSSession -Session $session
    }
}
