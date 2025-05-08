$myProcesses = Get-Process

$myProcesses[0] | Format-Table Name, Id, CPU, NPM, PM, WS -AutoSize
