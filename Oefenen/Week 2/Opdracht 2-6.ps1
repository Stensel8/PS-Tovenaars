Get-ChildItem -path C:\Windows\system32\*.txt | sort-object -property name -Descending | ForEach-Object { 
    Write-Host $_.Name
}
