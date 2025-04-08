**Project:** Sentinel Playground Modernization

**Goal:** Update the repository to a functional state using modern Azure practices and resources.

---

**Status:**

**Done:**

*   **2024-07-16:** Reviewed project structure and `README.md`.
*   **2024-07-16:** Analyzed ARM templates (`azuredeploy.json`, `solutions.json`) and PowerShell scripts (`Add-AzureMonitorData.ps1`, `Update-DetectionRules.ps1`) for outdated APIs/methods.
*   **2024-07-16:** Created `TODO.md` file.
*   **2024-07-16:** Updated `ARM-Templates/azuredeploy.json` (API versions, Sentinel onboarding, data connectors, dependencies, PS version).
*   **2024-07-16:** Refactored Data Ingestion (`azuredeploy.json` for DCE/DCR, `Add-AzureMonitorData.ps1` for Logs Ingestion API & MI auth).
*   **2024-07-16:** Updated API versions in `ARM-Templates/LinkedTemplates/solutions.json`.
*   **2024-07-16:** Attempted updates on linked solution templates (`Box`, `CiscoISE`, `CiscoUmbrella`, `CrowdStrike`). Successfully updated `Box`, `CiscoISE`, `CiscoUmbrella`, `CrowdStrike`.
*   **2024-07-16:** Updated API version in `PowerShell/Update-DetectionRules/Update-DetectionRules.ps1` to `2023-11-01`.

**Blocked / Needs Review:**

*   **Update Solution Deployment - Linked Templates:** Edits failed to apply correctly for `ARM-Templates/LinkedTemplates/PingFederate/mainTemplate.json` and `ARM-Templates/LinkedTemplates/Ubiquiti/mainTemplate.json`. These templates still contain outdated API versions and structure. Requires further investigation or manual correction.
*   **Verification:** Logic in `Update-DetectionRules.ps1` needs functional testing against the updated API.

**Current:**

*   Completed API update for `Update-DetectionRules.ps1`.
*   Ready to revisit blocked solution templates.

**Next:**

1.  **Revisit Blocked Solution Templates:**
    *   Re-attempt updates for `PingFederate/mainTemplate.json`.
    *   Re-attempt updates for `Ubiquiti/mainTemplate.json`.
    *   If automated edits fail, document required changes for manual review.
2.  **General Cleanup:**
    *   *(Done)* Update `azPowerShellVersion` in Deployment Script resources.
    *   *(Done)* Review and remove any remaining unnecessary `Start-Sleep` resources.
    *   Update `README.md` to reflect changes.
    *   Review KQL parsers (`*.csl`) for compatibility, especially table name references (all custom data now goes to `SecureHats_CL`). 

--- 