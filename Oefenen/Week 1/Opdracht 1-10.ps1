# Opdracht 1-10 : Schrijf een script, waarbij je gebruik maakt van een functie, om een geheim random getal te raden (Hoger-Lager).
# Moeilijkheid: 3/3

# Het scherm leegmaken
Clear-Host

# 1. Een random geheim getal tussen 0 en 100 (Get-Random: -Maximum is exclusief, dus 101).
# Plus een hulp-variabele voor de while-lus.
$secret = Get-Random -Minimum 0 -Maximum 101
$notguessed = $true
$pogingen = 0

# 2. De functie Test-Number (Test is een approved verb, zie Get-Verb).
# De functie geeft $true terug als het getal geraden is, anders $false. Er zijn drie mogelijkheden:
# het getal is te laag, te hoog of precies goed.
function Test-Number {
    [OutputType([bool])]
    param (
        [int16]$Number
    )

    if ($Number -lt $secret) {
        Write-Host "Hoger"
        $false
    }
    elseif ($Number -gt $secret) {
        Write-Host "Lager"
        $false
    }
    else {
        # Het getal is geraden
        $true
    }
}

# 3. Blijf een getal vragen totdat het geraden is
while ($notguessed) {
    $guess = Read-Host -Prompt "Raad het getal?"

    # Controleer of de invoer een geheel getal is (anders geeft de functie een foutmelding)
    $getal = 0
    if (-not [int16]::TryParse($guess, [ref]$getal)) {
        Write-Warning "Dat is geen geldig getal, probeer het opnieuw."
        continue
    }

    $pogingen++

    # 4. Als de functie $true teruggeeft, feliciteer de gebruiker en verlaat de lus
    if (Test-Number -Number $getal) {
        Write-Host "Je hebt het getal geraden!"
        Write-Host "Aantal pogingen=$pogingen"
        $notguessed = $false
    }
}
