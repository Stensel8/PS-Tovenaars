# Het aantal objecten in een map tellen
param (
    [string]$directoryPath
)

# Als er geen parameter is opgegeven, vraag dan om invoer
if (-not $directoryPath) {
    $directoryPath = Read-Host -Prompt "Geef de map op waarvan je het aantal objecten wilt tellen"
}

# Tel objecten met pipelining
Get-ChildItem -Path $directoryPath | Measure-Object | ForEach-Object {
    Write-Host "De directory $directoryPath bevat $($_.Count) files en directories"
}
