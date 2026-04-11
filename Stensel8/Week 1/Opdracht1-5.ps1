# Brave opstarten met aangepaste argumenten

$bravePath = "C:\Users\stent\AppData\Local\BraveSoftware\Brave-Browser\Application\brave.exe"
$saxionURL = "https://www.saxion.nl"
$stenURL = "https://stentijhuis.nl"

Start-Process -FilePath $bravePath -ArgumentList $saxionURL, $stenURL

