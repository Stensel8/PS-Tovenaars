#Requires -RunAsAdministrator

# Opdracht 4-6 : Scripts remote uitvoeren op meerdere machines
# Moeilijkheid: 3/3
# Het script leest vms.txt (1 IP-adres per regel), zet voor elke regel een PowerShell sessie op en voert
# services.ps1 uit op die VM's. Er wordt maar 1 keer om een inlognaam en wachtwoord gevraagd.
# (In een domein zou dit niet nodig zijn. Normaal zet je NOOIT wachtwoorden in een script.)
# Daarna tonen we op elke VM alleen de services waar het woord "Microsoft" in voorkomt.
# Voorbereiding: PowerShell 7 op laptop en VM's, WinRM aan, IP-adressen in vms.txt.

# Het scherm leegmaken
Clear-Host

# De bestanden staan naast dit script
$scriptMap = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$vms = Get-Content -Path (Join-Path -Path $scriptMap -ChildPath "vms.txt") | Where-Object { $_.Trim() -ne "" }
$serviceScript = Join-Path -Path $scriptMap -ChildPath "services.ps1"

# 1. Zet de IP-adressen in de TrustedHosts van je laptop (als dat nog niet zo is)
# (WSMan:\localhost is de vaste naam van de lokale WSMan-configuratie, geen testcode)
$trustedHostsPad = "WSMan:\localhost\Client\TrustedHosts" # DevSkim: ignore DS162092
$trustedHosts = (Get-Item -Path $trustedHostsPad).Value -split ","
foreach ($vm in $vms) {
    if ($vm -in $trustedHosts) {
        Write-Host "$vm already trusted"
    }
    else {
        Set-Item -Path $trustedHostsPad -Value $vm -Concatenate -Force
    }
}
Write-Host

# 2. Test of de WinRM poort 5985 open staat
Write-Host "Testing connections on port 5985"
foreach ($vm in $vms) {
    if (Test-Connection -TargetName $vm -IPv4 -Count 1 -TcpPort 5985) {
        Write-Host "$vm is reachable over 5985"
    }
    else {
        Write-Host "$vm not reachable over 5985" -ForegroundColor Red
    }
}
Write-Host

# 3. Vraag 1 keer om de inloggegevens en gebruik die voor alle VM's
$cred = Get-Credential -UserName "Administrator" -Message "Inloggegevens voor de VM's"

# 4. Per VM: sessie opzetten, services.ps1 uitvoeren en daarna alleen de Microsoft services tonen
foreach ($vm in $vms) {
    $session = $null
    try {
        Write-Host $vm
        $session = New-PSSession -ComputerName $vm -Credential $cred -ErrorAction Stop

        # Het scriptbestand van je laptop wordt op de VM uitgevoerd.
        # Invoke-Command is hier bedoeld: de opdracht is het remote uitvoeren (DevSkim: remoting is het onderwerp)
        Invoke-Command -Session $session -FilePath $serviceScript # DevSkim: ignore DS104456

        # Alleen de services waar "Microsoft" in voorkomt
        Invoke-Command -Session $session -ScriptBlock { # DevSkim: ignore DS104456
            Get-Service | Where-Object { $_.DisplayName -like "*Microsoft*" }
        }
    }
    catch {
        Write-Host "Failed to connect to $vm : $($_.Exception.Message)" -ForegroundColor Red
    }
    finally {
        if ($session) {
            Remove-PSSession -Session $session
        }
        Write-Host
    }
}
