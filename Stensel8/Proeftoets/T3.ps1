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

$sessionOption = New-PSSessionOption -SkipCACheck -SkipCNCheck

$session = New-PSSession -ComputerName powershell-sten.westeurope.cloudapp.azure.com -Credential (Get-Credential) -UseSSL -SessionOption $sessionOption

Invoke-Command -Session $session -ScriptBlock {
    $ENV:USERNAME
    $ENV:COMPUTERNAME
}
