# Opdracht 1-8 : Maak een script dat een gegeven password checkt.
# Moeilijkheid: 2/3
# (PowerUp) : Houd het aantal pogingen bij en print dit na het raden

# Het scherm leegmaken
Clear-Host

# 1. Een variabele voor het geheime wachtwoord en een hulp-variabele voor de while-lus
$secret = "Tovenaar"
$closed = $true

# (PowerUp) Het aantal pogingen bijhouden
$turns = 0

# 2. Blijf het wachtwoord vragen totdat het goed is. -MaskInput verbergt de invoer.
while ($closed) {
    $password = Read-Host -Prompt "Password?" -MaskInput
    $turns++

    # -ceq is hoofdlettergevoelig, -eq niet
    if ($password -ceq $secret) {
        # Goed geraden: de while-conditie wordt $false
        $closed = $false
    }
    else {
        Write-Host "Fout, probeer nog eens" -ForegroundColor Red
    }
}

# 3. Buiten de while-lus: in groene letters aangeven dat het wachtwoord geraden is
Write-Host "Goed geraden, je mag door" -ForegroundColor Green
Write-Host "Aantal pogingen=$turns" -ForegroundColor Green
