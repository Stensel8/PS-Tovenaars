Clear-Host

#A
$commands = Get-Command -Module "microsoft.powershell.utillty"
$verbs = (Get-verb).Verb

#B
function Test-Verb {
    param (
        $VerbToCheck
    ) if (Get-Verb -verb $VerbToCheck){
        return "verb toegestaan"
    } else {
        return "verb niet toegestaan"
    }   
}

#C
$computerName = $env:COMPUTERNAME

$biosSerialnumber = (Get-CimInstance Win32_bios).SerialNumber

Get-ComputerInfo $biosSerialnumber
