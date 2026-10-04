# Opdracht 4-3 : JSON en XML bestanden
# Moeilijkheid: 2/3
# Deel 1: lees employees.json (van school) en toon de gegevens gestructureerd op het scherm.
# Deel 2: pas script en JSON aan voor studenten (students.json) met voornaam, achternaam en studentnummer,
#         en tel het aantal studenten.
# Extra : converteer het JSON bestand naar XML.

# Het scherm leegmaken
Clear-Host

# De JSON bestanden staan naast dit script
$scriptMap = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }

# ---------------------------------------------------------------
# Deel 1 : Employees
# ---------------------------------------------------------------
# 1. Lees het bestand in als 1 tekst (-Raw) en maak er met ConvertFrom-Json een PowerShell object van
$jsonString = Get-Content -Raw -Path (Join-Path -Path $scriptMap -ChildPath "employees.json")
$jsonObject = ConvertFrom-Json -InputObject $jsonString

# 2. Doorloop elke employee en toon de details met de dot-notatie
foreach ($employee in $jsonObject) {
    $employeeDetails = $employee.employee
    Write-Host "Employee Details:"
    Write-Host "First Name: $($employeeDetails.firstName)"
    Write-Host "Last Name: $($employeeDetails.lastName)"
    Write-Host "Website: $($employeeDetails.website)"
    Write-Host
}

# ---------------------------------------------------------------
# Deel 2 : Studenten
# ---------------------------------------------------------------
$studenten = ConvertFrom-Json -InputObject (Get-Content -Raw -Path (Join-Path -Path $scriptMap -ChildPath "students.json"))

foreach ($student in $studenten) {
    $studentDetails = $student.student
    Write-Host "Student Details:"
    Write-Host "First Name: $($studentDetails.firstName)"
    Write-Host "Last Name: $($studentDetails.lastName)"
    Write-Host "studentnr.: $($studentDetails.studentnummer)"
    Write-Host
}

# Tel het aantal studenten
Write-Host "Aantal studenten: $(@($studenten).Count)"

# ---------------------------------------------------------------
# Extra : JSON naar XML
# ---------------------------------------------------------------
# ConvertTo-Xml maakt van een PowerShell object een XML document
$xmlPad = Join-Path -Path $scriptMap -ChildPath "students.xml"
$studenten | ForEach-Object { $_.student } | ConvertTo-Xml -As String -NoTypeInformation | Out-File -FilePath $xmlPad -Encoding utf8

Write-Host
Write-Host "Het XML bestand is aangemaakt: $xmlPad"
Get-Content -Path $xmlPad
