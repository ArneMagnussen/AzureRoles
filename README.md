# AzureRoles
Set Azure subscription to managed
#
1. start Azure Cloud Shell https://shell.azure.com
2. Autenticate with subscription owner
3. Replace AdminAgentID with partrners ID. Get from Indirect Reseller Experience in ALSO Cloud Marketplace.

#

$Script = Invoke-WebRequest https://raw.githubusercontent.com/ArneMagnussen/AzureRoles/refs/heads/main/ps1/AzureRoles.ps1
Invoke-Expression $($script.content)
