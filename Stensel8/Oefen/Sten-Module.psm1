function Get-Greeting {
    param (
        [string]$greeting
    )
    Write-Host $greeting
}

function Get-Square {
    param (
        [int]$Number
    )
    $Result = $null
    try {
        $Result = $Number * $Number
    }
    catch {
        Write-Error "Er ging iets fout bij het kwadraten..."
    }
    finally {
        Write-Output "Kwadraat is $Result" 
    }
}
