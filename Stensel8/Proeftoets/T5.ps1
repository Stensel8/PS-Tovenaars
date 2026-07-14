Clear-Host

function Test-Log {
    [CmdletBinding()]
    param (
    [parameter()]
    [string]
    [ValidateLength(3,100)]
    $searchText,

    [string]
    [ValidateLength(8,100)]
    $fileName
    )
    
    begin {
        $Output = New-Object -TypeName System.Collections.ArrayList
        $file = Get-Content $fileName
        $count = 0
    }
    
    process {
        foreach ($line in $file) {
            $count++
            if ($line -match $searchText) {
                $obj = [PSCustomObject]@{
                    Regelnummer = $count
                    Regel = $line
                }
                $Output.Add($obj) | Out-Null
            }
        }
    }
    end {
        return $Output
    }
}

function Test-Log {
    [CmdletBinding()]
    param (
        [parameter()]
        [string]
        [ValidateLength(3,100)]
        $searchText,

        [string]
        [ValidateLength(8,100)]
        $fileName
    )
    
    begin {
        $output = New-Object -TypeName System.Collections.ArrayList
        $file = Get-Content $fileName
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

function Test-Log {
    [CmdletBinding()]
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
