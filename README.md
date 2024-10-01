# Partner managed Azure subscription
Sette Azure subscription til partner og ALSO managed.
#

Ulempen med un-managed er:
1. Høyere kost for kunden.
2. ACMP verktøy virker ikke (policy, kostoversikt, quota increase med fler).
3. ALSO kan ikke oppdage misstenkelig bruk av Azure subscription.
4. ALSO kan ikke gi support på resources i subscription.
 
I tillegg til dette er det selvfølgelig at Partner og ALSO ikke får dette som registrert revenue, som betyr ingen incentives, eller benefits opp mot solution designation partner områder.

Oversikt over un-managed subscriptions finnes i Azure Plan Insights rapporten.

Vi har nå utviklet script som gjør endring til managed subscription enklere.
For å kjøre script trenger partner en konto med Owner rolle på subscription, eller "User Access adminsitrator" rollen. 
Les mer om "User Access Administrator" her https://learn.microsoft.com/en-us/azure/role-based-access-control/elevate-access-global-admin?tabs=azure-portal.

Scriptet kan kjøres i Cloud shell, da trenger dere ikke tenke på hvilke moduler som er nødvendig, eller fra Powershell7.

Azure Cloud Shell
1. start Azure Cloud Shell https://shell.azure.com.
2. Autentiser med konto med tilstrekkelig rettigheter.
3. Kopier script linjer fra "Start Cloud Shell.ps1" og kjør i cloud shell.

PowerShell 7 (avansert)
1. Last ned \ps1\azureoles.ps1 og \ps1\start powershel7.ps1 i samme mappe.
2. Editer start powerhsell7.ps1 med riktige verdier.
3. Kjør start powersehll7.ps1.

Script kjører og vil be om info.

Resultat viser om roller er lagt til, eller om dem allerede eksisterer.
