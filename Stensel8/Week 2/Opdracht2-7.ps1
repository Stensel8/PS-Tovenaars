# Check for administrator privileges
# $currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
# $principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity)
# if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
#     Write-Warning "Administrator rights are required. Please run this script as an administrator."
#     exit
# }

# WhatIf en Confirm parameters gebruiken

# Het scherm leegmaken
Clear-Host

# Vragen om de BITS-service te stoppen
Stop-Service -Name BITS -WhatIf

# De service stoppen
Stop-Service -Name BITS -Confirm
