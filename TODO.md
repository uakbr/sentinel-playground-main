**Project:** Sentinel Playground Modernization

**Goal:** Update the repository to a functional state using modern Azure practices and resources.

---

**Status:**

**Done:**

*   **2024-07-16:** Reviewed the project structure by listing directories (`.`, `scripts`, `ARM-Templates`).
*   **2024-07-16:** Read `README.md` to understand the project's original purpose and components.
*   **2024-07-16:** Analyzed `ARM-Templates/azuredeploy.json` and identified outdated:
    *   ARM Schema version.
    *   API versions for `Microsoft.OperationalInsights/workspaces`, `Microsoft.OperationsManagement/solutions`, `Microsoft.OperationalInsights/workspaces/dataSources`, `Microsoft.ManagedIdentity/userAssignedIdentities`, `Microsoft.Authorization/roleAssignments`, `Microsoft.Resources/deploymentScripts`.
    *   Deprecated method for Sentinel onboarding (`Microsoft.OperationsManagement/solutions`).
    *   Outdated method for Activity Log/Security Events data connection (`Microsoft.OperationalInsights/workspaces/dataSources`).
    *   Reliance on `Start-Sleep` for dependencies.
*   **2024-07-16:** Analyzed `ARM-Templates/LinkedTemplates/solutions.json` and identified outdated API versions and use of nested deployments.
*   **2024-07-16:** Analyzed `PowerShell/Add-AzureMonitorData/Add-AzureMonitorData.ps1` and identified:
    *   Use of legacy Log Analytics Data Collector API (needs replacement with Logs Ingestion API using DCE/DCR).
    *   Insecure use of Workspace Key (should use Managed Identity).
    *   Reliance on external GitHub URLs for artifacts.
    *   Outdated API version in `Invoke-AzRestMethod` for saved searches.
*   **2024-07-16:** Analyzed `PowerShell/Update-DetectionRules/Update-DetectionRules.ps1` and identified:
    *   Use of preview API version (`2021-10-01-preview`) for alert rules/templates.
*   **2024-07-16:** Created this `TODO.md` file.
*   **2024-07-16:** Updated `ARM-Templates/azuredeploy.json`:
    *   Updated API versions for `workspaces`, `userAssignedIdentities`, `roleAssignments`, `deploymentScripts`, nested `deployments`.
    *   Replaced `Microsoft.OperationsManagement/solutions` with `Microsoft.SecurityInsights/onboardingStates`.
    *   Replaced `Microsoft.OperationalInsights/workspaces/dataSources` with `Microsoft.SecurityInsights/dataConnectors` for Activity Log & Security Events.
    *   Updated `azPowerShellVersion` in `deploymentScripts` to `9.0`.
    *   Removed `sleep` and `waiting-for-customdata` deployment scripts.
    *   Adjusted resource dependencies (`dependsOn`).
*   **2024-07-16:** Refactored Data Ingestion:
    *   Modified `azuredeploy.json`: Added `Microsoft.Insights/dataCollectionEndpoints`, `Microsoft.Insights/dataCollectionRules` (with `Custom-SecureHatsStream` targeting `SecureHats_CL`), and `Microsoft.Insights/dataCollectionRuleAssociations`. Updated deployment script args (`dceUri`, `dcrImmutableId`) and dependencies.
    *   Updated `PowerShell/Add-AzureMonitorData/Add-AzureMonitorData.ps1`: Added parameters, replaced Data Collector API with `Send-ToDce` function using Logs Ingestion API (`Invoke-RestMethod -UseDefaultCredentials`), removed workspace key usage, added `Connect-AzAccount -Identity`, updated saved search API version.

**Current:**

*   Completed data ingestion refactoring.
*   Ready to proceed with updating solution deployment templates.

**Next:**

1.  **Update Solution Deployment:**
    *   Review `ARM-Templates/LinkedTemplates/solutions.json` and nested templates (`Box`, `CiscoISE`, etc.).
    *   Update API versions in `solutions.json` and all linked templates (`mainTemplate.json` files within subdirectories).
    *   *(Stretch Goal)*: Consider replacing nested deployments with direct `Microsoft.SecurityInsights/solutions` or `Microsoft.SecurityInsights/contentPackages` resources if applicable/simpler.
2.  **Update Detection Rule Script:**
    *   Update API version in `PowerShell/Update-DetectionRules/Update-DetectionRules.ps1`.
    *   Test and verify the script logic against the updated API.
3.  **General Cleanup:**
    *   *(Done)* Update `azPowerShellVersion` in Deployment Script resources.
    *   *(Done)* Review and remove any remaining unnecessary `Start-Sleep` resources.
    *   Update `README.md` to reflect changes.
    *   *(New)* Review KQL parsers (`*.csl`) for compatibility, especially if they relied on specific table names other than `SecureHats_CL`. 

--- 