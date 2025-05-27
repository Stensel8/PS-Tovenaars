# configure-VM.ps1
# Script to disable unnecessary services and features for Windows VMs

# Run as Administrator

$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Start het script opnieuw met administrator-rechten..." -ForegroundColor Yellow
    # Herstart PowerShell als admin, met dezelfde parameters
    Start-Process -FilePath "PowerShell" `
                  -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" `
                  -Verb RunAs
    Exit
}
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Disable Windows Update
Write-Host "Disabling Windows Update..."
Stop-Service wuauserv -Force
Set-Service wuauserv -StartupType Disabled

# Disable Windows Search
Write-Host "Disabling Windows Search..."
Stop-Service WSearch -Force
Set-Service WSearch -StartupType Disabled

# Disable Superfetch/SysMain
Write-Host "Disabling SysMain (Superfetch)..."
Stop-Service SysMain -Force
Set-Service SysMain -StartupType Disabled

# Disable Diagnostics Tracking
Write-Host "Disabling Diagnostics Tracking..."
Stop-Service DiagTrack -Force
Set-Service DiagTrack -StartupType Disabled

# Disable Windows Error Reporting
Write-Host "Disabling Windows Error Reporting..."
Stop-Service WerSvc -Force
Set-Service WerSvc -StartupType Disabled

# Disable OneDrive (if present)
Write-Host "Disabling OneDrive (if installed)..."
$onedrive = Get-Process OneDrive -ErrorAction SilentlyContinue
if ($onedrive) {
    Stop-Process -Name OneDrive -Force
    $onedrivePath = "$env:SystemRoot\System32\OneDriveSetup.exe"
    if (Test-Path $onedrivePath) {
        Start-Process $onedrivePath "/uninstall" -NoNewWindow -Wait
    }
}

# Set power plan to high performance
Write-Host "Setting power plan to High Performance..."
powercfg -setactive SCHEME_MIN

# Disable hibernation
Write-Host "Disabling hibernation..."
powercfg -h off

# Disable Fast Startup
Write-Host "Disabling Fast Startup..."
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
Set-ItemProperty -Path $regPath -Name HiberbootEnabled -Value 0

Write-Host "VM optimization is done!." -ForegroundColor Green