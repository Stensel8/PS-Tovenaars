$Path = "$env:windir\System32\drivers\etc\hosts"

$nonCommentLines = foreach ($line in Get-Content $Path) {
    if ($line.trim() -notmatch "#") {
        $line
    }
}

$nonCommentLines | Out-File -FilePath "$env:TEMP\hosts.txt" -Encoding utf8

test-path $env:Temp\hosts.txt

get-content $env:TEMP\hosts.txt | Out-GridView
