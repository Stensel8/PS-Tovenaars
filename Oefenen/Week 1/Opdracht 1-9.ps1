$contiue = $true
$hostnames = @()

while ($contiue) {
    $hostname = Read-Host "type a ip-addresss (to stop type 'exit')"
    if ($hostname -eq 'exit') {
        $contiue = $false
    }  else {
        $hostnames += $hostname
    }
}

ping-adress

function ping-adress {
    foreach ($one in $hostnames) {
        Test-Connection -IPv4 $one -Count 3
        Write-Host "Finished pinging $one." -ForegroundColor Blue
        Write-Host #empty line  
    }

}

