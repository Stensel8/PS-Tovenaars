#Requires -RunAsAdministrator

Clear-Host

# Exit if already a domain controller
try {
    if (Get-ADDomainController -Discover -ErrorAction Stop) {
        Write-Host "Already a domain controller. Exiting." -ForegroundColor Yellow
        exit 0
    }
} catch {}

# Install AD-Domain-Services if needed
$adFeature = Get-WindowsFeature AD-Domain-Services
if ($adFeature.InstallState -ne "Installed") {
    Install-WindowsFeature AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools
}

# Computer rename (suppress reboot)
$currentName = $env:COMPUTERNAME
if ((Read-Host "Rename computer from '$currentName'? (Y/N)") -eq 'Y') {
    $newName = Read-Host "New computer name"
    if ($newName) {
        Rename-Computer -NewName $newName -Force
        Write-Host "Computer renamed to '$newName'" -ForegroundColor Green
    }
}

# Domain configuration
function Test-DomainName {
    param([string]$name)
    
    # Basic validation: 2-253 chars, contains dot, valid DNS format
    $name -match '^(?=.{2,253}$)[a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)+$' -and
    ($name.Split('.') | ForEach-Object { $_.Length -le 63 })
}

function Test-Password {
    param([SecureString]$password)
    
    $cred = [System.Net.NetworkCredential]::new("", $password)
    $plain = $cred.Password
    
    $plain.Length -ge 8 -and 
    $plain -match '\d' -and 
    $plain -match '[a-z]' -and 
    $plain -match '[A-Z]' -and 
    $plain -match '[\W_]'
}

# Get domain name
do {
    $domain = Read-Host "Domain name (default: scripting.local)"
    if (!$domain) { $domain = "scripting.local" }
    $valid = Test-DomainName $domain
    if (!$valid) { Write-Host "Invalid format. Use 'example.local'" -ForegroundColor Red }
} while (!$valid)

# NetBIOS name from domain
$netbios = ($domain.Split('.')[0] -replace '\W').ToUpper()
if ($netbios.Length -gt 15) { $netbios = $netbios.Substring(0, 15) }
Write-Host "NetBIOS: $netbios" -ForegroundColor Green

# Get DSRM password
do {
    $safePwd = Read-Host "DSRM password (8+ chars, mixed case, digit, special)" -AsSecureString
    $valid = Test-Password $safePwd
    if (!$valid) { Write-Host "Doesn't meet complexity requirements" -ForegroundColor Red }
} while (!$valid)

# Install AD Forest
Write-Host "Installing AD Forest..." -ForegroundColor Green
try {
    Install-ADDSForest `
        -DomainName $domain `
        -DomainNetbiosName $netbios `
        -DatabasePath "C:\Windows\NTDS" `
        -LogPath "C:\Windows\NTDS" `
        -SysvolPath "C:\Windows\SYSVOL" `
        -DomainMode Default `
        -ForestMode Default `
        -InstallDns `
        -SafeModeAdministratorPassword $safePwd `
        -Force `
        -NoRebootOnCompletion:$false
} catch {
    Write-Host "Installation failed: $_" -ForegroundColor Red
    exit 1
}
