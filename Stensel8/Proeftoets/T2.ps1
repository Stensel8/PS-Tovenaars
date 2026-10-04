Clear-Host

$commands = (Get-Command -Module "Microsoft.PowerShell.Utility").Name
$verbs = (Get-Verb).Verb

function Test-Verb {
    param (
        [string]
        $zoekwoord
    )

    try {
        $verbs = (Get-verb).verb
    }
    catch {
        Write-Error "Fout bij het ophalen van verbs"
    }

    foreach ($verb in $verbs) {
        if ($verb -eq $zoekwoord) {
            return "Ja, nice."
        }

    }
    return "Nee, sorry."

}

$computerName = $ENV:COMPUTERNAME
$BIOSSerialNumber = (Get-CimInstance Win32_BIOS).SerialNumber

Write-Host "Aantal commando's: $($commands.Count), aantal toegestane werkwoorden: $($verbs.Count)"
Write-Host "Computernaam: $computerName, BIOS serienummer: $BIOSSerialNumber"
