# Gemaakt door Sten Tijhuis - 550600.

# T1.ps1

$studentnaam = "Sten Tijhuis"
$studentnummer = "550600"

Write-Host $studentnaam -ForegroundColor Green
Write-Host $studentnummer -ForegroundColor Green

$modulepath = $env:PSModulePath

$5985 =  Test-NetConnection -ComputerName localhost -Port 5985 -InformationLevel Quiet
$5986 =  Test-NetConnection -ComputerName localhost -Port 5986 -InformationLevel Quiet

$services = Get-Service | Where-Object { $_.Status -eq 'Running' -and $_.Name -notin @('McpManagementService', 'dcsvc') }
$started = $services.Count

