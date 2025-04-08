
# Comprehensive To-Do List for Microsoft Sentinel ARM Templates Project

## 1. Entity Mapping Completion
Need to add proper `entityMappings` to all remaining analytics rules that lack them:

### 1.1. Cisco ISE Template
- Add `entityMappings` to rule `analytic4-id` (Certificate expiration) with mappings for:
  - `AccountCustomEntity` → Account.FullName
  - `HostCustomEntity` → Host.HostName
  - `IPCustomEntity` → IP.Address

- Add `entityMappings` to rule `analytic5-id` (Command with highest privileges from new IP) with mappings for:
  - `AccountCustomEntity` → Account.FullName
  - `IPCustomEntity` → IP.Address

- Add `entityMappings` to rule `analytic6-id` (Command with highest privileges by new user) with mappings for:
  - `AccountCustomEntity` → Account.FullName
  - `IPCustomEntity` → IP.Address

- Add `entityMappings` to rule `analytic7-id` (Device changed IP) with mappings for:
  - `HostCustomEntity` → Host.HostName
  - `IPCustomEntity` → IP.Address

- Add `entityMappings` to rule `analytic8-id` (Device PostureStatus changed) with mappings for:
  - `IPCustomEntity` → IP.Address

- Add `entityMappings` to rule `analytic9-id` (Log collector suspended) with mappings for:
  - `IPCustomEntity` → IP.Address

- Add `entityMappings` to rule `analytic10-id` (Log files deleted) with mappings for:
  - `AccountCustomEntity` → Account.FullName
  - `HostCustomEntity` → Host.HostName
  - `IPCustomEntity` → IP.Address

### 1.2. Box Template
- Add `entityMappings` to rule `analytic3-id` (Forbidden file type) with mappings for:
  - `AccountCustomEntity` → Account.FullName
  - `IPCustomEntity` → IP.Address

- Add `entityMappings` to rule `analytic4-id` (Inactive user login) with mappings for:
  - `AccountCustomEntity` → Account.FullName

- Add `entityMappings` to rule `analytic5-id` (Item shared to external entity) with mappings for:
  - `AccountCustomEntity` → Account.FullName

- Add `entityMappings` to rule `analytic6-id` (Many items deleted) with mappings for:
  - `AccountCustomEntity` → Account.FullName

- Add `entityMappings` to rule `analytic7-id` (New external user) with mappings for:
  - `AccountCustomEntity` → Account.FullName
  - `IPCustomEntity` → IP.Address

- Add `entityMappings` to rule `analytic8-id` (File containing sensitive data) with mappings for:
  - `AccountCustomEntity` → Account.FullName
  - `IPCustomEntity` → IP.Address

- Add `entityMappings` to rule `analytic9-id` (User logged in as admin) with mappings for:
  - `AccountCustomEntity` → Account.FullName
  - `IPCustomEntity` → IP.Address

- Add `entityMappings` to rule `analytic10-id` (User role changed to owner) with mappings for:
  - `AccountCustomEntity` → Account.FullName

### 1.3. Ubiquiti Template
- Find all 10 analytics rules in the Ubiquiti template
- Add appropriate `entityMappings` to each rule based on the custom entity fields used in the KQL queries

### 1.4. CrowdStrike Template
- Create/add a new parser function resource `CrowdStrikeFalconEventStream` that uses `SecureHats_CL` instead of `CommonSecurityLog_CL`
- Fix affected graph queries that reference `CommonSecurityLog_CL` for CrowdStrike events

## 2. Parser Updates Verification
Verify that all parser function resources are correctly updated:

### 2.1. CrowdStrike Parser
- Add a new `savedSearches` resource that defines the `CrowdStrikeFalconEventStream` function alias
- Update the query to use `SecureHats_CL | where LogSourceType == "CrowdStrike_CL"` instead of `CommonSecurityLog_CL`
- Handle `RawData` parsing to extract fields properly
- Update version number to indicate the change

### 2.2. Verify Other Parsers
- Double-check that all templates use the modern `SecureHats_CL` table with appropriate `LogSourceType` filtering
- Ensure consistency in field extraction from `RawData`

## 3. Data Connector References Update
Fix `dataConnectors` resources that still reference old log tables:

### 3.1. CrowdStrike Data Connector
- Update `graphQueries.baseQuery` to use `SecureHats_CL` instead of `CommonSecurityLog_CL`
- Update `dataTypes.lastDataReceivedQuery` and `connectivityCriterias.value` to reflect the table change
- Update display name if referencing the old table name

## 4. Test Queries in Workbooks
Verify that all workbook queries use the parser function alias rather than direct table references:

### 4.1. Box Workbook
- Check all KQL queries in the workbook JSON to ensure they use `BoxEvents` alias
- Fix any instances of direct `BoxEvents_CL` references

### 4.2. CiscoISE Workbook
- Review all KQL queries to ensure they use `CiscoISEEvent` alias
- Fix any instances of direct `CiscoISE_CL` or syslog references

### 4.3. CiscoUmbrella Workbook
- Verify all KQL queries use `Cisco_Umbrella` alias
- Fix any direct references to source tables

### 4.4. PingFederate Workbook
- Check all queries for `PingFederateEvent` alias usage
- Fix any direct references to `CommonSecurityLog` or other tables

### 4.5. CrowdStrike Workbook
- Verify all queries use the `CrowdStrikeFalconEventStream` function alias
- Fix any direct references to `CommonSecurityLog_CL`

### 4.6. Ubiquiti Workbook
- Confirm all queries use the `UbiquitiAuditEvent` function alias
- Fix any direct table references

## 5. Hunting Queries Verification
For each template, verify that hunting queries use parser function aliases:

### 5.1. Review and Update All Hunting Queries
- Check each `savedSearches` resource with category "Hunting Queries"
- Ensure they use the parser function alias rather than direct table references
- Update any direct table references to use the parser function

## 6. Documentation
Update any embedded documentation in the ARM templates:

### 6.1. Update Parser References
- Check all `instructionSteps`, `descriptionMarkdown`, and `additionalRequirementBanner` properties
- Ensure they correctly reference the updated parser functions and don't mention deprecated tables

## 7. Final Validation
Perform a final check of all templates:

### 7.1. Entity Mappings Completeness
- Verify every `Microsoft.SecurityInsights/alertRules` resource has proper `entityMappings`
- Check for consistency in how entity types are mapped across similar rules

### 7.2. Parser Function Correctness
- Verify all parsers use `SecureHats_CL` with appropriate `LogSourceType` filtering
- Ensure field extraction and transformation is complete

### 7.3. Query References
- Verify no direct references to old tables remain in any KQL queries
- All queries should use parser function aliases

### 7.4. API Versions
- Confirm all resources use the latest API versions as defined in the variables
