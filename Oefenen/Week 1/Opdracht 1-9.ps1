# Opdracht 1-9 : Herschrijf het script van opdracht 1-6, zodat het van een functie gebruik maakt.
# Moeilijkheid: 2/3
# (PowerUp) : Zorg met een lusje dat je telkens een nieuw IP-adres kunt pingen

# Het scherm leegmaken
Clear-Host

# 1. De functie Ping-Address met 1 parameter Ipaddress van het type string.
# (Ping is geen "approved verb", zie Get-Verb. In de module van week 7 heet deze functie daarom Test-Ping.)
# De functie moet gedefinieerd zijn voordat je hem aanroept.
function Ping-Address {
    param (
        [string]$Ipaddress
    )

    Write-Host "Pinging... $Ipaddress"

    # Foutafhandeling (idee van Hintenhaus04): een hostnaam die niet gevonden wordt geeft een nette melding
    try {
        Test-Connection -TargetName $Ipaddress -IPv4 -Count 3 -ErrorAction Stop
    }
    catch {
        Write-Host "Pingen van $Ipaddress is mislukt: $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host # lege regel
}

# 2. Hulp-variabele voor de lus
$continue = $true

# 3. (PowerUp) Blijf IP-adressen vragen totdat de gebruiker "exit" intypt
while ($continue) {
    $ipaddress = Read-Host -Prompt "Welke IP-adres wil je pingen?"

    if ($ipaddress -eq "exit") {
        Write-Host "Stoppen"
        $continue = $false
    }
    else {
        # 4. Roep de functie aan en geef $ipaddress mee als parameter
        Ping-Address -Ipaddress $ipaddress
    }
}
