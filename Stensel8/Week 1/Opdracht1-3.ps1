 ## Opdracht 1-3 : Vraag via de helpfunctie van Powershell hoe je een overzicht van scheduled tasks kunt tonen en tel het aantal.

#
# Clear-Host

# 1. Opzoek naar de naam van de cmdlet die scheduled tasks kan tonen
Get-Help Scheduled
# Get-Command get-scheduled*

# Na het testen, bleken er de volgende cmdlets te zijn:
# Get-ScheduledTask
# Get-ScheduledTaskInfo
# Get-ScheduledJob
# Get-ScheduledJobOption


#2. Als je de naam van het cmdlet wel weet, vraag je de code-voorbeelden op met Get-Help en parameter -examples.
