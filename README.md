# AzureRoles
Sette Azure subscription til managed.
#

Ulempen med un-managed er:
1. Høyere kost for kunden
2. ACMP verktøy virker ikke (policy, kostoversikt, qouta increase osv)
3. ALSO kan ikke gi support på resources i subscription
 
I tillegg til dette er det selvfølgelig at Partner og ALSO ikke får dette som registrert revenue, som bettyr ngen incentives elle benefits opp mot solution designation partner områder.
 
Vi har nå utviklet script som gjør endring til managed enklere.

For å gjølre dette trneger partner en konto med Owner rolle, eller 2User Access adminsitrator". 

Les mer om dette her https://learn.microsoft.com/en-us/azure/role-based-access-control/elevate-access-global-admin?tabs=azure-portal

1. start Azure Cloud Shell https://shell.azure.com
2. Autenticate with subscription owner
3. Replace AdminAgentID with partrners ID. Get from Indirect Reseller Experience in ALSO Cloud Marketplace.

#

$Script = Invoke-WebRequest https://raw.githubusercontent.com/ArneMagnussen/AzureRoles/refs/heads/main/ps1/AzureRoles.ps1
Invoke-Expression $($script.content)
