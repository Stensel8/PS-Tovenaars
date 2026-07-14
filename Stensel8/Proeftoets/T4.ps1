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

$azcommands = @('Connect-AzAccount', 'Set-AzContext', 'New-AzResourceGroup')

$sessionOption = New-PSSessionOption -SkipCACheck -SkipCNCheck
$session = New-PSSession -ComputerName powershell-sten.westeurope.cloudapp.azure.com -Credential (Get-Credential) -UseSSL -SessionOption $sessionOption


$studentnummer = 550600
$studentnaam = "Sten Tijhuis"
$BIOSSerialNumber = (Get-CimInstance -ClassName WIN32_BIOS).SerialNumber
$computerName = $ENV:COMPUTERNAME

Invoke-Command -Session $session -ScriptBlock {
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
