# PSTovenaars : onze eigen PowerShell module (opdracht 7-1 en 7-2)
# Hierin staan de mooiste scripts van week 1 t/m 7, omgebouwd tot commandlets met parametervalidatie.
# De functies die niet in dit bestand staan met Export-ModuleMember (onderaan) zijn niet beschikbaar voor de
# gebruikers van de module. Het manifest (PSTovenaars.psd1) bepaalt de versie en wat geexporteerd wordt.

# ---------------------------------------------------------------
# Week 1 : functies (opdracht 1-9)
# ---------------------------------------------------------------

<#
.SYNOPSIS
Pingt een of meer IP-adressen of hostnames (via IPv4).
.DESCRIPTION
Gebruikt Test-Connection. De functie heet Test-Ping omdat Ping geen approved verb is (zie Get-Verb).
De alias Ping-Address is de naam uit opdracht 1-9.
.PARAMETER Ipaddress
Een of meer IP-adressen of hostnames. Mag ook via de pipeline.
.PARAMETER Count
Het aantal pings per adres (1 t/m 10, standaard 3).
.EXAMPLE
Test-Ping -Ipaddress 192.168.2.1 -Count 2
#>
function Test-Ping {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Ipaddress,

        [ValidateRange(1, 10)]
        [int]$Count = 3
    )

    process {
        foreach ($ip in $Ipaddress) {
            Write-Host "Pinging... $ip"
            Test-Connection -TargetName $ip -IPv4 -Count $Count
        }
    }
}
Set-Alias -Name Ping-Address -Value Test-Ping

# ---------------------------------------------------------------
# Week 2 : commandlets en objecten (opdracht 2-4 en 2-5)
# ---------------------------------------------------------------

<#
.SYNOPSIS
Telt het aantal files en directories in een map.
.PARAMETER Path
De map waarvan je de objecten wilt tellen. Moet bestaan.
.EXAMPLE
Get-DirectoryObjectCount -Path C:\Windows
#>
function Get-DirectoryObjectCount {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [string]$Path
    )

    [PSCustomObject]@{
        Path   = $Path
        Aantal = @(Get-ChildItem -Path $Path -Force).Count
    }
}

<#
.SYNOPSIS
Geeft het aantal bestanden, folders en de totale grootte van de tijdelijke bestanden.
.PARAMETER Path
De map die doorlopen wordt, inclusief alle submappen. Standaard de TEMP-folder.
.EXAMPLE
Get-TempFolderSummary
#>
function Get-TempFolderSummary {
    [CmdletBinding()]
    param (
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [string]$Path = $(if ($env:TEMP) { $env:TEMP } else { [System.IO.Path]::GetTempPath() })
    )

    $items = Get-ChildItem -Path $Path -Recurse -Force -ErrorAction SilentlyContinue
    $bestanden = @($items | Where-Object { -not $_.PSIsContainer })

    [PSCustomObject]@{
        Path        = $Path
        Bestanden   = $bestanden.Count
        Folders     = @($items | Where-Object { $_.PSIsContainer }).Count
        TotaalBytes = [long]($bestanden | Measure-Object -Property Length -Sum).Sum
    }
}

# ---------------------------------------------------------------
# Week 3 : modules en robuuste scripts (opdracht 3-4 en 3-5)
# ---------------------------------------------------------------

<#
.SYNOPSIS
Importeert een CSV bestand en controleert of de inhoud geldig is.
.DESCRIPTION
Gooit een System.IO.FileNotFoundException als het bestand niet bestaat en een
System.IO.InvalidDataException als het bestand leeg is of maar 1 kolom heeft.
.PARAMETER Path
Het CSV bestand.
.EXAMPLE
Import-ValidCsv -Path .\test.csv
#>
function Import-ValidCsv {
    [CmdletBinding()]
    [OutputType([object[]])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )

    $data = @(Import-Csv -Path $Path -ErrorAction Stop)

    if ($data.Count -eq 0) {
        throw [System.IO.InvalidDataException]::new("Het bestand is leeg: $Path")
    }
    if ($data[0].PSObject.Properties.Name.Count -le 1) {
        throw [System.IO.InvalidDataException]::new("Het bestand bevat maar 1 kolom, dat is geen geldig CSV bestand: $Path")
    }

    $data
}

<#
.SYNOPSIS
Toont de processen die een TCP connectie hebben naar een bepaalde externe poort (alleen Windows).
.PARAMETER RemotePort
De externe poort (1 t/m 65535), bijvoorbeeld 443.
.EXAMPLE
Get-TcpProcess -RemotePort 443
#>
function Get-TcpProcess {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateRange(1, 65535)]
        [int]$RemotePort
    )

    $processIds = (Get-NetTCPConnection -RemotePort $RemotePort -ErrorAction SilentlyContinue).OwningProcess | Sort-Object -Unique

    Get-Process | Where-Object { $_.Id -in $processIds } |
        Select-Object -Property ProcessName, Id |
        Sort-Object -Property ProcessName
}

# ---------------------------------------------------------------
# Week 4 : beheerscripts (opdracht 4-1 en 4-2)
# ---------------------------------------------------------------

