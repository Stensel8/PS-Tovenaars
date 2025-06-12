# run this in on a windows server whome is a domain controller

# if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
#     Write-Error "De Active Directory-module is niet geïnstalleerd. Stop script."
#     return
# }
# Import-Module ActiveDirectory

# $OU = "OU=Workstations,DC=example,DC=com"   # pas dit aan naar jouw OU
# try {
#     $computers = Get-ADComputer -Filter * -SearchBase $OU -Properties LastLogonDate
# } catch {
#     Write-Error "Fout bij ophalen van domeincomputers: $_"
#     return
# }

foreach ($c in $computers) {
    $name = $c.Name

    try {
        $ping = Test-Connection -ComputerName $name -Count 1 -ErrorAction Stop
        $ip = $ping.IPv4Address.IPAddressToString
        $status = "Aan"
    } catch {
        $ip = "Niet bereikbaar"
        $status = "Uit"
    }

    $lastLogon = $c.LastLogonDate
    if (-not $lastLogon) { $lastLogon = "Nooit" }

    Write-Host ("Naam: {0}; IP: {1}; Status: {2}; Laatste login: {3}" -f `
        $name, $ip, $status, $lastLogon)
}

