$secret = Get-Random -Minimum 1 -Maximum 10

#nog verder naar kijken
$guessed = $false

while (!$guessed) {
    $guess = Read-Host "Guess the number between 1 and 10"
    if (test-number -number $guess -eq $true) {
        Write-Host "you guessed the number!" -ForegroundColor Green
        $guessed = $true
    }
}
    


function test-number {
    [OutputType([boolean])]
    param (
        [int]$number
    )
    
    if ($number -lt $secret) {
        write-host "Hoger"
    } 
    elseif ($number -gt $secret) {
        write-host "Lager"
    } 
    elseif ($number -eq $secret) {
        write-host "Correct!" 
        return $true
    }
}

