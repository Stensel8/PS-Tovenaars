$continue = $true
$hostnames = @()

while ($continue) {
    $hostname = Read-Host "type an IP address (to stop type 'exit')"
    if ($hostname -eq 'exit') {
        $continue = $false
    }  else {
        $hostnames += $hostname
    }
}

function PingAddress {
    foreach ($one in $hostnames) {
        try {
            Test-Connection -ComputerName $one -Count 3 -ErrorAction Stop
            Write-Host "Successfully pinged $one." -ForegroundColor Green
        }
        catch {
            Write-Host "Failed to ping $one`: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

PingAddress
