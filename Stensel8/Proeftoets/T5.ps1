Clear-Host

function Test-Log {
    [CmdletBinding()]
    # return $output geeft de records een voor een door de pipeline (PowerShell "unrolt" de ArrayList), dus de uitvoer
    # bestaat uit PSCustomObject. Wil je 1 ArrayList, gebruik dan return ,$output (maar dan werkt Select-Object -First niet meer).
    [OutputType([PSCustomObject])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseOutputTypeCorrectly", "", Justification = "PSScriptAnalyzer ziet de ArrayList, maar PowerShell geeft de losse PSCustomObjects door")]
    param (
        [parameter()]
        [string]
        [ValidateLength(3,100)]
        $searchText,

        [string]
        [ValidateLength(8,100)]
        $filename
    )

    begin {
        $output = New-Object System.Collections.ArrayList
        $file = Get-Content $filename
        $count = 0
    }
    process {
        foreach ($line in $file) {
            $count++
            if ($line -match $searchText) {
                $obj = [PSCustomObject]@{
                    Regelnummer = $count
                    Regel       = $line
                }
                $output.Add($obj) | Out-Null
            }
        }
    }

    end {
        return $output
    }
}
