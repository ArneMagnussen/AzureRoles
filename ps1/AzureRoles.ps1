# Azure cloud shell

[CmdletBinding()] 
param (
    [string]$ResellerAdminAgentID,
    [string]$TenantID
)

$ErrorActionPreference = "Stop"

try {
    $sessioninfo = Get-CloudDrive
    if ($sessioninfo) {
        Write-Host "Running in Cloud Shell mode..." -ForegroundColor Green
    }   
}
catch {
    Write-Host "Running in local PowerShell session mode..." -ForegroundColor Yellow
    
    #Required modules
    $RequiredPowershellVersion = "7.4.5"
    $RequiredModules = @(
        @{
            "ModuleName"           = "Az.Accounts"
            "MinimalModuleVersion" = "3.0.4"
        },
        @{
            "ModuleName"           = "Az.Resources"
            "MinimalModuleVersion" = "7.4.0"
        }
    )

    #Check powershell version
    if ($PSVersionTable.PSVersion -lt [version]$RequiredPowershellVersion) {
        Write-Host "Please update Powershell to version $RequiredPowershellVersion or higher" -ForegroundColor Red
        exit
    }

    #Check modules
    foreach ($RequiredModule in $RequiredModules) {
        if (-not (Get-InstalledModule -Name $RequiredModule.ModuleName -MinimumVersion $RequiredModule.MinimalModuleVersion -ErrorAction SilentlyContinue)) {
            Write-Host "Please install module $($RequiredModule.ModuleName), minimal version $($RequiredModule.MinimalModuleVersion)" -ForegroundColor Red
            exit
        }
    }

    #Get TenantID 
    if (-not $TenantID) {
        $tenantID = Read-host -Prompt "Input Customer Microsoft TenantID - format 63264b6b-xxxx-xxxx-xxxx-4f43d916ac89"
        if (-not [guid]::TryParse($tenantID, $([ref][guid]::Empty))) {
            Write-host "Invalid Tenant ID, exiting"
            Exit 1
        }
    }

    try {
        Connect-AzAccount -tenant $tenantID -SkipContextPopulation
    }
    catch {
        Write-host "Not able to login"
        Exit 1
    }

}


# AdminAgent Foreign Principal Group role to be assignet to Admin Agents --- Owner Role recommended
$AssignRole = "Owner"
$ALSOPACAdminAgentID = "27679ace-cff1-4ba4-8c26-3f26c8b8c342" #NOK

#----------------------------------------------

#if missing Reseller Admin Agent Group ID prompt for value
if (-not $ResellerAdminAgentID) {
    $ResellerAdminAgentID = Read-host -Prompt "`r`nInput Reseller Admin Agent Group ID - format 63264b6b-xxxx-xxxx-xxxx-4f43d916ac89"
    if (-not [guid]::TryParse($ResellerAdminAgentID, $([ref][guid]::Empty))) {
        Write-host "Invalid Group ID, exiting"
        Exit 1
    }
}

#Get all Azure subscriptions
$subsciptions = Get-AzSubscription
if (-not $subsciptions) {
    Write-Host "No Azure Subscriptions found"
    Exit 1
}

$n = 1
Write-Host "0, All Subscription"
foreach ($sub in $subsciptions) {
    Write-Host "$n, $($sub.Name), $($sub.Id)"
    $n++
}
$sublist = Read-Host -Prompt "Type in the number of the subscription you want to use (comma separat)"
$subArray = $sublist -split ","
$subsciptionsForUse = @()
if ($sublist -eq "0") {
    $subsciptionsForUse = $subsciptions
}
else {
    foreach ($sub in $subArray) {
        $subsciptionsForUse += $subsciptions[$sub - 1]
    }
}

$AdminAgentIDs = @()
$AdminAgentIDs += New-Object -TypeName psobject -Property @{Partner = "ALSO"; ID = $ALSOPACAdminAgentID }
$AdminAgentIDs += New-Object -TypeName psobject -Property @{Partner = "Partner"; ID = $ResellerAdminAgentID }

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
Admin Agent as Argument
$AdminAgentID="dc2aa490-5b61-47a4-880a-02bcb829da93"
$Script = Invoke-WebRequest https://raw.githubusercontent.com/ArneMagnussen/AzureRoles/refs/heads/main/ps1/AzureRoles.ps1
$ScriptBlock = [Scriptblock]::Create($Script.Content)
Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList ($args + @($AdminAgentID))

Admin Agent prompted
$Script = Invoke-WebRequest https://raw.githubusercontent.com/ArneMagnussen/AzureRoles/refs/heads/main/ps1/AzureRoles.ps1
Invoke-Expression $($script.content)
#>