$myProcesses = Get-Process | sort-object VM -descending

$selectProcesses = $myProcesses | Select-Object -First 30 -Property Name, Id, CPU, NPM, PM, WS

$selectProcesses | ConvertTo-Html | Out-File -FilePath "Processes.html"

