# Opdracht 1-2 : Vraag via de helpfunctie van Powershell hoe je een overzicht van services kunt tonen. En controleer of de service "VMware NAT Service" draait.
# Moeilijkheid: 1/3

# Het scherm leegmaken
Clear-Host

# 1. Zoeken naar cmdlets die iets met services doen
Get-Help service
# Get-Command *-service

# 2. De cmdlet die we zoeken is Get-Service. Vraag de code-voorbeelden op.
Get-Help -Name Get-Service -Examples

# 3. Draait de service "VMware NAT Service"?
# We gaan ervan uit dat VMware Workstation geinstalleerd is, maar vangen af dat de service er niet is.
$service = Get-Service -Name 'VMware NAT Service' -ErrorAction SilentlyContinue

if ($service) {
    Write-Host "De service '$($service.DisplayName)' heeft de status: $($service.Status)"
}
else {
    Write-Host "De service 'VMware NAT Service' bestaat niet op deze computer." -ForegroundColor Yellow
}

# 4. Zijn er meerdere VMware services? Gebruik de wildcard *
Get-Service -Name vm*
Get-Service -DisplayName vm*
