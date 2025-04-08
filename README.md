![logo](./media/sh-banners.png)
=========
[![GitHub release](https://img.shields.io/github/release/SecureHats/Sentinel-playground.svg?style=flat-square)](https://github.com/SecureHats/Sentinel-playground/releases)
[![Maintenance](https://img.shields.io/maintenance/yes/2024.svg?style=flat-square)]()
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FSecureHats%2FSentinel-playground%2Fmain%2FARM-Templates%2Fazuredeploy.json/createUIDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2FSecureHats%2FSentinel-playground%2Fmain%2FARM-Templates%2FUiDefinition.json)
# Sentinel Playground

The Sentinel playground deploys an Azure Sentinel environment pre-provisioned with sample data using modern Azure resources. This speeds up deployment for Proof of Concept and demo scenarios.

#### Prerequisites

- An Azure user account with sufficient permissions to create resource groups, Log Analytics workspaces, Sentinel instances, managed identities, role assignments, deployment scripts, and data collection endpoints/rules.

## ARM template instructions

The main ARM template (`ARM-Templates/azuredeploy.json`) performs the following tasks:

- Creates a resource group (if a new one is specified).
- Creates a Log Analytics workspace (if a new one is specified).
- Enables Azure Sentinel on the workspace using the `Microsoft.SecurityInsights/onboardingStates` resource.
- Configures standard data connectors for Azure Activity Log and Security Events using `Microsoft.SecurityInsights/dataConnectors`.
- Creates a User Assigned Managed Identity for deployment scripts.
- Creates a Data Collection Endpoint (DCE) and Data Collection Rule (DCR) for ingesting custom logs via the Logs Ingestion API.
- Runs [ARM deployment scripts](https://docs.microsoft.com/azure/azure-resource-manager/templates/deployment-script-template) using the managed identity to:
    - Ingest sample data (JSON files) from specified providers into the `SecureHats_CL` custom table using the Logs Ingestion API.
    - Deploy KQL functions (`.csl` files) from the `parsers/` directory.
    - Deploy linked templates containing Sentinel Solutions (Workbooks, Analytics Rules, etc.) from `ARM-Templates/LinkedTemplates/`.
    - Update detection rules based on templates using `PowerShell/Update-DetectionRules/Update-DetectionRules.ps1`.

**Note:** The deployment script uses the managed identity for authentication against the Logs Ingestion API and Azure Resource Manager, removing the need for workspace keys or interactive logins during deployment.

Sample data ingestion now targets the `SecureHats_CL` table via a Data Collection Rule. Parsers originally written for other specific custom tables (e.g., `AlsidForADLog_CL`, `agari_apdpolicy_log_CL`) may need updating.

Initial data ingestion and deployment can take around **10-15 minutes**.

## Current Status & ToDo

This repository has undergone modernization efforts (as of August 2024) to update deprecated resources and APIs.

**Completed Updates:**
- Updated core ARM template (`azuredeploy.json`) with modern API versions and resource types (Sentinel onboarding, standard connectors).
- Replaced legacy Data Collector API with modern Logs Ingestion API (DCE/DCR) in `azuredeploy.json` and `Add-AzureMonitorData.ps1`.
- Updated API versions in `Update-DetectionRules.ps1`.
- Updated API versions in `solutions.json` and all linked solution templates (`Box`, `CiscoISE`, `CiscoUmbrella`, `CrowdStrike`, `PingFederate`, `Ubiquiti`).
- Removed legacy `Start-Sleep` dependencies where possible.

**Remaining ToDo / Areas for Review:**
- **KQL Parser Compatibility:** Review `.csl` files in `parsers/`. Ensure they function correctly with all data now landing in `SecureHats_CL` instead of potentially different custom tables.
- **Solution Content Verification:** Verify that workbooks, analytics rules, and other content deployed by the linked templates function correctly with the updated APIs and data structures.
- **Deployment Script Logic:** Review the logic within `Add-AzureMonitorData.ps1` and `Update-DetectionRules.ps1` for potential improvements or adjustments needed after API changes.
- **README Updates:** Further refine this README with more detailed usage instructions and notes on the updated architecture.

**Verification Approach Note (YYYY-MM-DD):**
*   Due to the nature of the playground (intended for user-driven Portal deployment), the initial deployment step for verification was simulated based on code analysis of `azuredeploy.json` and `UiDefinition.json`, rather than executing `az deployment group create` directly.
*   Phase 2 verification (Core Infrastructure, Standard Connectors, Sample Data Ingestion) was completed via code analysis, confirming the template uses modern resources (DCE/DCR, MI) and targets `SecureHats_CL` correctly. Proceeding to Phase 3 (Parsers, Rules, Workbooks).
