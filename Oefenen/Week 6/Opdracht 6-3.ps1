# Opdracht 6-3 : Maak van een functie een commandlet
# Moeilijkheid: 1/3
# Schrijf een functie die een worp met een dobbelsteen simuleert met Get-Random en maak er met
# CmdletBinding een commandlet van.

# Het scherm leegmaken
Clear-Host

# [CmdletBinding()] maakt van de functie een "advanced function" die zich gedraagt als een gecompileerde commandlet:
# je krijgt de algemene parameters zoals -Verbose gratis erbij.
# De code staat in 3 blokken: begin (voorbereiding), process (hoofdblok) en end (afronding).
function Get-Dobbelsteen {
    [CmdletBinding()]
    param ()

    begin {
        Write-Verbose "Ik ga nu rollen..."
    }

    process {
        # Een dobbelsteen heeft zes zijden. -Maximum is exclusief, dus 7 geeft een getal van 1 t/m 6.
        $rol = Get-Random -Minimum 1 -Maximum 7
        Write-Output "Je hebt een $rol gegooid!"
    }

    end {
        Write-Verbose "De worp is klaar."
    }
}

# Test de commandlet: gewoon en met -Verbose
Get-Dobbelsteen
Get-Dobbelsteen -Verbose
