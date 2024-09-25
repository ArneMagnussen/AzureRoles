# AzureRoles
Set Azure subscription to managed

Run from Azure Cloud shell.  https://shell.azure.com

$AdminAgentID=""

$Script = Invoke-WebRequest https://raw.githubusercontent.com/ArneMagnussen/AzureRoles/refs/heads/main/AzureRoles.ps1

$ScriptBlock = [Scriptblock]::Create($Script.Content)

Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList ($args + @($AdminAgentID))
