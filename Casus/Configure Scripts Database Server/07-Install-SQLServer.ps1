# Make sure Write-Information writes to the screen
$InformationPreference="Continue"
# Helper functions to check complexity rules for SA password
# Function to validate password complexity
function Assert-ValidPassword {
    param (
        [string]$password
    )

    # Define password complexity rules
    $minimumLength = 8
    $requiresLowercase = $true
    $requiresUppercase = $true
    $requiresDigit = $true
    $requiresSpecialChar = $true
    $specialChars = '!@#$%^&*()-_=+[]{}|;:,.<>?'

    # Check password length
    if ($password.Length -lt $minimumLength) {
        Write-Information "Password must be at least $minimumLength characters long." -ForegroundColor Red
        return $false
    }

    # Check lowercase requirement
    if ($requiresLowercase -and !($password -cmatch "[a-z]")) {
        Write-Information "Password must contain at least one lowercase letter." -ForegroundColor Red
        return $false
    }

    # Check uppercase requirement
    if ($requiresUppercase -and !($password -cmatch "[A-Z]")) {
        Write-Information "Password must contain at least one uppercase letter." -ForegroundColor Red
        return $false
    }

    # Check digit requirement
    if ($requiresDigit -and !($password -cmatch "\d")) {
        Write-Information "Password must contain at least one digit." -ForegroundColor Red
        return $false
    }

    # Check special character requirement
    if ($requiresSpecialChar -and !($password -cmatch "[$specialChars]")) {
        Write-Information "Password must contain at least one special character ($specialChars)." -ForegroundColor Red
        return $false
    }

    return $true
}

# Function to prompt for a password
function Get-Password {
    param (
        [string]$prompt,
        [string]$defaultPwd = ''
    )
    do {
        Write-Host $promt -ForegroundColor Cyan
        $password = Read-Host -MaskInput
        if (($password.Length -eq 0) -and ($defaultPwd.Length -gt 0)) {
            $password = $defaultPwd
        }
    } while (-not (Assert-ValidPassword -password $password))
    
    return $password
}

# Function to confirm the password
function Confirm-Password {
    $confirmedPassword = $null
    do {
        Write-Host "Confirm your password:" -ForegroundColor Cyan
        $confirmedPassword = Read-Host -MaskInput

        if ($password -ne $confirmedPassword) {
            Write-Host "Passwords do not match. Please try again." -ForegroundColor Red
        }
    } while ($password -ne $confirmedPassword)
}



# Verify if computer is a domain member

if($env:COMPUTERNAME -eq $env:USERDOMAIN) {
    Write-Information "You are not logged on as a domain admin. Please log out, log on as a domain admin, then run the script again"
    Write-Information "Now exiting script."
    exit 1
}

#region Check for running as admin
# Verify Running as Admin. Needed to change system properties, install powershell7 and so on.

$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
If (-not $isAdmin) {
    Write-Host "-- Restarting as Administrator" -ForegroundColor Cyan ; Start-Sleep -Seconds 1

    if($PSVersionTable.PSEdition -eq "Core") {
        Start-Process pwsh.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs 
    } else {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs 
    }

    exit
}
#endregion

# Get a password for the SQL SysAdmin account
$defaultPwd = 'P@ssw0rd'
$password = Get-Password -prompt "Enter a password for the SQL sa account (must meet standard complexity requirement). Default is $defaultPwd : " -defaultPwd $defaultPwd
Confirm-Password

#Download SQL Server ISO
$SQLServerDownloadURI = "https://download.microsoft.com/download/3/8/d/38de7036-2433-4207-8eae-06e247e17b25/SQLServer2022-x64-ENU-Dev.iso"

$MediaDirectory = "C:\Media"
# Check whether download directory exists. If not, create it
if(-not (Test-Path $MediaDirectory)) {
    New-Item -ItemType Directory -Path $MediaDirectory |Out-Null
}
$ISOFile = $MediaDirectory + "\SQLServer2022-x64-ENU-Dev.iso"

Invoke-WebRequest -Uri $SQLServerDownloadURI -OutFile $ISOFile -UseBasicParsing

# Mount downloaded ISO file as CD/DVD
$volume = Mount-DiskImage -ImagePath $ISOFile -PassThru | Get-Volume
$setupPath = $volume.DriveLetter + ':\setup.exe'

$instancename = "MSSQLSERVER"
$features = @('SQLEngine')      # only install SQL Server database engine, no extras

# Build the command parameter list. The technique is called "splatting"
$cmd = @(
    "$setupPath "   # Path to setup command
    '/QUIET'                            # Silent install
    '/INDICATEPROGRESS'                 # Show progress on command line
    '/IACCEPTSQLSERVERLICENSETERMS'     # Must be included in unattended installs
    '/ACTION=Install'                   # Install
    '/UPDATEENABLED=true'               # Discover and include updates during install
    "/FEATURES="+($features -join ',')  # Features to install
    "/INSTANCENAME=$instancename"
    "/SAPWD=$password"
    "/SECURITYMODE=SQL"                 # You can log in as an SQL system administrator using a Windows administrator account, or as the SQL account sa
    
)

Invoke-Expression "$cmd"
if ($LastExitCode) {
    if ($LastExitCode -ne 3010) { throw "SqlServer installation failed, exit code: $LastExitCode" }
    Write-Warning "SYSTEM REBOOT IS REQUIRED"
}

# Unmount disk image.

Dismount-DiskImage -ImagePath $ISOFile
# You can delete the downloaded ISO image, if you want.
# Code not supplied.

# SQL Server Management Studio installation
# Download SQL Server Management Studio
$SSMSInstallerPath = "C:\temp\SSMS-setup-ENU.exe"
Invoke-WebRequest -Uri "https://aka.ms/ssmsfullsetup" -OutFile $SSMSInstallerPath
$argumentList = "/install /quiet /norestart"
Start-Process -FilePath $SSMSInstallerPath -ArgumentList $argumentList -Wait
Write-Host "Installation complete"
#
# Open up the firewall for SQL commands
# Define the rule name
$ruleName = "SQL Server 2022"

# Define the port number for SQL Server
$portNumber = 1433  # Change this if SQL Server is configured on a different port

# Create a new firewall rule for SQL Server
New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -LocalPort $portNumber -Protocol TCP -Action Allow -Profile Domain,Private

# Open up the firewall for SQL Server Browser
# Define the rule name
$ruleName = "SQL Server Browser"

# Define the port number for SQL Server Browser
$portNumber = 1434

# Create a new firewall rule for SQL Server Browser
New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -LocalPort $portNumber -Protocol UDP -Action Allow -Profile Domain,Private

