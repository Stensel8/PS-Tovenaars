# Oefenen: Scripting met PowerShell, week 1 t/m 8

Uitwerkingen van alle opdrachten van de module *1.4 Scripting met PowerShell*
([opdrachten op saxionact.github.io](https://saxionact.github.io/1.4-Scripting-met-Powershell/)).
Week 1 t/m 7 zijn de weekopdrachten, week 8 is de proeftoets.

De scripts zijn samengesteld uit de officiële uitwerkingen, de slides en het werk van alle studenten in deze repo
(`Oefenen/` en `Stensel8/`). Fouten uit die bronnen zijn eruit gehaald, de originele versies staan nog in de git-historie.

## Zo werk je ermee

* Gebruik **PowerShell 7.4 of hoger** (`pwsh`) op Windows. `Test-Connection -TargetName` bestaat niet in PowerShell 5.1.
* Start een script vanuit de map van de week, de hulpbestanden (json, txt, sql) staan naast de scripts.
* Een paar scripts hebben meer nodig dan een gewone laptop:

| Nodig | Opdrachten |
| --- | --- |
| Administrator | 3-2, 3-3 (deels), 4-4, 4-5, 4-6 |
| VMware VM's met WinRM aan (`Stensel8/Week 4/Enable-WinRM.ps1`) | 4-4, 4-6 |
| Domain controller van de casus | 3-6 |
| SQL Server (Developer Edition) | 5-5, 5-7, T4 |
| Azure subscription of sandbox | 5-6, T4 |
| Alle casus-VM's aan | 5-7 |

## Afspraken (onze stijl)

* Nederlandse comments, bovenaan `# Opdracht W-N : <titel>` en een moeilijkheid, daarna `Clear-Host`.
* De stappen zijn genummerd en volgen de opdrachttekst, zodat je de opdracht naast het script kunt lezen.
* Geen wachtwoorden in een script: gebruik `Get-Credential`, `Read-Host -AsSecureString` of `Export-Clixml`.
* Scripts die iets op je computer veranderen (registry, installeren, execution policy) vragen eerst om bevestiging
  of zetten de oude waarde terug.
* In de scripts van `Oefenen/` staan alleen ASCII-tekens (dus "geimporteerd" in plaats van met trema), zodat
  PowerShell 5.1 en 7 ze zonder BOM hetzelfde lezen. De bestanden zelf zijn UTF-8 en zonder trailing whitespace
  (zie `.editorconfig`). In oudere bestanden, zoals die in `Stensel8/`, kunnen wel andere tekens staan.

## Week 1: Verkennen PowerShell

| Opdracht | Onderwerp | Let op |
| --- | --- | --- |
| 1-1 | Get-Help, processen | |
| 1-2 | Services, VMware NAT Service | werkt ook zonder VMware (melding) |
| 1-3 | Scheduled tasks tellen | |
| 1-4 | IP-adres vragen met Read-Host | |
| 1-5 | Applicatie starten met argumenten | pas `$filePath` aan voor jouw browser |
| 1-6 | Ping-lijst met foreach | `Test-Connection` is het alternatief voor ping |
| 1-7 | Hostnames in een lijst, while-lus | dot sourcing |
| 1-8 | Password checker | `-MaskInput`, pogingen tellen |
| 1-9 | Functie Ping-Address | foutafhandeling bij een onbekende host |
| 1-10 | Hoger-Lager | `Test-Number` met `[OutputType([bool])]` |

## Week 2: Commandlets en objecten

| Opdracht | Onderwerp | Let op |
| --- | --- | --- |
| 2-0 | Out-File (voorbeeld uit de uitwerkingen) | extra |
| 2-1 | Processen in een variabele | |
| 2-2 | Services, Select-Object en Sort-Object | |
| 2-3 | Meeste geheugen naar HTML | schrijft `Processes.html` naast het script |
| 2-4 | Objecten in een map tellen | map als parameter |
| 2-5 | Temp-folder tellen | het verwijderen gaat met `-WhatIf` |
| 2-6 | .txt files sorteren op grootte | |
| 2-7 | WhatIf en Confirm | antwoord N bij Confirm |
| 2-8 | Microsoft processen stoppen met Kill | eerst `-WhatIf`, dan bevestigen |
| 2-9 | Hosts-file filteren | `Out-GridView` |
| 2-10 | Alias `fire` voor de firewall | |

## Week 3: Modules en robuuste scripts

| Opdracht | Onderwerp | Let op |
| --- | --- | --- |
| 3-1 | mp4-bestanden zoeken (PSDrive) | gebruikt je D-schijf, anders je map Video's |
| 3-2 | Registry (Windows Update beleid) | administrator, vraagt eerst bevestiging |
| 3-3 | Firewall regels (NetSecurity) | administrator voor sommige commando's |
| 3-4 | Try-catch met typed exceptions | `FileNotFoundException` en eigen `InvalidDataException` |
| 3-5 | Verbindingen op poort 443 met proces | |
| 3-6 | Domeincomputers uit Active Directory | op de domain controller |

## Week 4: Beheertoepassingen schrijven

| Opdracht | Onderwerp | Let op |
| --- | --- | --- |
| 4-1 | Grote en oude bestanden zoeken | duurt even op een hele C: schijf |
| 4-2 | Logfile scannen | downloadt `Apache_2k.log` als hij ontbreekt |
| 4-3 | JSON en XML | `employees.json`, `students.json`, schrijft `students.xml` |
| 4-4 | Remote PowerShell op meerdere VM's | administrator, `cred.xml` bevat versleutelde credentials |
| 4-5 | Execution policy | administrator, zet de policy na afloop terug |
| 4-6 | Script remote uitvoeren | `vms.txt` en `services.ps1` van school |
| 4-7 | BIOS serienummer via CIM | extra, hoort bij de proeftoets |

## Week 5: Koppeling naar externe systemen

Opdracht 5-4 is vervallen.

| Opdracht | Onderwerp | Let op |
| --- | --- | --- |
| 5-1 | Installatiebestand ophalen en uitvoeren | installeert echt Chrome, vraagt eerst om bevestiging |
| 5-2 | RDW API met Invoke-WebRequest | probeer kenteken `00-BZB-8` |
| 5-3 | Petstore REST API | de demo-data kan verdwijnen |
| 5-5 | Lokale SQL Server database | `CreateDatabase.sql` |
| 5-6 | Azure VM aanmaken | vul de sandbox resource group in |
| 5-7 | Remote SQL Servers registreren | `computers.txt` met de casus-VM's |

## Week 6: PowerShell uitbreiden met objecten en commandlets

| Opdracht | Onderwerp | Let op |
| --- | --- | --- |
| 6-1 | Object maken met New-Object | |
| 6-2 | Object met testresultaten van 3 functies | |
| 6-3 | Dobbelsteen als commandlet (CmdletBinding) | |
| 6-4 | Properties in een JSON object checken | `PropertyList.txt`, RDW API |

## Week 7: PowerShell uitbreiden met modules

| Opdracht | Onderwerp | Let op |
| --- | --- | --- |
| 7-1 | Eigen module maken | module `PSTovenaars` in de map `PSTovenaars`, het script installeert hem in je gebruikersmodulemap |
| 7-2 | Parameter validatie | `ValidateRange` en `ValidateSet`, ook in de module (versie 1.1.0) |

## Week 8: Proeftoets

De proeftoets van 16-06-2025 met uitwerking: `T1.ps1` t/m `T5.ps1`, de module `StudentXYZ` (opgave 5d) en de
databestanden `Klantmachines.json` en `SystemUpdate.log`.

* Vul in `T1.ps1` en `T4.ps1` je eigen naam en studentnummer in (nu placeholders).
* Hernoem bij opgave 5d `StudentXYZ` naar `Student<jouw studentnummer>`.
* De server `powershell-scripting.westeurope.cloudapp.azure.com` bestaat alleen in de toetsomgeving.
* Let op: `[ValidateLength(3, -1)]` uit de officiële uitwerking geeft in PowerShell 7 een fout. We gebruiken `[int]::MaxValue`.

### Beoordeling (rubrics)

| Onderdeel | Gewicht | Weken |
| --- | --- | --- |
| Basiselementen I (loops, I/O, variabelen, condities, functies) | 15% | 1 |
| Basiselementen II (commandlets, pipelining) | 10% | 2 |
| Modules en robuuste scripts | 15% | 3 |
| Beheerscripts (files, remote beheer) | 15% | 4 |
| Externe systemen (web, cloud, databases) | 15% | 5 |
| PowerShell uitbreidingen I (eigen commandlet en module) | 20% | 6 en 7 |
| PowerShell uitbreidingen II (eigen objecten, parameter validatie) | 10% | 6 en 7 |

Cijfer = (aantal punten x 0,09) + 1.

