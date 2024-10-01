# AzureRoles
Sette Azure subscription til ALSO managed.
#

Ulempen med un-managed er:
1. Høyere kost for kunden
2. ACMP verktøy virker ikke (policy, kostoversikt, qouta increase osv)
3. ALSO kan ikke gi support på resources i subscription
 
I tillegg til dette er det selvfølgelig at Partner og ALSO ikke får dette som registrert revenue, som betyr ingen incentives, eller benefits opp mot solution designation partner områder.
 
Vi har nå utviklet script som gjør endring til managed enklere.
For å kjøre script trenger partner en konto med Owner rolle på subscription, eller "User Access adminsitrator" rollen. 
Les mer om "User Access Administrator" her https://learn.microsoft.com/en-us/azure/role-based-access-control/elevate-access-global-admin?tabs=azure-portal

Scriptet kan kjøres i Cloud shell, da trenger dere ikke tenke på hvilke moduler som er nødvendig. Eller fra Powershell7

#Azure Cloud Shell
1. start Azure Cloud Shell https://shell.azure.com
2. Autentiser med konto med tilstrekkelig rettigheter.
3. .

#

$Script = Invoke-WebRequest https://raw.githubusercontent.com/ArneMagnussen/AzureRoles/refs/heads/main/ps1/AzureRoles.ps1
Invoke-Expression $($script.content)
