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
*   **2024-07-16:** Updated `README.md` to reflect modernization changes.

**Blocked / Needs Review:**

*   **Update Solution Deployment - Linked Templates:** Edits failed to apply correctly for `ARM-Templates/LinkedTemplates/PingFederate/mainTemplate.json` and `ARM-Templates/LinkedTemplates/Ubiquiti/mainTemplate.json`. These templates still contain outdated API versions and structure. Requires further investigation or manual correction.
*   **Verification - Detection Rule Script:** Logic in `Update-DetectionRules.ps1` needs functional testing against the updated API.
*   **Verification - KQL Parsers:** Parsers in `parsers/` directory should be reviewed to ensure compatibility with all data going to `SecureHats_CL` table (most appear to use replaceable `<CustomLog>` token, but full verification recommended).
*   **Verification - Solution Content:** Workbooks, Analytics Rules, etc., deployed via linked templates require testing for functionality after API/data structure changes.

**Current:**

*   Completed primary modernization tasks.
*   Blocked on updating `PingFederate` and `Ubiquiti` linked templates.

**Next:**

1.  **Manual Review / Testing:**
    *   Manually review and correct `PingFederate/mainTemplate.json` and `Ubiquiti/mainTemplate.json` based on changes applied to other linked templates.
    *   Deploy the updated template to a test environment.
    *   Verify functionality of deployed resources (data ingestion, parsers, analytics rules, workbooks).
2.  **Refine `README.md`:** Add detailed deployment steps and usage notes based on testing.

--- 