$myObject = [PSCustomObject]@{
    Name = Value
}




$gebruikerObject = {[PSCustomObject]@{
    gebruikersnaam = $env:USERNAME
    computernaam = $env:COMPUTERNAME
    Besturingssysteem = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
}}


