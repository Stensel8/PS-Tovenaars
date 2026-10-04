# Opdracht 5-7 : Remote SQL Servers vinden en registreren
# Moeilijkheid: 3/3
# Voer dit script uit op het werkstation van de casus (SXN-WS-01), met alle virtuele machines aan.
# Het script loopt de NetBIOS namen uit computers.txt af, probeert op elke machine een verbinding met een
# database server te maken en bewaart elke geslaagde verbinding als SQL Server Registration.
# Daarna tonen we de lijst met registraties via de (nieuwe) PSDrive SQLSERVER:
# Opmerking: dit script is niet getest buiten de casus omgeving (3 VM's met een SQL Server).

# Het scherm leegmaken
Clear-Host

# 1. Installeer de module SqlServer op het werkstation (als die er nog niet is) en laad hem.
# Door de module te laden komt er een nieuwe PSDrive bij: SQLSERVER:
if (-not (Get-Module -ListAvailable -Name SqlServer)) {
    Install-Module -Name SqlServer -Scope CurrentUser -Force
}
Import-Module -Name SqlServer

# 2. Het tekstbestand met de NetBIOS namen van alle virtuele machines van het casus netwerk
$scriptMap = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$computers = Get-Content -Path (Join-Path -Path $scriptMap -ChildPath "computers.txt") | Where-Object { $_.Trim() -ne "" }

# 3. Vraag de credentials (Windows credentials) op en sla ze op in een variabele
$cred = Get-Credential -Message "Windows credentials voor het verbinden met de database server"

# De plek in de SQLSERVER: drive waar de registraties staan
$registratiePad = "SQLSERVER:\SQLRegistration\Database Engine Server Group"

# 4. Loop de lijst af en probeer een verbinding met een database server te maken. Als dat lukt, sla de
# verbinding op als SQL Server Registration. Fouten vangen we af met try-catch.
foreach ($computer in $computers) {
    try {
        # We vragen de servernaam op via een remote sessie met de Windows credentials. Op een machine zonder
        # SQL Server (of zonder de module SqlServer) geeft dit een fout, en gaan we naar de catch.
        # (Invoke-Command is hier bedoeld: de verbinding met een remote machine is de opdracht)
        $serverNaam = Invoke-Command -ComputerName $computer -Credential $cred -ErrorAction Stop -ScriptBlock { # DevSkim: ignore DS104456
            (Invoke-Sqlcmd -ServerInstance "." -Query "SELECT @@SERVERNAME AS ServerNaam" -ErrorAction Stop).ServerNaam
        }
        Write-Host "Verbonden met database server $serverNaam op $computer" -ForegroundColor Green

        # Sla de verbinding op als SQL Server Registration (met geintegreerde Windows beveiliging)
        New-Item -Path "$registratiePad\$computer" -ItemType Registration -Value "Server=$computer;integrated security=true" -ErrorAction Stop | Out-Null
        Write-Host "SQL Server Registration voor $computer is opgeslagen."
    }
    catch {
        Write-Warning "Geen database server gevonden op $computer : $($_.Exception.Message)"
    }
}

# 5. Laat de lijst met SQL Server Registrations zien via de PSDrive SQLSERVER:
Get-ChildItem -Path $registratiePad
