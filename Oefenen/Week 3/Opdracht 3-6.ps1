# Opdracht 3-6 : Het opvragen van domeincomputers uit de Active Directory
# Moeilijkheid: 2/3
# Voer dit script uit op een server met Active Directory (bijvoorbeeld de domain controller van de casus)
# of op een computer waar RSAT (de module ActiveDirectory) is geinstalleerd.
# (PowerUp) : Laat per domeincomputer zien hoeveel schijfruimte de C-schijf gebruikt

# Het scherm leegmaken
Clear-Host

# 1. Check of de module ActiveDirectory aanwezig is
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    Write-Error "De module ActiveDirectory is niet geinstalleerd. Het script stopt."
    return
}
Import-Module -Name ActiveDirectory

# 2. De OU waaruit we de computers ophalen. Pas dit aan naar jouw OU.
# De juiste waarde vind je in de property DistinguishedName, bijvoorbeeld:
# CN=DC01,OU=Domain Controllers,DC=scripting,DC=local
$searchBase = "OU=Domain Controllers,DC=scripting,DC=local"

# 3. Vraag de domeincomputers op en zet ze in een variabele, met foutafhandeling
try {
    $domeincomputers = Get-ADComputer -Filter * -SearchBase $searchBase -Properties IPv4Address, LastLogonDate -ErrorAction Stop
}
catch {
    Write-Error "Fout bij het ophalen van de domeincomputers: $($_.Exception.Message)"
    return
}

# 4. Print naam, ip-adres, aan/uit status en laatste inlogdatum
$overzicht = foreach ($computer in $domeincomputers) {
    # Is de computer bereikbaar? Dan staat hij aan.
    $aan = Test-Connection -TargetName $computer.Name -Count 1 -Quiet

    [PSCustomObject]@{
        Name          = $computer.Name
        Enabled       = $computer.Enabled
        IPv4Address   = $computer.IPv4Address
        Status        = if ($aan) { "Aan" } else { "Uit" }
        LastLogonDate = if ($computer.LastLogonDate) { $computer.LastLogonDate } else { "Nooit" }
    }
}
$overzicht | Format-Table -AutoSize

# 5. (PowerUp) Schijfruimte van de C-schijf per domeincomputer met Get-ChildItem, Measure-Object en Invoke-Command.
# Dit kan een paar minuten duren. Beperk $pad bijvoorbeeld tot "C:\Windows\Temp" om te testen.
$pad = "C:\"
$cred = Get-Credential -Message "Inloggegevens voor de remote computers"

Write-Host "Hoeveelheid schijfruimte"
Write-Host "------------------------"
foreach ($computer in $domeincomputers) {
    try {
        # $using:pad geeft de variabele $pad van je eigen computer mee naar de remote computer.
        # Invoke-Command is hier bedoeld: de opdracht is het remote uitvoeren (DevSkim: remoting is het onderwerp)
        $grootte = Invoke-Command -ComputerName $computer.Name -Credential $cred -ErrorAction Stop -ScriptBlock { # DevSkim: ignore DS104456
            (Get-ChildItem -Path $using:pad -Recurse -File -Force -ErrorAction SilentlyContinue |
                Measure-Object -Property Length -Sum).Sum
        }
        Write-Host "$($computer.Name): $grootte"
    }
    catch {
        # Extra foutafhandeling: de remote computer kan uit staan of WinRM kan geblokkeerd zijn
        Write-Warning "Geen verbinding met $($computer.Name): $($_.Exception.Message)"
    }
}
