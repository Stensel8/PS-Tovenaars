$tempfilesArray = @()
$foldercount = 0
$filecount = 0
$filesize = 0
foreach ($object in Get-ChildItem $env:TEMP -recurse) {
    $tempfilesArray += $object
    if ($object = Test-Path $object.FullName -pathtype leaf) {
        $filecount++
    } else  {
        $foldercount++
    }
    $filesize += $object.length
}

Write-Host "Er zijn $foldercount folders en $filecount bestanden in de directory $env:TEMP."

Write-Host "De totale grootte van de bestanden in de directory $env:TEMP is $filesize bytes."
