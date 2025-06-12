$contiue = $true

$hostnames = @()

while ($contiue) {
    $hostname = Read-Host "type a hostname (to stop type 'exit')"
    if ($hostname -eq 'exit') {
        $contiue = $false
    }  else {
        $hostnames += $hostname
    }
}
write-host "The hostnames you entered are: $hostnames"
