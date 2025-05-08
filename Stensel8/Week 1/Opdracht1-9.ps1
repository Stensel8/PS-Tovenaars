# 1.4-Scripting-met-Powershell
# Opdracht 1-9 : Herschrijf het script van opdracht 1-6, zodat het van een functie gebruik maakt.

# Maak een functie Ping-Addresss waarin je de code voor het testen van een IP-adres plaatst. We gebruiken als naming convention twee losse woorden met een streepje ertussen.

# Wijzig de functie zodanig dat deze 1 parameter Ipaddress accepteert van type String.

# Voeg na de functie een vraag om een IP-adres toe en sla deze op in variabele $ipaddress. Doe dit met behulp van Read-Host. Gebruik de prompt “Welke IP-adres wil je pingen?”.

# Roep je functie Ping-Address aan en geef $ipaddress mee als parameter.

# (PowerUp) Zorg met een lusje dat je telkens een nieuw IP-adres kunt pingen.

# Voorbeeld uitkomst
# Welke IP-adres wil je pingen?: 192.168.2.1
# Pinging... 192.168.2.1

#    Destination: 192.168.2.1

# Ping Source           Address                   Latency BufferSize Status 
#                                                    (ms)        (B)        
# ---- ------           -------                   ------- ---------- ------ 
#    1 CND0475T07       192.168.2.1                     1         32 Success
#    2 CND0475T07       192.168.2.1                     0         32 Success
#    3 CND0475T07       192.168.2.1                     0         32 Success

# Welke IP-adres wil je pingen?: exit
# Stoppen




# define function Ping-Address


function Ping-Address {
    param ([string]$Ipaddress)
    Write-Host "Pinging... $Ipaddress"
    Test-Connection $Ipaddress -Count 3 -IPv4
}

#initialize help variable
$continue = $true

#loop over the function
while ($continue) {
    # ask for ipaddress
    $ipaddress = Read-Host "Welke IP-adres wil je pingen?"
    
    # check if the user wants to exit
    if ($ipaddress -eq "exit") {
        $continue = $false
        Write-Host "Stoppen"
    } else {
        # call the function with the ipaddress as parameter
        Ping-Address -Ipaddress $ipaddress
    }
}
