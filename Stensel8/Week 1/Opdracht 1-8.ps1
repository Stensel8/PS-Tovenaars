# 1.4-Scripting-met-Powershell
# Opdracht 1-8 : Maak een script dat een gegeven password checkt.

Clear-Host

# 1. Maak een variabele $secret voor het geheime wachtwoord en een hulp-variabele $closed met als standaardwaarde $True.
$secret = "Hond"
$closed = $true

# 2. Vraag om een password en sla deze op in variabele $password. Gebruik als prompt “Password?” en gebruik parameter -MaskInput om invoer te verbergen.
# $password =  Read-Host "Password?" -MaskInput

# 3. Maak een while-lus, zodat het wachtwoord telkens wordt gevraagd. Als while-conditie gebruik je $closed.
while ($closed) {
    # 3.1 Vraag om een password en sla deze op in variabele $password. Gebruik als prompt “Password?” en gebruik parameter -MaskInput om invoer te verbergen.
    $password = Read-Host "Password?" -MaskInput

    # 3.2 Voeg een controle met een if statement om te kijken of het ingevoerde wachtwoord overeenkomt het met $secret. Als het wachtwoord geraden is wijzig je de variabele uit de while-conditie, zodat het programma uit de while lus gaat. Als het antwoord fout is, print je een melding met Write-Host, waarbij je in rode letters aangeeft dat het wachtwoord fout was.
    if ($password -eq $secret) {
        $closed = $false
    } else {
        Write-Host "Wachtwoord fout!" -ForegroundColor Red
    }
}

# 4. Voeg een controle met een if statement om te kijken of het ingevoerde wachtwoord overeenkomt het met $secret. Als het wachtwoord geraden is wijzig je de variabele uit de while-conditie, zodat het programma uit de while lus gaat. Als het antwoord fout is, print je een melding met Write-Host, waarbij je in rode letters aangeeft dat het wachtwoord fout was.

# 5. Voeg buiten de while-lus een commando toe om in groene letters aan te geven dat het wachtwoord geraden is.

# 6. (PowerUp) Wijzig het script en zorg ervoor dat je het aantal pogingen bijhoudt in een variabele. En print deze na het raden uit.

