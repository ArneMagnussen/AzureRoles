# Azure cloud shell

[CmdletBinding()] 
param (
    [Parameter(Mandatory=$True)]
    [string]$ResellerAdminAgentID
)

$ErrorActionPreference = "Stop"

# Reseller Admin Agent group ID --- Example dc2aa490-xxxx-yyyy-zzzz-02bcb829da93
# Available in ACMP in Indirect Reseller Excperience Servcie
# $ResellerAdminAgentID = "dc2aa490-5b61-47a4-880a-02bcb829da93" # also software demo 

# AdminAgent Foreign Principal Group role to be assignet to Admin Agents --- Owner Role recommended
$AssignRole = "Owner"

#----------------------------------------------

#if missing Reseller Admin Agent Group ID prompt for value
if (-not $ResellerAdminAgentID) {
    $ResellerAdminAgentID = Read-host -Prompt "`r`nInput Reseller Admin Agent Group ID - format 63264b6b-xxxx-xxxx-xxxx-4f43d916ac89"
    if (-not [guid]::TryParse($ResellerAdminAgentID, $([ref][guid]::Empty))) {
        Write-host "Invalid Group ID, exiting"
        Exit 1
    }
}


$ALSOPACAdminAgentID = "27679ace-cff1-4ba4-8c26-3f26c8b8c342" #NOK

#Get all Azure subscriptions
$subsciptions = Get-AzSubscription
if (-not $subsciptions) {
    Write-Host "No Azure Subscriptions found"
    Exit 1
}

$n = 1
foreach ($sub in $subsciptions) {
    Write-Host "$n, $($sub.Name), $($sub.Id)"
    $n++
}
$sublist = Read-Host -Prompt "Type in the number of the subscription you want to use (comma separat)"
$subArray = $sublist -split ","
$subsciptionsForUse = @()
foreach ($sub in $subArray) {
    $subsciptionsForUse += $subsciptions[$sub - 1]
}

<# AdminAgent GroupIDs to assign FPG permissions
$AdminAgentIDs = @(
    $ResellerAdminAgentID
    $ALSOPACAdminAgentID)
#>

$AdminAgentIDs = @()
$AdminAgentIDs += New-Object -TypeName psobject -Property @{Partner="ALSO"; ID=$ALSOPACAdminAgentID}
$AdminAgentIDs += New-Object -TypeName psobject -Property @{Partner="Partner"; ID=$ResellerAdminAgentID}

$result = @()
$row = @()

foreach ($SubId in $subsciptionsForUse) {
    foreach ($Gid in $AdminAgentIDs) {
        try { 
            New-AzRoleAssignment -ObjectId $Gid.ID -RoleDefinitionName $AssignRole -Scope /subscriptions/$SubId -ObjectType ForeignGroup | Out-Null
            $row = [PSCustomObject]@{
                SubscriptionName = $SubId.name
                Status           = "Role Assigned"
                AssignedRoles    = $AssignRole
                Assignee         = $Gid.Partner
            }
            $AssignedRoles++
        }
        catch {
            try {
                $RolesAssigned = Get-AzRoleAssignment -Scope /subscriptions/$subid
                if ($RolesAssigned | where-object { $_.RoleDefinitionName -eq $AssignRole -and $_.objectId -eq $Gid.ID }) {
                    $row = [PSCustomObject]@{
                        SubscriptionName = $SubId.name
                        Status           = "Role Present"
                        AssignedRoles    = "Owner"
                        Assignee         = $Gid.Partner
                    }  
                } 
            }
            catch {
                $row = [PSCustomObject]@{
                    SubscriptionName = $SubId.name
                    Status           = $_.Exception.Message
                    AssignedRoles    = ""
                    Assignee         = $Gid.Partner
                }
            }
        }
        $result += $row
    }
}

$result  | Format-Table


<#
$ResellerAdminAgentID="dc2aa490-5b61-47a4-880a-02bcb829da93"
$AdminAgentID="dc2aa490-5b61-47a4-880a-02bcb829da93"
$Params=@("-ResellerAdminAgentID", $AdminAgentID)
$ScriptFromGitHub = Invoke-WebRequest -uri https://raw.githubusercontent.com/ArneMagnussen/AzureRoles/refs/heads/main/AzureRoles.ps1
Invoke-Expression $($ScriptFromGitHub.Content) $Params

https://raw.githubusercontent.com/ArneMagnussen/AzureRoles/edit/main/AzureRoles.ps1
https://raw.githubusercontent.com/ArneMagnussen/AzureRoles/refs/heads/main/AzureRoles.ps1

AzureRoles.ps1
#>
