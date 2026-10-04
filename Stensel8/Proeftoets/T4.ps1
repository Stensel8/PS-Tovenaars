Clear-Host

function Get-WebContent {
    param (
        [string]
        $filename
    )
    return Invoke-WebRequest -Uri "powershell-sten.westeurope.cloudapp.azure.com/$filename"
}

$myFile = Get-WebContent -filename "iisstart.htm"
$myHeaders = ($myFile).headers
Write-Host "Aantal headers: $($myHeaders.Count)"

$azcommands = @('Connect-AzAccount', 'Set-AzContext', 'New-AzResourceGroup')
Write-Host "De ontbrekende Az-commando's: $($azcommands -join ', ')"

# Let op: -SkipCACheck en -SkipCNCheck zet de controle van het servercertificaat uit. De proeftoets eist dat, omdat
# de toetsserver een zelf-gesigneerd certificaat heeft. Gebruik dit NOOIT voor een echte server (onderschepping van inloggegevens).
$server = "powershell-sten.westeurope.cloudapp.azure.com"
$session = New-PSSession -ComputerName $server -Credential (Get-Credential) -UseSSL -SessionOption $sessionOption


$studentnummer = 550600
$studentnaam = "Sten Tijhuis"
$BIOSSerialNumber = (Get-CimInstance -ClassName WIN32_BIOS).SerialNumber
$computerName = $ENV:COMPUTERNAME

# Een apostrof in een waarde zou het SQL statement openbreken (SQL injection): verdubbel elke apostrof
$studentnummerSql = ([string]$studentnummer).Replace("'", "''")
$computerNameSql = ([string]$computerName).Replace("'", "''")
$BIOSSerialNumberSql = ([string]$BIOSSerialNumber).Replace("'", "''")
Write-Host "Gegevens van $studentnaam ($studentnummer) worden toegevoegd aan de database."

Invoke-Command -Session $session -ScriptBlock { # DevSkim: ignore DS104456
    Invoke-Sqlcmd `
    -ServerInstance '.\SQLEXPRESS' `
    -Database 'ScriptingDB' `
    -Query "INSERT INTO tblWorkstationUsed(
            StudentNR,
            ComputerName,
            BIOSSerialNumber
            )
            VALUES (
            '$using:studentnummerSql',
            '$using:computerNameSql',
            '$using:BIOSSerialNumberSql'
            ) " `
}
