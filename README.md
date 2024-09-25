# AzureRoles

$AdminAgentID=""

$Script = Invoke-WebRequest https://raw.githubusercontent.com/ArneMagnussen/AzureRoles/refs/heads/main/AzureRoles.ps1

$ScriptBlock = [Scriptblock]::Create($Script.Content)

Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList ($args + @($AdminAgentID))
