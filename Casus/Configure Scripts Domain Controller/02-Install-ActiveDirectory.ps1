
# Install Active Directory Domain Services runtime if needed
if ((Get-WindowsFeature -Name AD-Domain-Services).InstallState -ne "Installed") {
    Install-WindowsFeature -Name AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools
}

# Set up domain controller and reboot

# Helper function to check whether a domain name is valid. Used when asking for a new domain name
function Assert-ValidDomainName {
    param (
        [String] $domainName
    )

    # Check length: minimum 2, maximum 253
    . {$valid = ($domainName.Length -ge 2) -and ($computerName.Length -le 253)
    # check for invalid characters using regular expressions. 
    # Valid characters are: first and last character alphanumeric, characters in between alphanumeric or '-'
    # then a dot, then more alphanumeric characters.
    $valid = $valid -and ($domainName -match "(?=.{1,253}\.?$)(?:(?!-|[^.]+_)[A-Za-z0-9-_]{1,63}(?<!-)(?:\.|$)){2,}") 
    } | Out-Null
    return $valid
}

function Assert-ValidPassword {
    param (
        [String] $testPassword
    )
    # Check using regex
    # At least one digit, one lowercase letter, one capital letter, and one special character. Minimum length 8 characters, no maximum
    return ($testPassword -match '((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W).{8,})')
}


$defaultDomainName = "scripting.local"
do {
    $newDomainName = Read-Host -Prompt "Enter the name for the new domain (default is $defaultDomainName)"
    if ($newDomainName -eq '') { $newDomainName=$defaultDomainName }    
    $result = Assert-ValidDomainName -domainName $newDomainName
    if (!$result) {
        Write-Host "Invalid domain name"
    }
}
while (!$result) 

# derive NetBIOS name from domain name
# take the first part of the domain name
$NetBiosName = $newDomainName.Split('.')[0].ToUpper()
# remove dashes (those are valid in DNS domain names, but not in NetBIOS names) 
$NetBiosName = $NetBiosName.Replace('-','')
# and trim to a maximum length of 14 characters
$NetBiosName = $NetBiosName.Substring(0,[System.Math]::Min(14,$NetBiosName.Length))

$defaultPwd = "P@ssw0rd"
do {
    $newPwd = Read-Host -Prompt "Enter a safe mode administrator password (default is $defaultPwd)"
    if ($newPwd -eq '') {
        $newPwd = $defaultPwd
    }
    $result = Assert-ValidPassword -testPassword $newPwd
    if (!$result) {
        Write-Host "Password does not meet complexity rules"
    }
}
while (!$result)

$password=ConvertTo-SecureString $newPwd -AsPlainText -Force

Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode WinThreshold `
-DomainName $newDomainName `
-DomainNetbiosName $NetBiosName `
-InstallDns:$true `
-NoRebootOnCompletion:$false `
-LogPath "C:\Windows\NTDS" `
-SysvolPath "C:\Windows\SYSVOL" `
-SafeModeAdministratorPassword $password `
-Force:$true

