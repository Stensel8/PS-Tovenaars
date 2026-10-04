# Opdracht 2-0 : Tekst naar een bestand schrijven met Out-File (voorbeeld uit de uitwerkingen van week 2)
# Moeilijkheid: 1/3

# Het scherm leegmaken
Clear-Host

# 1. Definieer het pad naar het bestand (in de map voor tijdelijke bestanden)
$bestandPad = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "mijnBestand.txt"

# 2. Schrijf een regel naar het bestand
"Deze tekst wordt naar het bestand geschreven." | Out-File -FilePath $bestandPad

Write-Host "Bestand is aangemaakt op $bestandPad."
