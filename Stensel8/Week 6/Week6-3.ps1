function Get-Dobbelsteen {
    [CmdletBinding()]
    param()

    begin {
        Write-Verbose "Ik ga nu rollen..."
    }
    
    process {
        # Genereer een random getal tussen 1 and 6
        $rol = Get-Random -Minimum 1 -Maximum 7
        Write-Output $rol
    }
    
    end {
        Write-Verbose "Je hebt $rol gegooid."
    }
}
Get-Dobbelsteen -Verbose
