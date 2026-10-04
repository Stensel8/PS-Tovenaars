# Opdracht 6-4 : Check of bepaalde properties in een JSON bestand voorkomen
# Moeilijkheid: 2/3
# PropertyList.txt bevat een lijst met namen van objecteigenschappen. Het script:
#   - maakt hiervan een hashtable met als key de namen en als value telkens $false
#   - haalt met de code van opdracht 5-2 (RDW informatie op kenteken) een JSON object op
#   - zet per propertynaam in de hashtable de value op $true als de property in het JSON object voorkomt
#   - toont de inhoud van de hashtable

# Het scherm leegmaken
Clear-Host

# De lijst staat naast dit script
$scriptMap = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }

# 1. Lees het tekstbestand in en maak er een hashtable van: key = de naam, value = $false
$eigenschappen = @{}
foreach ($naam in (Get-Content -Path (Join-Path -Path $scriptMap -ChildPath "PropertyList.txt"))) {
    if ($naam.Trim() -ne "") {
        $eigenschappen[$naam.Trim()] = $false
    }
}

# 2. Haal een JSON object op bij de RDW (zoals in opdracht 5-2)
$kenteken = (Read-Host -Prompt "Voer kenteken in").ToUpper().Replace("-", "").Trim()
if ($kenteken -notmatch '^[A-Z0-9]{1,8}$') {
    Write-Warning "Dit is geen geldig kenteken."
    exit
}
$response = Invoke-WebRequest -Uri "https://opendata.rdw.nl/resource/m9d7-ebf2.json?kenteken=$kenteken" -Method Get
$voertuig = $response.Content | ConvertFrom-Json
if (-not $voertuig) {
    Write-Warning "Er is geen voertuig gevonden met kenteken $kenteken."
    exit
}

# 3. Bepaal voor elke propertynaam of deze in het JSON object voorkomt.
# De namen van de properties van het object staan in PSObject.Properties.Name.
# Let op: we lopen over een kopie van de keys, want je mag een hashtable niet wijzigen terwijl je over de keys loopt.
$aanwezig = $voertuig.PSObject.Properties.Name
foreach ($naam in @($eigenschappen.Keys)) {
    if ($naam -in $aanwezig) {
        $eigenschappen[$naam] = $true
    }
}

# 4. Toon de inhoud van de hashtable
$eigenschappen.GetEnumerator() | Sort-Object -Property Name | Format-Table -Property Name, Value -AutoSize

$aantalTrue = @($eigenschappen.Values | Where-Object { $_ }).Count
Write-Host "$aantalTrue van de $($eigenschappen.Count) properties komen voor in het JSON object van $kenteken."
