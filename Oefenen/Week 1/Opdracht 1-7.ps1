$contiue = $true

$hostnames = @()

while ($contiue) {
    $hostname = Read-Host "type a hostname (to stop type 'exit')"
    if ($hostnames -eq 'exit') {
        $contiue = $false
    }  else {
        $hostnames += $hostname
    }
}
write-host "The hostnames you entered are: $hostnames"
