# While loopje voorbeeld van Erik (docent)

clear-host

while ($true) {
    #ask for hostname
    $hostname = Read-Host -Prompt "Voeg een hostname toe (of 'exit' om te stoppen)"
    Write-Host "De ingevoerde hostname is: $hostname"
    
    #check if hostname is empty
    if ($hostname -eq "") {
        Write-Host "Geen hostname ingevoerd, probeer het opnieuw."
        continue
    }
    #check if hostname is 'exit'
    elseif ($hostname -eq "exit") {
        Write-Host "Het script wordt afgesloten."
        break
    }
    #check if hostname is valid
    elseif ($hostname -notmatch "^[a-zA-Z0-9\-\.]+$") {
        Write-Host "Ongeldige hostname, probeer het opnieuw."
        continue
    }
    else {
        Write-Host "De ingevoerde hostname is geldig."
        break
    }
}
