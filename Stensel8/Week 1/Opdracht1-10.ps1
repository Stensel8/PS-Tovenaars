# 1.4-Scripting-met-Powershell
# Opdracht 1-10 : Schrijf een script, waarbij je gebruik maakt van een functie, om een geheim random getal te raden (Hoger-Lager).
# Maak een variabele $secret voor het geheime wachtwoord en een hulp-variabele $notguessed met als standaardwaarde $True.

# Vul de variabele $secret met een random getal tussen 0 en 100. Tip: Zoek met Get-Help om random.

# Maak een functie Test-Number waarin je de code voor het checken van een getal plaatst. We gebruiken Approved Verbs, zie Get-Verb. Gebruik een parameter $Number van het type int16. Als het geheime getal hoger is geef je de melding “Hoger” en als het geheime getal lager is geef je de melding “Lager”.

# Wijzig de functie Test-Number en geef een boolean OutputType terug, waarbij je aangeeft of het getal geraden is of niet. Let op! Er zijn drie mogelijkheden.

# Voeg na de functie een vraag om een getal toe en sla deze op in variabele $guess. Gebruik als prompt “Raad het getal?”.

# Als de functie Test-Number $True teruggeeft, feliciteer de gebruiker “Je hebt het getal geraden!” en zorg dat je uit de loop gaat.

# Voorbeeld uitkomst
# Raad het getal?: 50
# Hoger
# Raad het getal?: 75
# Hoger
# Raad het getal?: 87
# Lager
# Raad het getal?: 80
# Je hebt het getal geraden!


function Test-Number {
    [OutputType([Boolean])]}
    param (int16)