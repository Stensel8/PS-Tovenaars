# Proeftoets Scripting met PowerShell - Opgave 5 : Uitbreidingen (30 punten)
# Een aantal scripts is geschikt om als zelfstandige cmdlet te worden gebruikt. De functie Test-Log uit
# opgave 3 wordt hier "verbouwd" tot een cmdlet met extra functionaliteit.

# Het scherm leegmaken
Clear-Host

$scriptMap = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }

# a) Kopieer de functie Test-Log naar dit script en breid hem uit.
# b) Maak er een cmdlet van met de parameters SearchText en FileName ([CmdletBinding()]).
# c) Voeg parameter validatie toe:
#    i.   SearchText moet minimaal 3 tekens lang zijn
#    ii.  FileName moet minimaal 8 tekens lang zijn
#    iii. Alle parameters zijn verplicht
# Let op: [ValidateLength(3, -1)] uit de officiele uitwerking geeft in PowerShell 7.6 een fout
# ("maxLength out of range"). [int]::MaxValue werkt wel en betekent in de praktijk onbeperkt.
<#
.SYNOPSIS
Test of een bepaalde tekst voorkomt in een opgegeven bestand.
.DESCRIPTION
Zoekt in alle regels van het bestand naar de opgegeven tekst en geeft per gevonden regel een object
met het regelnummer en de regel terug.
.PARAMETER SearchText
De te zoeken tekst (minimaal 3 tekens).
.PARAMETER FileName
Het te doorzoeken bestand (minimaal 8 tekens).
.EXAMPLE
Test-Log -SearchText "Heartbeat" -FileName ".\SystemUpdate.log"
#>
function Test-Log {
    [CmdletBinding()]
    # return $output geeft de records een voor een door de pipeline (PowerShell "unrolt" de ArrayList), dus de uitvoer
    # bestaat uit PSCustomObject. Wil je 1 ArrayList, gebruik dan return ,$output (maar dan werkt Select-Object -First niet meer).
    [OutputType([PSCustomObject])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseOutputTypeCorrectly", "", Justification = "PSScriptAnalyzer ziet de ArrayList, maar PowerShell geeft de losse PSCustomObjects door")]
    param (
        [Parameter(Mandatory)]
        [ValidateLength(3, [int]::MaxValue)]
        [string]$SearchText,

        [Parameter(Mandatory)]
        [ValidateLength(8, [int]::MaxValue)]
        [string]$FileName
    )

    # a.ii) Een nieuw object van het type System.Collections.ArrayList
    $output = New-Object -TypeName System.Collections.ArrayList

    # a.iii) Zoek in alle regels van het opgegeven bestand naar het opgegeven woord
    $regelnummer = 0
    foreach ($regel in Get-Content -Path $FileName) {
        $regelnummer++

        # 1. Als het woord wordt gevonden...
        if ($regel -match [regex]::Escape($SearchText)) {
            # a. ...maak een nieuw custom object met "Regelnummer" (Int32) en "Regel" (string)
            $object = [PSCustomObject]@{
                Regelnummer = [int]$regelnummer
                Regel       = [string]$regel
            }

            # b. ...en voeg het toe aan de ArrayList
            $output.Add($object) | Out-Null
        }
    }

    # a.iv) Laat de functie de ArrayList met custom objecten retourneren
    return $output
}

# Test de cmdlet
Test-Log -SearchText "Heartbeat" -FileName (Join-Path -Path $scriptMap -ChildPath "SystemUpdate.log") | Select-Object -First 5 | Format-Table -AutoSize

# d) Het modulebestand en manifest staan in de map StudentXYZ (naam van de module = "Student" + je studentnummer).
# Wijzig de bestandsnamen en de module naam in je eigen studentnummer.
# Test of je cmdlet "Test-Log" via de module kunt gebruiken. De module hoeft NIET op het systeem geinstalleerd te worden.
Import-Module -Name (Join-Path -Path $scriptMap -ChildPath "StudentXYZ\StudentXYZ.psd1") -Force

# Met de naam van de module ervoor testen we de versie uit de module, en niet de functie hierboven
StudentXYZ\Test-Log -SearchText "Heartbeat" -FileName (Join-Path -Path $scriptMap -ChildPath "SystemUpdate.log") | Select-Object -First 5 | Format-Table -AutoSize
Get-Command -Module StudentXYZ
