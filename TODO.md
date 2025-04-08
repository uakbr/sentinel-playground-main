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

**Current:**

*   Waiting for confirmation to proceed with the first update task.

**Next:**

1.  **Update Core ARM Template (`azuredeploy.json`):**
    *   Update ARM schema version.
    *   Update API versions for existing resources (Log Analytics, Managed Identity, Role Assignments, Deployment Scripts).
    *   Replace deprecated Sentinel onboarding (`Microsoft.OperationsManagement/solutions`) with `Microsoft.SecurityInsights/onboardingStates`.
    *   Replace deprecated data sources (`Microsoft.OperationalInsights/workspaces/dataSources`) with modern data connectors (`Microsoft.SecurityInsights/dataConnectors`) for Azure Activity Log and Security Events.
    *   *(Stretch Goal)*: Attempt to remove `Start-Sleep` resource used for role assignment delay.
2.  **Refactor Data Ingestion:**
    *   Modify `azuredeploy.json` to add Data Collection Endpoint (DCE) and Data Collection Rule (DCR) resources.
    *   Update `PowerShell/Add-AzureMonitorData/Add-AzureMonitorData.ps1` script:
        *   Change authentication to use Managed Identity.
        *   Modify logic to send data to the DCR endpoint (Logs Ingestion API).
        *   Update API version for saved searches.
        *   *(Stretch Goal)*: Package sample data/parsers instead of fetching from GitHub.
3.  **Update Solution Deployment:**
    *   Review `ARM-Templates/LinkedTemplates/solutions.json` and nested templates (`Box`, `CiscoISE`, etc.).
    *   Update API versions in all linked templates.
    *   *(Stretch Goal)*: Consider replacing nested deployments with direct `Microsoft.SecurityInsights/solutions` or `Microsoft.SecurityInsights/contentPackages` resources if applicable/simpler.
4.  **Update Detection Rule Script:**
    *   Update API version in `PowerShell/Update-DetectionRules/Update-DetectionRules.ps1`.
    *   Test and verify the script logic against the updated API.
5.  **General Cleanup:**
    *   Update `azPowerShellVersion` in Deployment Script resources.
    *   Review and remove any remaining unnecessary `Start-Sleep` resources.
    *   Update `README.md` to reflect changes.

--- 