# Opdracht 4-7 : Hardware gegevens verzamelen via het Common Information Model (CIM)
# Moeilijkheid: 1/3
# Extra opdracht uit de uitwerkingen van week 4. Het BIOS serienummer heb je ook nodig bij de proeftoets (opgave 2c).

# Het scherm leegmaken
Clear-Host

# 1. Basisinformatie over je eigen machine via CIM.
# Get-WmiObject werkt alleen in PowerShell 5, Get-CimInstance werkt ook in PowerShell 7.
Get-CimInstance -ClassName Win32_BIOS

# 2. Nu alleen het serienummer (check eerst met Get-Member welke properties er zijn)
# Get-CimInstance -ClassName Win32_BIOS | Get-Member
Get-CimInstance -ClassName Win32_BIOS | Select-Object -Property SerialNumber

# Alleen de waarde, zonder kolomkop:
(Get-CimInstance -ClassName Win32_BIOS).SerialNumber

# Dezelfde cmdlet werkt ook remote op meerdere machines (met een CIM session):
# Get-CimInstance -ClassName Win32_BIOS -ComputerName "192.168.10.11" -Credential (Get-Credential)
