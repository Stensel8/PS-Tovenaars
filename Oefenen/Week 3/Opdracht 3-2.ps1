#opdracht kan niet zomaar worden uitgevoerd. deze key bestaat alleen als je specifiek updatebeleid hebt, wat school hoogstwaarschijlijk heeft.

get-psdrive -PSProvider Registry

set-location HKLM:
Get-ChildItem 

$WUPath = "HKLM:\SOFTWARE\policies\Microsoft\Windows\WindowsUpdate"
$AUPath = "$WUPath\AU"

if (!(Test-Path -Path $WUPath)) {
    New-Item -Path $WUPath -Force | Out-Null
}

if (Test-Path -Path $AUPath){
    Write-Host "De AU key bestaat al."
} else {
    New-Item -Path $AUPath -Force | Out-Null
    Write-Host "De AU key is aangemaakt."
}

New-ItemProperty -Path $AUPath -Name "NoAutoUpdate" -Value 1 -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path $AUPath -Name "AUOptions" -Value 1 -PropertyType DWORD -Force | Out-Null
