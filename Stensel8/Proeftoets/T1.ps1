$studentnaam = "Sten Tijhuis"
$studentnummer = 550600

Clear-Host

Write-Host $studentnaam, $studentnummer -ForegroundColor Green

$modulepath = $ENV:PSModulePath

if (Test-Connection -TargetName powershell-sten.westeurope.cloudapp.azure.com -TcpPort 5985) {
    $5985 = "Ja"
} else {
    $5985 = "Nee"
}

if (Test-Connection -TargetName powershell-sten.westeurope.cloudapp.azure.com -TcpPort 5986) {
    $5986 = "Ja"
} else {
    $5986 = "Nee"
}

$services = Get-Service -Exclude McpManagementService, Dcsvc, WaaSMedicSvc
$started = (get-service -Exclude McpManagementService, Dcsvc, WaaSMedicSvc | Where-Object {$_.Status -eq 'running'}).count

#E

$files = @((Get-ChildItem -path ".\" -File).FullName)

#F

function Resultaat {
    $studentnaam
    $studentnummer
    $started
    $5985
    $5986
    $files
    $modulepath
    $services
}
Resultaat | Out-File -FilePath ".\T1.result" -Append -Force
