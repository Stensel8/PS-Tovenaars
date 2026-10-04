#Requires -RunAsAdministrator

# Opdracht 4-4 : Remote PowerShell gebruiken op meerdere machines
# Moeilijkheid: 2/3
# Voer dit script uit als administrator (nodig voor TrustedHosts). De VM's moeten aan staan en WinRM moet daar
# aan staan (zie Stensel8/Week 4/Enable-WinRM.ps1).
# (PowerUp) : Exporteer de credentials naar een gecrypte file, die je voortaan kunt gebruiken om in te loggen

# Het scherm leegmaken
Clear-Host

# 1. Een array met de IP-adressen van je lokale VM's. Test eerst met 1 en later met meerdere VM's.
$myHosts = @("192.168.10.11", "192.168.10.158")

# 2. De WinRM poorten in variabelen
$poortHttp = 5985
$poortHttps = 5986

# 3. Check of je lokaal de WinRM service hebt draaien
Write-Host "Test WinRM service"
Get-Service -Name WinRM | Format-Table -AutoSize

# 4. Zet elke VM in je TrustedHosts als deze nog niet trusted is
# (WSMan:\localhost is de vaste naam van de lokale WSMan-configuratie, geen testcode)
$trustedHostsPad = "WSMan:\localhost\Client\TrustedHosts" # DevSkim: ignore DS162092
$trustedHosts = (Get-Item -Path $trustedHostsPad).Value -split ","
foreach ($computerName in $myHosts) {
    if ($computerName -in $trustedHosts) {
        Write-Host "$computerName already trusted"
    }
    else {
        Set-Item -Path $trustedHostsPad -Value $computerName -Concatenate -Force
        Write-Host "$computerName is toegevoegd aan de TrustedHosts"
    }
}
Write-Host "---------------------"

# 5. Check met Test-Connection of de WinRM poort (HTTP) open staat, en met Test-NetConnection de poort (HTTPS)
# Verschil: Test-Connection is het PowerShell alternatief voor ping (in PowerShell 7 kan het ook een TCP poort testen).
# Test-NetConnection is Windows-only en geeft een uitgebreid object terug (TcpTestSucceeded, route, interface).
foreach ($computerName in $myHosts) {
    Write-Host "Pingtest $computerName (1x), poort $poortHttp"
    Test-Connection -TargetName $computerName -IPv4 -Count 1 -TcpPort $poortHttp
    Write-Host "------------------"

    Write-Host "Test WinRM poort $poortHttps van $computerName"
    Test-NetConnection -ComputerName $computerName -Port $poortHttps
    Write-Host "------------------"
}

# 6. Maak PowerShell credentials aan. Het wachtwoord komt nooit in het script zelf te staan.
# Get-Credential vraagt om gebruikersnaam en wachtwoord. Hetzelfde met New-Object en een secure string:
# $wachtwoord = Read-Host -Prompt "Wachtwoord" -AsSecureString
# $cred = New-Object System.Management.Automation.PSCredential("Administrator", $wachtwoord)
$cred = Get-Credential -UserName "Administrator" -Message "Inloggegevens voor de VM's"

# 7. Maak per VM een remote PowerShell session en voer Get-Service -Name W32time uit
# Deze sessie loopt over HTTP (poort 5985) en niet over SSL, dus er is geen servercertificaat om te controleren.
# De opties -SkipCACheck en -SkipCNCheck zijn hier niet nodig (ze gelden alleen voor -UseSSL) en zetten we dus niet aan.
# Omdat de VM's niet in een domein zitten, vertrouwen we ze via de TrustedHosts (stap 4). Doe dat alleen in een lab.

foreach ($computerName in $myHosts) {
    $session = $null
    try {
        $session = New-PSSession -ComputerName $computerName -Credential $cred -ErrorAction Stop
        Write-Host "Connected met $computerName"
        # Invoke-Command is hier bedoeld: de opdracht is het remote uitvoeren (DevSkim: remoting is het onderwerp)
        Invoke-Command -Session $session -ScriptBlock { Get-Service -Name W32time } # DevSkim: ignore DS104456
    }
    catch {
        Write-Warning "Geen verbinding met $computerName : $($_.Exception.Message)"
    }
    finally {
        # De session netjes sluiten
        if ($session) {
            Remove-PSSession -Session $session
        }
    }
}

# 8. (PowerUp) De credentials exporteren naar een gecrypte file. Het wachtwoord wordt versleuteld met je
# Windows-account, dus alleen jij kunt de file op deze computer weer inlezen.
$cred | Export-Clixml -Path ".\cred.xml"
# Voortaan inloggen zonder te vragen:
# $cred = Import-Clixml -Path ".\cred.xml"
