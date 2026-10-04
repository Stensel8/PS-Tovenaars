# Opdracht 1-1 : Vraag via de helpfunctie van Powershell hoe je een overzicht van processen kunt tonen en vraag voorbeelden op.
# Moeilijkheid: 1/3

# Het scherm leegmaken
Clear-Host

# 1. Zoeken naar cmdlets met "process" in de naam. Dit geeft een lijst met mogelijke cmdlets.
Get-Help process
# Get-Help *-process
# Get-Command *-process

# 2. De cmdlet die we zoeken is Get-Process. Vraag de help-pagina op (-Name is de default parameter, dus je mag hem weglaten).
Get-Help -Name Get-Process

# 3. Alleen de code-voorbeelden opvragen
Get-Help -Name Get-Process -Examples

# 4. Experimenteren met andere parameters
# (uitgecommentarieerd, want -ShowWindow en -Online openen een venster / de browser)
# Get-Help -Name Get-Process -Full
# Get-Help -Name Get-Process -ShowWindow
# Get-Help -Name Get-Process -Online
