# WinRM configuration script
# Run as Administrator

# --- Step 1: Check Network Profiles and Warn for Public Networks ---
$profiles = Get-NetConnectionProfile
$publicProfiles = $profiles | Where-Object { $_.NetworkCategory -eq "Public" }

if ($publicProfiles) {
    Write-Warning "One or more network connections are set to Public. For WinRM to work properly, consider changing them to Private or Domain."
    # Optionally, you can set them to Private automatically:
    # foreach ($profile in $publicProfiles) {
    #     Set-NetConnectionProfile -InterfaceAlias $profile.InterfaceAlias -NetworkCategory Private
    # }
}

# --- Step 2: Enable PowerShell Remoting and WinRM ---
Write-Output "Enabling PowerShell Remoting..."
# The -SkipNetworkProfileCheck parameter prevents errors on public networks.
Enable-PSRemoting -Force -SkipNetworkProfileCheck

Write-Output "Listing existing WinRM listeners..."
winrm enumerate winrm/config/listener

# --- Step 3: Create an HTTP Listener on Port 5985 if Not Already Present ---
$existingListener = winrm enumerate winrm/config/listener | Select-String -Pattern "Transport = HTTP"
if (-not $existingListener) {
    Write-Output "Creating WinRM HTTP listener on port 5985..."
    # Using the literal syntax to pass the format string correctly:
    winrm create winrm/config/Listener?Address=*+Transport=HTTP @{Port="5985"}
} else {
    Write-Output "A WinRM HTTP listener is already configured."
}

# --- Step 4: Create Firewall Rule for WinRM HTTP (Port 5985) ---
Write-Output "Adding firewall rule for WinRM HTTP on port 5985..."
# Using New-NetFirewallRule for a more robust rule creation:
New-NetFirewallRule -DisplayName "WinRM HTTP" -Profile Any -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5985 -ErrorAction SilentlyContinue

Write-Output "WinRM configuration complete."
