
#Het scherm leegmaken
Clear-Host

#A
$studentnaam = "Sten Tijhuis"
$studentnummer = "550600"

Write-Host -ForegroundColor Green $studentnaam
Write-Host -ForegroundColor Green $studentnummer

#B
$modulepath = $env:PSModulePath

#C
if (Test-Connection -target localhost -count 1 -TcpPort 5985) {
    $5985 = "ja"
} else {
    $5985 = "nee"
}
Write-Host $5985

if (Test-Connection -target localhost -count 1 -TcpPort 5986) {
    $5986 = "ja"
} else {
    $5986 = "nee"
}
Write-Host $5986

#D
$services = Get-Service -Exclude McpManagementService, dcsvc, WaaSMedicSvc, ZTHELPER
$started = ($services | Where-Object {$_.Status -eq "Running"}).Count
$started

#E
$path = "C:\"
$files = (Get-ChildItem -Path $path -File -Recurse).Name.Count
$files

#F
function resultaat {
    $studentnaam
    $studentnummer
    $started
    $5985
    $5986
    $files
    $modulepath
    $services    
}

#G
resultaat | Out-File -FilePath .\T1.result

Start-Sleep -Seconds 5
Clear-Host
resultaat
