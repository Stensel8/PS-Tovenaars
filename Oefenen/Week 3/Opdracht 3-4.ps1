$filename = Read-Host "voer de naam in van een bestand in"

if($filename -eq "") {
    Write-Host "Geen bestand opgegeven"
    exit
}

try {
    Import-Csv -Path $filename -ErrorAction Stop
} catch {
    if ($_.Exception -is [System.IO.FileNotFoundException]) {
        Write-Host "de file bestaat niet"
    } elseif ($filename -notlike "*.csv") {
        Write-Host "file is geen csv bestand"
    } else {
        Write-Host "Er is een onbekende fout opgetreden: $($_.Exception.Message)"
    }
}
