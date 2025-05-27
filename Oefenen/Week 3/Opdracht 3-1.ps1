# Get-PSDrive

# Get-PSDrive C

# Get-PSDrive

# Set-Location c:\

# Get-ChildItem -file | Get-Member -MemberType Property

set-location C:\Users\Wouta\Documents\GitHub\PS-Tovenaars\Oefenen

Get-ChildItem -File -Recurse | where-object { $_.Extension -eq ".mp4" }
