# Opdracht 6-1 : Nieuw PowerShell object maken vanuit een bestaand object
# Moeilijkheid: 1/3
# Haal informatie over de huidige gebruiker op en geef die weer als een nieuw object met de properties
# gebruikersnaam, computernaam en het OS. Gebruik hiervoor New-Object en een hashtable.
# Computergegevens van het OS haal je op met Get-CimInstance en de class "Win32_OperatingSystem".

# Het scherm leegmaken
Clear-Host

# 1. Het OS opvragen met Get-CimInstance
$os = Get-CimInstance -ClassName Win32_OperatingSystem

# 2. Een nieuw object maken met New-Object. De properties geef je mee in een hashtable.
# [ordered] zorgt dat de properties in deze volgorde getoond worden.
$gebruikerObject = New-Object -TypeName PSObject -Property ([ordered]@{
        Besturingssysteem = $os.Caption
        Gebruikersnaam    = $env:USERNAME
        ComputerNaam      = $env:COMPUTERNAME
    })

# 3. Het object tonen
$gebruikerObject

# Dezelfde actie op de nieuwe manier (vanaf PowerShell 3.0) met [PSCustomObject]:
# $gebruikerObject = [PSCustomObject]@{
#     Besturingssysteem = $os.Caption
#     Gebruikersnaam    = $env:USERNAME
#     ComputerNaam      = $env:COMPUTERNAME
# }

# Een extra property toevoegen kan met Add-Member:
# $gebruikerObject | Add-Member -MemberType NoteProperty -Name "Klant" -Value "Saxion"
