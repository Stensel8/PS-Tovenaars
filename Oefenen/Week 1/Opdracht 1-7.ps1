# Opdracht 1-7 : Vraag een hostname aan de gebruiker en sla deze op in een lijst met hostnames, totdat de gebruiker "exit" intypt.
# Moeilijkheid: 2/3
# (PowerUp) : Voer het script uit met een extra punt (dot sourcing): . ".\Opdracht 1-7.ps1"

# Het scherm leegmaken
Clear-Host

# 1. Een lege lijst voor de hostnames en een hulp-variabele voor de while-lus
$hostnames = @()
$continue = $true

# 2. Blijf een hostname vragen totdat de gebruiker "exit" intypt
while ($continue) {
    $hostname = Read-Host -Prompt "Voeg een hostname toe (of exit om te stoppen)"

    if ($hostname -eq "exit") {
        # De gebruiker wil stoppen: de while-conditie wordt $false
        Write-Warning "Stoppen"
        $continue = $false
    }
    elseif ([string]::IsNullOrWhiteSpace($hostname)) {
        # Een lege invoer is geen hostname
        Write-Warning "Je hebt niets ingevuld, probeer het opnieuw."
    }
    else {
        # Alles wat geen "exit" is, beschouwen we als hostname
        $hostnames += $hostname
    }
}

# 3. Print het aantal elementen in de lijst
Write-Host "Aantal hostnames=" -NoNewline
Write-Host $hostnames.Count

# Extra: print de hele lijst
Write-Host $hostnames

# 4. (PowerUp) Dot sourcing: start het script met een extra punt, dan blijven de variabelen na afloop
# beschikbaar in je PowerShell venster. Daarna kun je bijvoorbeeld Write-Host $hostnames uitvoeren.
# . ".\Opdracht 1-7.ps1"
