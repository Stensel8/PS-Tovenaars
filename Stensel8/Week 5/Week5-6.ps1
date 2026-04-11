install-moodule -name az -repository PSGallery -Force

Get-Module -listavailable -name az*

Connect-AzAccount

Get-azsubscription

Get-Help select-azsubscription -Online
set-azcontext -subscription "Subscription ID hier neerknallen"

Get-command -module az.compute

Get-azresource | Where-Object {$_.ResourceType -eq "Microsoft.Compute/virtualMachines"} | Select-Object Name, ResourceGroupName, Location

$vms = get-azvm

foreach ($vm in $vms) {
    $vm 
}

$VMLocalAdminSecurePassword = ConvertTo-SecureString -String "P@ssw0rd" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($VMLocalAdminSecurePassword)



$vmParams = @{
    Name = "TutorialVM"
    ResourceGroupName = "Powershell"
    Location = "westeurope"
    ImageName = "Win2019Datacenter"
    Size = "Standard_D2s_v3"
    Openports = @("3389")
    Credential = $credential
}

New-AzVM @vmParams
