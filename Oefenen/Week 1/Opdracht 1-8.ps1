$guessed = $false
$password = "goeindag"

while (!$guessed) {
    $guess = Read-Host "Guess the password"
    if ($guess -eq $password) {
        Write-Host "You guessed the password!" -ForegroundColor Green
        $guessed = $true
    } else {
        Write-Host "Try again!" -ForegroundColor Red
    }
}