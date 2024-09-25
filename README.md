# AzureRoles
Set Azure subscription to managed
#
1. start Azure Cloud Shell https://shell.azure.com
2. Autenticate with subscription owner
3. Replace AdminAgentID with partrners ID. Get from Indirect Reseller Experience in ALSO Cloud Marketplace.

#

$AdminAgentID=""

#

$Script = Invoke-WebRequest https://raw.githubusercontent.com/ArneMagnussen/AzureRoles/refs/heads/main/AzureRoles.ps1

$ScriptBlock = [Scriptblock]::Create($Script.Content)

Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList ($args + @($AdminAgentID))