<#
.SYNOPSIS
Zoekt grote bestanden die al lang niet gewijzigd zijn.
.PARAMETER Path
Waar gezocht wordt (standaard C:\).
.PARAMETER MinimumSizeMB
Minimale grootte in MB (standaard 500).
.PARAMETER OlderThanDays
Alleen bestanden die langer dan dit aantal dagen niet gewijzigd zijn (standaard 30).
.EXAMPLE
Get-LargeFile -Path D:\ -MinimumSizeMB 100 -OlderThanDays 90
#>
function Get-LargeFile {
    [CmdletBinding()]
    param (
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [string]$Path = "C:\",

        [ValidateRange(1, 1048576)]
        [int]$MinimumSizeMB = 500,

        [ValidateRange(0, 36500)]
        [int]$OlderThanDays = 30
    )

    $grens = (Get-Date).AddDays(-$OlderThanDays)
    $minimumBytes = [long]$MinimumSizeMB * 1MB

    Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Length -gt $minimumBytes -and $_.LastWriteTime -lt $grens } |
        Select-Object -Property FullName, @{ Name = "GrootteMB"; Expression = { [math]::Round($_.Length / 1MB) } }, LastWriteTime
}

<#
.SYNOPSIS
Telt in welke regels van een logfile een zoekwoord voorkomt.
.PARAMETER Path
De logfile. Moet bestaan.
.PARAMETER Pattern
Het zoekwoord of de reguliere expressie (minimaal 3 tekens).
.EXAMPLE
Search-LogFile -Path .\Apache_2k.log -Pattern "error state 6"
#>
function Search-LogFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string]$Path,

        [Parameter(Mandatory)]
        [ValidateLength(3, 100)]
        [string]$Pattern
    )

    $gevonden = @(Select-String -Path $Path -Pattern $Pattern)

    [PSCustomObject]@{
        Path    = $Path
        Pattern = $Pattern
        Aantal  = $gevonden.Count
        Regels  = $gevonden.Line
    }
}

# ---------------------------------------------------------------
# Week 5 : externe systemen (opdracht 5-2)
# ---------------------------------------------------------------

<#
.SYNOPSIS
Haalt de gegevens van een voertuig op bij de RDW (open data) op basis van het kenteken.
.PARAMETER Kenteken
Het kenteken, met of zonder streepjes.
.EXAMPLE
Get-RdwVoertuig -Kenteken 00-BZB-8
#>
function Get-RdwVoertuig {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidatePattern('^[A-Za-z0-9-]{1,8}$')]
        [string]$Kenteken
    )

    $schoonKenteken = $Kenteken.ToUpper().Replace("-", "")
    $voertuig = Invoke-RestMethod -Uri "https://opendata.rdw.nl/resource/m9d7-ebf2.json?kenteken=$schoonKenteken" -Method Get

    if (-not $voertuig) {
        Write-Warning "Er is geen voertuig gevonden met kenteken $schoonKenteken."
        return
    }

    $voertuig
}

# ---------------------------------------------------------------
# Week 6 : eigen objecten en commandlets (opdracht 6-1 en 6-3)
# ---------------------------------------------------------------

<#
.SYNOPSIS
Geeft een object met het besturingssysteem, de gebruikersnaam en de computernaam (alleen Windows).
.EXAMPLE
Get-UserInfo
#>
function Get-UserInfo {
    [CmdletBinding()]
    param ()

    $os = Get-CimInstance -ClassName Win32_OperatingSystem

    [PSCustomObject]@{
        Besturingssysteem = $os.Caption
        Gebruikersnaam    = $env:USERNAME
        ComputerNaam      = $env:COMPUTERNAME
    }
}

<#
.SYNOPSIS
Simuleert een worp met een dobbelsteen.
.PARAMETER Zijden
Het aantal zijden van de dobbelsteen (2 t/m 100, standaard 6).
.EXAMPLE
Get-Dobbelsteen -Verbose
#>
function Get-Dobbelsteen {
    [CmdletBinding()]
    param (
        [ValidateRange(2, 100)]
        [int]$Zijden = 6
    )

    begin {
        Write-Verbose "Ik ga nu rollen..."
    }

    process {
        $rol = Get-Random -Minimum 1 -Maximum ($Zijden + 1)
        Write-Output "Je hebt een $rol gegooid!"
    }

    end {
        Write-Verbose "De worp is klaar."
    }
}

# ---------------------------------------------------------------
# Week 7 : parameter validatie (opdracht 7-2)
# ---------------------------------------------------------------

<#
.SYNOPSIS
Test parameter validatie met een getal.
.PARAMETER Leeftijd
Een geheel getal van 1 t/m 120.
.EXAMPLE
Test-ParameterValidation -Leeftijd 30
#>
function Test-ParameterValidation {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateRange(1, 120)]
        [int]$Leeftijd
    )

    Write-Output "De leeftijd $Leeftijd is geldig."
}

<#
.SYNOPSIS
Zet een verkeerslicht op een kleur.
.PARAMETER Kleur
Rood, Oranje of Groen (hoofdletters maken niet uit).
.EXAMPLE
Set-TrafficLight -Kleur Groen -WhatIf
#>
function Set-TrafficLight {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [ValidateSet("Rood", "Oranje", "Groen", IgnoreCase = $true)]
        [string]$Kleur
    )

    # ValidateSet is niet hoofdlettergevoelig, dus we zetten de kleur netjes om naar bijvoorbeeld "Rood"
    $kleurNetjes = $Kleur.Substring(0, 1).ToUpper() + $Kleur.Substring(1).ToLower()

    if ($PSCmdlet.ShouldProcess("het verkeerslicht", "op $kleurNetjes zetten")) {
        Write-Output "Het verkeerslicht staat nu op $kleurNetjes."
    }
}

# Bepaal wat de gebruikers van de module mogen gebruiken
Export-ModuleMember -Function Test-Ping, Get-DirectoryObjectCount, Get-TempFolderSummary, Import-ValidCsv, Get-TcpProcess, Get-LargeFile, Search-LogFile, Get-RdwVoertuig, Get-UserInfo, Get-Dobbelsteen, Test-ParameterValidation, Set-TrafficLight -Alias Ping-Address
