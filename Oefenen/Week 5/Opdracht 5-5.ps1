# Opdracht 5-5 : Lokale database gebruiken
# Moeilijkheid: 2/3
# Voer dit script uit op de database server (SXN-DB-01) waar SQL Server Developer Edition staat (alleen de
# Database Engine feature) en SQL Server Management Studio. TCP poort 1433 moet open staan in de firewall.

# Het scherm leegmaken
Clear-Host

# 1. Zorg dat TCP poort 1433 open staat in de firewall (dit kan alleen als administrator)
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($isAdmin) {
    if (-not (Get-NetFirewallRule -DisplayName "SQL Server (TCP 1433)" -ErrorAction SilentlyContinue)) {
        New-NetFirewallRule -DisplayName "SQL Server (TCP 1433)" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action Allow | Out-Null
        Write-Host "Firewall regel voor poort 1433 is aangemaakt."
    }
}
else {
    Write-Warning "Geen administrator: de firewall regel voor poort 1433 wordt overgeslagen."
}

# 2. Installeer de module SqlServer (als die er nog niet is) en bekijk welke cmdlets erin zitten
if (-not (Get-Module -ListAvailable -Name SqlServer)) {
    Install-Module -Name SqlServer -Scope CurrentUser -Force
}
Get-Command -Module SqlServer

# Een nieuwe versie van de module versleutelt de verbinding standaard. Een lokale SQL Server heeft meestal een
# zelf-gesigneerd certificaat, dus daar vertrouwen we dan op. Alle gemeenschappelijke parameters zetten we in 1 hashtable.
$sql = @{ ServerInstance = "." }
if ((Get-Command -Name Invoke-Sqlcmd).Parameters.ContainsKey("TrustServerCertificate")) {
    $sql.TrustServerCertificate = $true
}

# 3. Voer het script CreateDatabase.sql uit met -InputFile en -ServerInstance '.' (de lokale server).
# Bestaat de database al, dan slaan we deze stap over (CREATE DATABASE zou dan een fout geven).
$scriptMap = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$bestaat = Invoke-Sqlcmd @sql -Query "SELECT DB_ID('TestDatabase') AS DatabaseId"
if ($null -eq $bestaat.DatabaseId -or $bestaat.DatabaseId -is [System.DBNull]) {
    Invoke-Sqlcmd @sql -InputFile (Join-Path -Path $scriptMap -ChildPath "CreateDatabase.sql")
    Write-Host "De database TestDatabase is aangemaakt."
}
else {
    Write-Host "De database TestDatabase bestaat al."
}

# 4. Voeg je eigen naam toe met een INSERT statement en vang het resultaat op in een variabele.
# (Een apostrof in een naam moet je verdubbelen, anders breekt het SQL statement.)
$eigenNaam = "Jouw Naam".Replace("'", "''")
$resultaatInsert = Invoke-Sqlcmd @sql -Database "TestDatabase" -Query "INSERT INTO Student(StudentName) VALUES ('$eigenNaam')"

# Wat voor datatype heeft deze variabele? Een INSERT geeft geen rijen terug, dus de variabele is $null.
Write-Host "Resultaat van de INSERT is `$null: $($null -eq $resultaatInsert)"

# 5. Voer de INSERT nog een paar keer uit met andere namen
foreach ($naam in @("Anna", "Bram", "Chris")) {
    Invoke-Sqlcmd @sql -Database "TestDatabase" -Query "INSERT INTO Student(StudentName) VALUES ('$naam')"
}

# 6. Haal alle studenten op en vang het resultaat op in een variabele
$studenten = Invoke-Sqlcmd @sql -Database "TestDatabase" -Query "SELECT * FROM Student"

# Welk datatype heeft deze variabele en wat zijn de members?
# Het is een lijst (array) met objecten van het type System.Data.DataRow. Elke kolom is een property
# (ID, StudentName, CreateDate), plus DataRow members zoals ItemArray, RowState en Table.
$studenten.GetType().FullName
$studenten | Get-Member

$studenten | Format-Table -Property ID, StudentName, CreateDate -AutoSize
