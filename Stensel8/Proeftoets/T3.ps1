

#T3-a
$json = Get-Content -Raw -Path 'Klantmachines.json'
$klantmachines = ($json | ConvertFrom-Json).klantmachine
$klantmachines | ConvertTo-Html -Property computernaam, ip -Title "Klantmachines" | Out-File -FilePath "Klantmachines.html"

#T3-b
function Test-Log ([String] $zoekwoord) {
    $filename = "SystemUpdate.log"
    $log = Get-Content -Path $filename
    #$zoekwoord = Read-Host -Prompt "Zoekwoord"
    $count=0
    $linecount=1
    foreach ($line in $log) {
        $linecount = $linecount + 1
        Write-Host $linecount
        if ($line -match $zoekwoord) {
            write-host "match"
            $count = $count + 1
        } else {
            write-host "skip"
        }
    }
    $output = "x" 
    Write-Host "Het zoekwoord $zoekwoord komt $count$output voor."
}
$heartbeat=Test-Log("Heartbeat")
$heartbeat

#T3-c
#Enable-PSRemoting

# Get Credentials
$Cred = Get-Credential

# Set up session option needed to
$sessionOption = New-PSSessionOption -SkipCACheck -SkipCNCheck
# Create a session
$hostname = "powershell-scripting.westeurope.cloudapp.azure.com"
$session = New-PSSession -ComputerName $hostname -Credential $Cred -UseSSL -SessionOption $sessionOption


$serverName = Invoke-Command -Session $session -ScriptBlock { $env:COMPUTERNAME }
