# Programma om een lijst te tonen van alle services op deze computer
$myServices = Get-Service | Select-Object -Property Status, Name
Clear-Host


Write-Host "========= SORT BY STATUS ==========="
$myServices | Sort-Object -Property Status, Name
