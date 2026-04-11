#Het scherm leegmaken
Clear-Host

$studentnaam = "Sten Tijhuis"
$studentnummer = "550600"

Write-Host -ForegroundColor Green $studentnaam
Write-Host -ForegroundColor Green $studentnummer

#A
# $commands = Get-Command -Module Microsoft.PowerShell.Utility
# $verbs    = (Get-Verb).verb
# $commands
# $verbs

#B
function Test-Verb () {
    try {
        $verbs = (Get-Verb).verb
    }
    catch {
        Write-Error "Fout bij ophalen van toegestane verbs/werkwoorden."
    }
$myVerb = Read-Host -Prompt "Geef een werkwoord"
foreach ($verb in $verbs) {
    if ($myVerb -eq $verb) {
        Return "$myVerb is toegestaan."
    }
}
Return "$myVerb is niet toegestaan."
}
Test-Verb

#C
$computerName = $ENV:COMPUTERNAME

(Get-ComputerInfo).WindowsProductName

(Get-CimInstance Win32_BIOS).SerialNumber
