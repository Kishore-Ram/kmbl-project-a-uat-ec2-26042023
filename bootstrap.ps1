<powershell>
$username="app_user"
$password="Kotak@123456789"
$adminpassword="Kotak@123456789"
$securePassword = ($password | ConvertTo-SecureString -AsPlainText -Force)
$secureAdminPassword = ($adminpassword | ConvertTo-SecureString -AsPlainText -Force)
New-LocalUser -Name app_user -Password ($securePassword | ConvertTo-SecureString -AsPlainText -Force) -Description "Application user"
New-LocalUser -Name sysadmin -Password ($securePassword | ConvertTo-SecureString -AsPlainText -Force) -Description "Cloud Admin User"
Add-LocalGroupMember -Group "Administrators" -Member "sysadmin"
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "app_user"
Set-LocalUser -Name Administrator -Password $secureAdminPassword -Verbose 
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
Start-Service AmazonSSMAgent
</powershell>