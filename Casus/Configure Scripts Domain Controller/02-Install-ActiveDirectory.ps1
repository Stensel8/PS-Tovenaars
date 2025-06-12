# Install Active Directory Domain Services runtime if needed
if ((Get-WindowsFeature -Name AD-Domain-Services).InstallState -ne "Installed") {
    Install-WindowsFeature -Name AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools
}

# Check if machine is already a domain controller
try {
    $isDomainController = $null -ne (Get-ADDomainController -Discover -ErrorAction Stop)
    if ($isDomainController) {
        Write-Host "This machine is already a domain controller. Domain promotion is not needed." -ForegroundColor Yellow
        exit 0
    }
} catch {
    # Not a domain controller, proceed with the script
}

# Get current computer name and offer to change it
$currentName = $env:COMPUTERNAME
$changeCompName = Read-Host -Prompt "Current computer name is '$currentName'. Do you want to change it? (Y/N, default is N)"

if ($changeCompName -eq "Y" -or $changeCompName -eq "y") {
    $newName = Read-Host -Prompt "Enter the new computer name"
    if (-not [string]::IsNullOrWhiteSpace($newName)) {
        try {
            Rename-Computer -NewName $newName -Force -ErrorAction Stop
            Write-Host "Computer name will be changed to '$newName' after restart." -ForegroundColor Green
        } catch {
            Write-Host "Failed to rename computer: $_" -ForegroundColor Red
        }
    }
}

# Set up domain controller and reboot

# Helper function to check whether a domain name is valid
function Assert-ValidDomainName {
    param ([String] $domainName)
    
    # Check length: minimum 2, maximum 253
    if (($domainName.Length -lt 2) -or ($domainName.Length -gt 253)) {
        return $false
    }
    
    # Basic DNS validation - simplified but more reliable
    # Must contain at least one dot, valid chars only
    if ($domainName -notmatch '^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?)+$') {
        return $false
    }
    
    # Check each label length (max 63 chars per label)
    $labels = $domainName.Split('.')
    foreach ($label in $labels) {
        if ($label.Length -gt 63 -or $label.Length -eq 0) {
            return $false
        }
    }
    
    return $true
}

# More secure password validation using NetworkCredential
function Assert-ValidPassword {
    param ([Security.SecureString] $testPassword)
    
    try {
        # Use NetworkCredential for temporary plaintext access
        $credential = New-Object System.Net.NetworkCredential("temp", $testPassword)
        $plainPassword = $credential.Password
        
        # Validate complexity: min 8 chars, digit, lowercase, uppercase, special char
        $hasDigit = $plainPassword -match '\d'
        $hasLower = $plainPassword -match '[a-z]'
        $hasUpper = $plainPassword -match '[A-Z]'
        $hasSpecial = $plainPassword -match '[\W_]'
        $isLongEnough = $plainPassword.Length -ge 8
        
        $result = $hasDigit -and $hasLower -and $hasUpper -and $hasSpecial -and $isLongEnough
        
        return $result
    }
    finally {
        # Explicit cleanup
        if ($credential) { 
            $credential = $null 
        }
        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
    }
}

# Get domain name
$defaultDomainName = "scripting.local"
do {
    $newDomainName = Read-Host -Prompt "Enter the name for the new domain (default is $defaultDomainName)"
    if ([string]::IsNullOrWhiteSpace($newDomainName)) { 
        $newDomainName = $defaultDomainName 
    }    
    $result = Assert-ValidDomainName -domainName $newDomainName
    if (!$result) {
        Write-Host "Invalid domain name. Use format like 'example.local' or 'company.internal'" -ForegroundColor Red
    }
} while (!$result) 

# Derive NetBIOS name from domain name
$NetBiosName = $newDomainName.Split('.')[0].ToUpper() -replace '[^A-Z0-9]', ''
if ($NetBiosName.Length -gt 15) {
    $NetBiosName = $NetBiosName.Substring(0, 15)
}

Write-Host "NetBIOS name will be: $NetBiosName" -ForegroundColor Green

# Get safe mode administrator password
do {
    $newPwd = Read-Host -Prompt "Enter a safe mode administrator password (min 8 chars, mixed case, digit, special char)" -AsSecureString
    
    # Check if password is empty
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPwd)
    try {
        $length = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr).Length
        if ($length -eq 0) {
            Write-Host "Password cannot be empty." -ForegroundColor Red
            $result = $false
            continue
        }
    } finally {
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    }
    
    $result = Assert-ValidPassword -testPassword $newPwd
    if (!$result) {
        Write-Host "Password does not meet complexity requirements:" -ForegroundColor Red
        Write-Host "- Minimum 8 characters" -ForegroundColor Yellow
        Write-Host "- At least one digit, lowercase, uppercase, and special character" -ForegroundColor Yellow
    }
} while (!$result)

Write-Host "Installing Active Directory Forest..." -ForegroundColor Green

# Determine the appropriate domain functional level based on Windows Server version
$osInfo = Get-WmiObject -Class Win32_OperatingSystem
$osVersion = $osInfo.Version
$osCaption = $osInfo.Caption

# Determine the best domain functional level based on OS version
$domainLevel = "Default" # Default will select the highest available level

# Can add specific version checks if needed for future Server versions
Write-Host "Detected OS: $osCaption" -ForegroundColor Green
Write-Host "Using domain functional level: $domainLevel" -ForegroundColor Green

try {
    # Use named parameters properly - remove the back-ticks for troubleshooting
    Install-ADDSForest `
        -DomainName $newDomainName `
        -DomainNetbiosName $NetBiosName `
        -DatabasePath "C:\Windows\NTDS" `
        -LogPath "C:\Windows\NTDS" `
        -SysvolPath "C:\Windows\SYSVOL" `
        -DomainMode $domainLevel `
        -ForestMode $domainLevel `
        -InstallDns:$true `
        -NoRebootOnCompletion:$false `
        -SafeModeAdministratorPassword $newPwd `
        -Force:$true
}
catch {
    Write-Host "Installation failed: $_" -ForegroundColor Red
    exit 1
}