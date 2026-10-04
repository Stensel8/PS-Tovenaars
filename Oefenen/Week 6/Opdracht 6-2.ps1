# Opdracht 6-2 : Nieuw PowerShell object maken met testresultaten van 3 testfuncties
# Moeilijkheid: 2/3
# Maak drie functies die gegevens over een systeem verzamelen, roep ze aan met de gegeven parameters en
# bewaar de resultaten in 3 properties van een nieuw object.

# Het scherm leegmaken
Clear-Host

# 1. Functie die checkt of een bestandspad bestaat
function Test-FilePath {
    param (
        [string]$Path
    )

    Test-Path -Path $Path
}

# 2. Functie die checkt of een proces draait. Get-Process verwacht de naam zonder ".exe".
function Test-ProcessRunning {
    param (
        [string]$ProcessName
    )

    $naam = [System.IO.Path]::GetFileNameWithoutExtension($ProcessName)
    [bool](Get-Process -Name $naam -ErrorAction SilentlyContinue)
}

# 3. Functie die in de registry opzoekt welke programma's zijn geinstalleerd (Get-ItemProperty).
# Alleen de items met een DisplayName zijn echte programma's.
function Get-InstalledProgram {
    param (
        [string]$RegistryPath
    )

    Get-ItemProperty -Path $RegistryPath |
        Where-Object { $_.DisplayName } |
        Select-Object -ExpandProperty DisplayName |
        Sort-Object
}

# 4. Roep de functies aan met de gevraagde parameters en bewaar de uitkomsten in een nieuw object
$testResultaten = New-Object -TypeName PSObject -Property ([ordered]@{
        PadBestaat               = Test-FilePath -Path "C:\Windows\System32\notepad.exe"
        ProcesDraait             = Test-ProcessRunning -ProcessName "explorer.exe"
        GeinstalleerdeProgrammas = Get-InstalledProgram -RegistryPath "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    })

# 5. Toon de resultaten van het nieuwe testresultaten object
$testResultaten | Format-List
