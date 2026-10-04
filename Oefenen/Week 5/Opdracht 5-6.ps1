# Opdracht 5-6 : Een Azure resource aanmaken met behulp van PowerShell
# Moeilijkheid: 2/3
# Doe de lab "Een Azure-resource maken met behulp van scripts in Azure PowerShell" (Microsoft Learn):
# start de sandbox, maak een VM met New-AzVm en Get-Credential, zet de VM in $vm met Get-AzVM,
# vraag eigenschappen op met de dot-notatie en maak verbinding met SSH.
# Let op: een VM kost geld buiten de gratis sandbox. Gebruik hier alleen de sandbox van het lab.

# Het scherm leegmaken
Clear-Host

# 1. Zet hier de naam van de resource group van de sandbox (je krijgt die bij het starten van de lab)
$resourceGroup = "[sandbox resource group name]"
if ($resourceGroup -like "*sandbox resource group name*") {
    Write-Warning "Vul eerst de naam van de resource group van de sandbox in bij `$resourceGroup."
    exit
}

# 2. Installeer de Azure module (Az) als die er nog niet is
if (-not (Get-Module -ListAvailable -Name Az.Compute)) {
    Install-Module -Name Az -Repository PSGallery -Scope CurrentUser -Force
}
# Get-Module -ListAvailable -Name az*

# 3. Inloggen bij Azure en de juiste subscription kiezen
Connect-AzAccount
Get-AzSubscription
# Set-AzContext -Subscription "xxxx-xxxx-xxxx-xxxx"

# 4. Maak een VM met New-AzVm. De inloggegevens vraag je met Get-Credential: het wachtwoord staat dus nooit in het script.
# De parameters zet je eerst in een hashtable en geef je daarna met @ (splatting) mee.
$vmParams = @{
    ResourceGroupName = $resourceGroup
    Name              = "testvm-eus-01"
    Credential        = Get-Credential -Message "Kies een gebruikersnaam en wachtwoord voor de nieuwe VM"
    Location          = "eastus"
    Image             = "Ubuntu2204"
    OpenPorts         = 22
}
New-AzVm @vmParams

# 5. De VM in een object $vm zetten met Get-AzVM
$vm = Get-AzVM -ResourceGroupName $resourceGroup -Name "testvm-eus-01"

# 6. Eigenschappen opvragen met de dot-notatie
$vm.HardwareProfile
$vm.StorageProfile

# 7. Pipelining op $vm: welke VM-groottes kan deze VM hebben?
$vm | Get-AzVMSize

# 8. Het publieke ip-adres opvragen en daarmee verbinden met SSH (gebruikersnaam is die van stap 4)
$ip = Get-AzPublicIpAddress -ResourceGroupName $resourceGroup -Name "testvm-eus-01"
$ip.IpAddress
# ssh gebruikersnaam@<ip-adres>

# Extra (uit de workshop): alle VM's in je subscription starten, zodra ze gestopt zijn
# $vms = Get-AzVM -ResourceGroupName *
# foreach ($vm in $vms) {
#     Start-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name
#     Write-Host "Virtual machine $($vm.Name) is started"
# }
