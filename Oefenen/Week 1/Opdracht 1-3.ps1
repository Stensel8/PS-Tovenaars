# Opdracht 1-3 : Vraag via de helpfunctie van Powershell hoe je een overzicht van scheduled tasks kunt tonen en tel het aantal.
# Moeilijkheid: 2/3
# (PowerUp) : Bekijk de scheduled task voor Windows Update (TaskName, Actions en Triggers)

# Het scherm leegmaken
Clear-Host

# 1. Zoeken naar de naam van de cmdlet die scheduled tasks kan tonen
Get-Help scheduled
# Get-Help *task
# Get-Command get-scheduled*

# Na het testen bleek de cmdlet die we zoeken Get-ScheduledTask te zijn.

# 2. De code-voorbeelden opvragen
Get-Help -Name Get-ScheduledTask -Examples

# 3. Het aantal scheduled tasks tellen: haakjes om de cmdlet en daarachter .Count
# Het cmdlet levert een lijst op, die je kunt tellen.
$aantal = (Get-ScheduledTask).Count
Write-Host "Het aantal scheduled tasks is: $aantal"

# 4. (PowerUp) De scheduled task van Windows Update opvragen en in een variabele zetten
$task = Get-ScheduledTask -TaskPath "\Microsoft\Windows\WindowsUpdate\"

# 5. (PowerUp) Wanneer vindt de update plaats en welk commando wordt uitgevoerd?
$task.TaskName
$task.Triggers
$task.Actions | Select-Object -Property Execute, Arguments
