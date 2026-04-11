

# 1) Vraag om domein
$domain = Read-Host "Voer domein in (zonder https://)"
$uri    = "https://$domain"

# 2) Functie om één HTTP-versie te testen
function Test-HttpVersion {
    param([string]$version)
    try {
        # Sla het resultaat op in een variabele
        $response = Invoke-WebRequest -Uri $uri -Method Head -HttpVersion $version -TimeoutSec 10
        Write-Host "HTTP/${version}: Ondersteund" -ForegroundColor Green
        
        # Controleer Alt-Svc header voor HTTP/3 indicatie
        if ($response.Headers.ContainsKey("Alt-Svc")) {
            $altSvc = $response.Headers["Alt-Svc"]
            if ($altSvc -match "h3=") {
                Write-Host "  HTTP/${version}: HTTP/3 ondersteund via Alt-Svc ($altSvc)" -ForegroundColor Green
            } else {
                Write-Host "  HTTP/${version}: Alt-Svc aanwezig maar geen HTTP/3 indicator: $altSvc" -ForegroundColor Yellow
            }
        } else {
            Write-Host "  HTTP/${version}: HTTP/3 niet ondersteund (geen Alt-Svc header)" -ForegroundColor Yellow
        }
        
        # Toon Server header
        if ($response.Headers.ContainsKey('Server')) {
            Write-Host "  Server: $($response.Headers['Server'])" -ForegroundColor Cyan
        }
        
        # Toon extra nuttige headers
        $headersToShow = @('X-Powered-By', 'Via', 'X-Version')
        foreach ($header in $headersToShow) {
            if ($response.Headers.ContainsKey($header)) {
                Write-Host "  ${header}: $($response.Headers[$header])" -ForegroundColor Cyan
            }
        }
        
    } catch {
        Write-Host "HTTP/${version}: Niet ondersteund of fout" -ForegroundColor Red
        Write-Host "  Reden: $($_.Exception.Message)" -ForegroundColor Yellow
        
        # Meer gedetailleerde foutinformatie
        if ($_.Exception.Response) {
            Write-Host "  Status: $($_.Exception.Response.StatusCode.value__) - $($_.Exception.Response.StatusDescription)" -ForegroundColor Yellow
        }
    }
}

# 3) Test HTTP/1.0, 1.1 en 2.0
foreach ($v in @("1.0","1.1","2.0")) {
    Test-HttpVersion -version $v
}

# 4) Verbeterde HTTP/3 test via curl
Write-Host "`nTesting HTTP/3 capabilities:" -ForegroundColor Cyan
if (Get-Command curl.exe -ErrorAction SilentlyContinue) {
    Write-Host "Uitvoeren van: curl.exe --http3 -I $uri" -ForegroundColor Gray
    
    # Gebruik --verbose voor meer diagnostische info
    $output = curl.exe --http3 --verbose -I $uri 2>&1
    
    # Controleer op HTTP/3 in de output
    if ($output -match 'using HTTP/3') {
        Write-Host "HTTP/3: Succesvol ondersteund en gebruikt" -ForegroundColor Green
        # Toon de HTTP/3 respons header
        $httpHeader = ($output | Where-Object { $_ -match '^HTTP/3' }) -join ', '
        Write-Host "  Response: $httpHeader" -ForegroundColor Green
    } elseif ($output -match 'Alt-Svc: h3=') {
        Write-Host "HTTP/3: Ondersteund via Alt-Svc, maar niet gebruikt voor deze verbinding" -ForegroundColor Yellow
    } else {
        Write-Host "HTTP/3: Niet ondersteund of fout" -ForegroundColor Red
        # Toon nuttige debug-informatie
        $debugLines = $output | Where-Object { $_ -match 'error|failed|using HTTP/' }
        if ($debugLines) {
            Write-Host "  Debug info:" -ForegroundColor Yellow
            $debugLines | ForEach-Object { Write-Host "    $_" -ForegroundColor Yellow }
        }
    }
} else {
    Write-Host "HTTP/3: curl.exe niet gevonden, test overgeslagen" -ForegroundColor Yellow
    Write-Host "  Installeer curl om HTTP/3 te testen: winget install curl" -ForegroundColor Yellow
}

# 5) Toon TLS-informatie (belangrijk voor HTTP/3)
try {
    Write-Host "`nTLS informatie controleren:" -ForegroundColor Cyan
    $tcpClient = New-Object Net.Sockets.TcpClient
    $tcpClient.Connect($domain, 443)
    
    $sslStream = New-Object System.Net.Security.SslStream $tcpClient.GetStream()
    $sslStream.AuthenticateAsClient($domain)
    
    Write-Host "TLS Protocol: $($sslStream.SslProtocol)" -ForegroundColor Cyan
    Write-Host "Cipher: $($sslStream.CipherAlgorithm) $($sslStream.CipherStrength) bits" -ForegroundColor Cyan
    
    $tcpClient.Close()
} catch {
    Write-Host "Kon TLS informatie niet ophalen: $($_.Exception.Message)" -ForegroundColor Red
}
