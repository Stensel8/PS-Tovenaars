# Script van school voor opdracht 4-6: dit wordt op de remote VM's uitgevoerd.
# Het geeft de service WinRM een andere DisplayName. Terugzetten kan met:
# Set-Service -Name WinRM -DisplayName "Windows Remote Management (WS-Management)"
Get-ChildItem
Set-Service -Name WinRM -DisplayName "Student customized"
Set-Service -Name WinRM -Status Running -PassThru
