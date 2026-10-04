# Proeftoets Scripting met PowerShell - Opgave 2 : Modules en robuuste scripts (15 punten)

# Het scherm leegmaken
Clear-Host

# a) De namen van alle commando's van de module "Microsoft.PowerShell.Utility" in $commands.
# Daarna met 1 van die commando's (Get-Verb) alleen de toegestane werkwoorden in $verbs.
$commands = (Get-Command -Module "Microsoft.PowerShell.Utility").Name
$verbs = (Get-Verb).Verb
Write-Host "De module Microsoft.PowerShell.Utility heeft $($commands.Count) commando's. Er zijn $($verbs.Count) toegestane werkwoorden."

# b) Een functie "Test-Verb" die aan de gebruiker een werkwoord vraagt en checkt of het een toegestaan werkwoord is.
# Pas in de functie foutafhandeling toe.
function Test-Verb {
    param (
        [string]$Werkwoord
    )

    # De toegestane werkwoorden ophalen, met foutafhandeling
    try {
        $toegestaan = (Get-Verb -ErrorAction Stop).Verb
    }
    catch {
        Write-Error "Fout bij het ophalen van de toegestane werkwoorden: $($_.Exception.Message)"
        return
    }

    # Is er geen werkwoord meegegeven, dan vragen we erom
    if ([string]::IsNullOrWhiteSpace($Werkwoord)) {
        $Werkwoord = Read-Host -Prompt "Werkwoord"
    }

    # -in vergelijkt zonder op hoofdletters te letten
    if ($Werkwoord -in $toegestaan) {
        return "$Werkwoord is toegestaan"
    }
    return "$Werkwoord is niet toegestaan"
}

Test-Verb

# c) De computernaam en het BIOS serienummer van de computer waarop je bent ingelogd.
$computerName = $env:COMPUTERNAME
$BIOSSerialNumber = (Get-CimInstance -ClassName Win32_BIOS).SerialNumber

Write-Host "Computernaam: $computerName"
Write-Host "BIOS serienummer: $BIOSSerialNumber"
