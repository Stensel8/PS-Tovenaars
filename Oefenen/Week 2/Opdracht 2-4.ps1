Get-ChildItem -Path C:\Windows | Measure-Object | ForEach-Object {
    Write-Host "Er zijn $($_.Count) objecten in de directory 'C:\Windows'."
}
