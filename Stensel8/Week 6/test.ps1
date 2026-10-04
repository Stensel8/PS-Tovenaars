$myObject = [PSCustomObject]@{
    Name = "Value"
}
$myObject

$gebruikerObject = [PSCustomObject]@{
    gebruikersnaam = $env:USERNAME
    computernaam = $env:COMPUTERNAME
    Besturingssysteem = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
}
$gebruikerObject
