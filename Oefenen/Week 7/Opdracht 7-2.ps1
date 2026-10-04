# Opdracht 7-2 : Parameter validatie
# Moeilijkheid: 2/3
# - Test-ParameterValidation heeft 1 parameter Leeftijd (Int32) die alleen een getal van 1 t/m 120 mag zijn
# - Set-TrafficLight heeft 1 parameter Kleur (String) die alleen "Rood", "Oranje" of "Groen" mag zijn
# Test beide functies voor goede en foute situaties.
# Beide functies zitten ook in de module PSTovenaars (versie 1.1.0): na het toevoegen van parameter
# validatie hebben we het versienummer in het manifest opgehoogd van 1.0.0 naar 1.1.0.

# Het scherm leegmaken
Clear-Host

# Je hebt 2 manieren om een parameter te controleren:
#   1. try-catch in de body van de functie (veel werk en de body staat vol code die niets met de functie zelf te maken heeft)
#   2. parameter validators (attributen) zoals ValidateRange, ValidateLength, ValidateSet en ValidatePattern

# 1. Een getal van 1 t/m 120: het type [int] is de type check, ValidateRange de grenzen
function Test-ParameterValidation {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateRange(1, 120)]
        [int]$Leeftijd
    )

    Write-Output "De leeftijd $Leeftijd is geldig."
}

# 2. Een keuze uit een lijstje met ValidateSet (hoofdletters maken niet uit).
# Deze functie ondersteunt ook -WhatIf en -Confirm via SupportsShouldProcess.
function Set-TrafficLight {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [ValidateSet("Rood", "Oranje", "Groen", IgnoreCase = $true)]
        [string]$Kleur
    )

    $kleurNetjes = $Kleur.Substring(0, 1).ToUpper() + $Kleur.Substring(1).ToLower()

    if ($PSCmdlet.ShouldProcess("het verkeerslicht", "op $kleurNetjes zetten")) {
        Write-Output "Het verkeerslicht staat nu op $kleurNetjes."
    }
}

# 3. Test de goede situaties
Write-Host "--- Goede situaties" -ForegroundColor Green
Test-ParameterValidation -Leeftijd 30
Test-ParameterValidation -Leeftijd 1
Test-ParameterValidation -Leeftijd 120
Set-TrafficLight -Kleur Rood
Set-TrafficLight -Kleur oranje
Set-TrafficLight -Kleur Groen -WhatIf

# 4. Test de foute situaties. De validatie gooit een fout, die we met try-catch netjes tonen.
Write-Host "--- Foute situaties" -ForegroundColor Red
foreach ($leeftijd in @("0", "121", "-5", "abc")) {
    try {
        Test-ParameterValidation -Leeftijd $leeftijd
    }
    catch {
        Write-Host "Leeftijd '$leeftijd' is niet toegestaan: $($_.Exception.Message)" -ForegroundColor Red
    }
}

foreach ($kleur in @("Paars", "Blauw", "")) {
    try {
        Set-TrafficLight -Kleur $kleur
    }
    catch {
        Write-Host "Kleur '$kleur' is niet toegestaan: $($_.Exception.Message)" -ForegroundColor Red
    }
}
