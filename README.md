# AzureRoles

$AdminAgentID="dc2aa490-5b61-47a4-880a-02bcb829da93"
$Script = Invoke-WebRequest https://raw.githubusercontent.com/ArneMagnussen/AzureRoles/refs/heads/main/AzureRoles.ps1
$ScriptBlock = [Scriptblock]::Create($Script.Content)
Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList ($args + @($AdminAgentID))
