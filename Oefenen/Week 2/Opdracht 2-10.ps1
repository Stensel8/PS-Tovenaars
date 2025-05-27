if (get-alias fw ){
    write-host "Alias 'fw' already exists."
} else {
    write-host "Alias 'fw' does not exist."
}

write-host "creating alias 'fire' for Windows Firewall"
Set-alias fire "c:\Windows\system32\wf.msc"

write-host "alias created"

Set-alias fire "c:\Windows\system32\wf.msc"

fire
