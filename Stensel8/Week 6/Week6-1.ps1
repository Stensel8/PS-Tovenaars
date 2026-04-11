# Opdracht 6-1 : Nieuw PowerShell object maken vanuit een bestaand object

# Schrijf een script dat informatie op over de huidige gebruiker ophaalt en dit weergeeft als een als een object. Gebruik hiervoor het New-Object commando om een nieuw object aan te maken bestaande uit de properties: gebruikersnaam, computernaam en het OS. Hoe haal je computergegevens van het OS? Dit doe je met Get-CimInstance. Gebruik de Class “Win32_OperatingSystem”.

$userObject = New-Object -Typename PSObject -Property @{
    UserName = $env:USERNAME
    ComputerName = $env:COMPUTERNAME
    'Operating System' = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
}

$userObject | Format-List
