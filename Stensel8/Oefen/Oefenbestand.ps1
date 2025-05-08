Clear-Host

$name = Read-Host -Prompt "Typ je naam in"

Write-Host "Hallo $name, welkom bij de Powershell oefenopdracht!" -ForegroundColor Green


$hypervservices = Get-Service -DisplayName *hyper-v*

Start-Sleep -seconds 2
Write-Host "De Hyper-V services zijn:" -ForegroundColor Yellow
start-sleep -seconds 3
Write-Host ""
Write-Host ""
$hypervservices | Format-Table -AutoSize

