#Het scherm leegmaken
Clear-Host

$studentnaam = "Sten Tijhuis"
$studentnummer = "550600"

Write-Host -ForegroundColor Green $studentnaam
Write-Host -ForegroundColor Green $studentnummer

#A
# $json = Get-Content -Raw -Path 'Klantmachines.json'
# $klantmachines = ($json | ConvertFrom-Json).klantmachine

# # Omzetten naar HTML
# $klantmachines | ConvertTo-Html -Property computernaam, ip -Title "Klantmachines" | Out-File -FilePath "Klantmachines.html"


#B
function Test-Log {
    param (
        [string]$zoekwoord
    )

    try {
        if (-not (Test-Path "SystemUpdate.log")) {
            Write-
        }
    }
    catch {
        <#Do this if a terminating exception happens#>
    }
    
}


# Simpele manier
# $zoekwoord = Read-Host
# $count = ($log | Select-String -Pattern $zoekwoord).count
# $count



#C
$hostname = localhost

$cred = Get-Credential

$sessionOption = New-PSSession -ComputerName $hostname -Credential $cred -UseSSL -SessionOption $sessionOption
$session

$serverName = Invoke-Command -Session $session -ScriptBlock { $env:COMPUTERNAME }


#PSSessions kun je enteren met Enter-PSSession
