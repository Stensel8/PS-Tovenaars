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

$sessionOption = New-PSSessionOption -SkipCACheck -SkipCNCheck
$server = "powershell-sten.westeurope.cloudapp.azure.com"
$session = New-PSSession -ComputerName $server -Credential (Get-Credential) -UseSSL -SessionOption $sessionOption


$studentnummer = 550600
$studentnaam = "Sten Tijhuis"
$BIOSSerialNumber = (Get-CimInstance -ClassName WIN32_BIOS).SerialNumber
$computerName = $ENV:COMPUTERNAME
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
            '$using:studentnummer',
            '$using:computerName',
            '$using:BIOSSerialNumber'
            ) " `
}
