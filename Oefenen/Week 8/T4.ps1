# Proeftoets Scripting met PowerShell - Opgave 4 : Externe systemen (15 punten)
# Let op: vul bij c) je eigen studentnummer in.

# Het scherm leegmaken
Clear-Host

# De webserver en server van de proeftoets
$server = "powershell-scripting.westeurope.cloudapp.azure.com"

# a) Een functie "Get-WebContent" met parameter $filename, die het bestand $filename ophaalt van de webserver.
# Test met het bestand "iisstart.htm", sla het resultaat op in $myFile en de "Headers" eigenschap in $myHeaders.
function Get-WebContent {
    param (
        [string]$filename
    )

    # De proeftoets haalt het bestand op via http, zoals in de opdracht (zonder scheme gebruikt PowerShell ook http)
    return Invoke-WebRequest -Uri "http://$server/$filename" # DevSkim: ignore DS137138
}

try {
    $myFile = Get-WebContent -filename "iisstart.htm"
    $myHeaders = $myFile.Headers
    $myHeaders
}
catch {
    Write-Warning "Het bestand kon niet worden opgehaald: $($_.Exception.Message)"
}

# b) Het script maakt met de module Az een VM aan in Azure. De drie ontbrekende commando's, in de juiste volgorde:
#   Connect-AzAccount       (inloggen)
#   Set-AzContext           (de subscription kiezen: -Subscription $subs[0].Id)
#   New-AzResourceGroup     (de resource group aanmaken: -Name $rg -Location $location)
$azcommands = @("Connect-AzAccount", "Set-AzContext", "New-AzResourceGroup")
Write-Host "De drie ontbrekende commando's zijn: $($azcommands -join ', ')"

# Het volledige script, in de toetsomgeving is de module Az niet geinstalleerd:
# Connect-AzAccount
# $subs = Get-AzSubscription | Select-Object Id
# Set-AzContext -Subscription $subs[0].Id
# $location = "West-Europe"
# $rg = "RG 01"
# New-AzResourceGroup -Name $rg -Location $location
# New-AzVm -ResourceGroupName $rg -Name "Test VM" -Image "UbuntuLTS"

# c) Voeg je gegevens toe aan de database op de server: studentnummer, computernaam en BIOS serienummer.
# Deze gegevens heb je in opgave 2c opgehaald. Heb je die opgave niet gemaakt? Gebruik dan
# "computer<studentnr>" en "BIOSSerial<studentnr>" als waarden.
$studentnummer = "123456"
$computerName = $env:COMPUTERNAME
$BIOSSerialNumber = (Get-CimInstance -ClassName Win32_BIOS).SerialNumber

# Maak een PSSession object zoals in opgave 3c (over SSL, met een session option)
$cred = Get-Credential -Message "Inloggegevens voor $server"
$sessionOption = New-PSSessionOption -SkipCACheck -SkipCNCheck

try {
    $session = New-PSSession -ComputerName $server -Credential $cred -UseSSL -SessionOption $sessionOption -ErrorAction Stop

    # Op de server ga je de session in met Enter-PSSession. In een script gebruiken we Invoke-Command.
    # Enter-PSSession -Session $session

    # Voer op de server (instance '.' = de lokale database server) de INSERT query uit op de database ScriptingDB.
    # Met $using: geef je de variabelen van je eigen computer mee naar de server.
    # Invoke-Command is hier bedoeld: de opdracht is het remote uitvoeren (DevSkim: remoting is het onderwerp)
    Invoke-Command -Session $session -ScriptBlock { # DevSkim: ignore DS104456
        Invoke-Sqlcmd -ServerInstance "." -Database "ScriptingDB" -Query "
            INSERT INTO tblWorkstationUsed(
                StudentNr,
                ComputerName,
                BIOSSerialNumber
            )
            VALUES (
                '$using:studentnummer',
                '$using:computerName',
                '$using:BIOSSerialNumber'
            )"
    }
    Write-Host "De gegevens zijn toegevoegd aan de database."
}
catch {
    Write-Warning "Het toevoegen aan de database is mislukt: $($_.Exception.Message)"
}
finally {
    if ($session) {
        Remove-PSSession -Session $session
    }
}
