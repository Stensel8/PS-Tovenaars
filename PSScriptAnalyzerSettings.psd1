@{
    # Write-Host is in deze cursus bewust toegestaan. De opdrachten vragen er zelf om
    # (bijvoorbeeld "print de variabele met Write-Host" en gekleurde meldingen) en dit zijn interactieve scripts,
    # geen modules waarvan de uitvoer verder in een pipeline verwerkt wordt.
    # Alle andere regels (zoals Invoke-Expression, wachtwoorden in platte tekst en lege catch-blokken) blijven aan.
    ExcludeRules = @(
        'PSAvoidUsingWriteHost'
    )
}
