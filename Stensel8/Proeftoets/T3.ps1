Clear-Host

$klantmachines = (Get-Content -Path ".\Klantmachines.json" | ConvertFrom-Json).Klantmachine

$klantmachines | ConvertTo-Html | Out-File -FilePath ".\klantmachines.html"

function Test-Log {
    $zoekwoord = Read-Host -Prompt "Geef een zoekwoord op"
    $file = Get-Content -path ".\SystemUpdate.log"
    $count = 0

    foreach ($line in $file) {
        if ($line -match $zoekwoord) {
            $count++
        }
    }
    Write-Host "Het zoekwoord $zoekwoord komt ${count}x voor."
}
Test-Log

# Let op: -SkipCACheck en -SkipCNCheck zet de controle van het servercertificaat uit. De proeftoets eist dat, omdat
# de toetsserver een zelf-gesigneerd certificaat heeft. Gebruik dit NOOIT voor een echte server (onderschepping van inloggegevens).
$sessionOption = New-PSSessionOption -SkipCACheck -SkipCNCheck

$server = "powershell-sten.westeurope.cloudapp.azure.com"
$session = New-PSSession -ComputerName $server -Credential (Get-Credential) -UseSSL -SessionOption $sessionOption

Invoke-Command -Session $session -ScriptBlock { # DevSkim: ignore DS104456
    [System.Environment]::UserName
    [System.Environment]::MachineName
}
