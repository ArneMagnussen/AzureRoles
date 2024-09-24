# Azure cloud shell

$ErrorActionPreference = "Stop"

# Reseller Admin Agent group ID --- Example dc2aa490-xxxx-yyyy-zzzz-02bcb829da93
# Available in ACMP in Indirect Reseller Excperience Servcie
$ResellerAdminAgentID = "dc2aa490-5b61-47a4-880a-02bcb829da93" # also software demo 

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


#Clear-Variable $SubId
#Clear-Variable $subArray
#Clear-Variable $sublist
#Clear-Variable $subsciptionsForUse
#Clear-Variable $Subscriptions
#Clear-Variable $SubscriptionIDs
#Remove-Variable $subid¨ÅPOIUYTRE-AzSubscription

#ALSO CSP NOK TenantID
#$ALSOPACTenantID = "d1b209ea-0ffb-4ffe-b4dd-efac86a80e61" #NOK
$ALSOPACAdminAgentID = "27679ace-cff1-4ba4-8c26-3f26c8b8c342" #NOK

#Get all Azure subscriptions
$subsciptions = Get-AzSubscription
if (-not $subsciptions){
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

# AdminAgent GroupIDs to assign FPG permissions
$AdminAgentIDs =@(
    $ResellerAdminAgentID
    $ALSOPACAdminAgentID)
$result =  @()

foreach ($SubId in $subsciptionsForUse) {
    foreach ($Gid in $AdminAgentIDs) {
        try{ 
            New-AzRoleAssignment -ObjectId $Gid -RoleDefinitionName $AssignRole -Scope /subscriptions/$SubId -ObjectType ForeignGroup | Out-Null
            $row = [PSCustomObject]@{
                SubscriptionName = $SubId.name
                Status           = "Role Assigned"
                AssignedRoles    = $AssignRole
                GroupID          = $Gid}
                $AssignedRoles++
        }
        catch {
            $row = [PSCustomObject]@{
                SubscriptionName = $SubId.name
                Status           = $_.Exception.Message
                AssignedRoles    = ""
                GroupID          = ""}
        }
        $result += $row
    }
}
$result  | Format-List

$result  | Format-Table