# get-command -Module NetTCPIP

# Get-NetTCPConnection

# get-help Get-NetTCPConnection 

# Get-NetTCPConnection -RemoteAddress -remoteport

foreach ($process in (Get-NetTCPConnection -RemotePort 443).OwningProcess) {
    $process
    Get-Process | where-object { $_.Id -in $process.OwningProcess } | Select-Object ProcessName, Id
}


$processid = (Get-NetTCPConnection | where-object { $_.RemotePort -eq 443 }).OwningProcess
get-Process | where-object { $_.Id -in $processid} | Select-Object ProcessName, Id | sort-object Descending