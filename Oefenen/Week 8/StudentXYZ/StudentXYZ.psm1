# Opgave 5d : Eigen module. De naam van het modulebestand is gelijk aan de naam van de module.
# Vervang XYZ door je studentnummer (en hernoem ook het .psd1 bestand en RootModule in het manifest).

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

    $output = New-Object -TypeName System.Collections.ArrayList

    $regelnummer = 0
    foreach ($regel in Get-Content -Path $FileName) {
        $regelnummer++

        if ($regel -match [regex]::Escape($SearchText)) {
            $object = [PSCustomObject]@{
                Regelnummer = [int]$regelnummer
                Regel       = [string]$regel
            }
            $output.Add($object) | Out-Null
        }
    }

    return $output
}

# Beperk de geexporteerde commando's tot Test-Log
Export-ModuleMember -Function Test-Log
