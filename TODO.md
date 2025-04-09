# Microsoft Sentinel Playground - TODO List

> **CRITICAL INSTRUCTIONS**: 
> 
> This TODO list is the central tracking document for all remaining work on the Microsoft Sentinel Playground project. Maintaining accurate status tracking is **MANDATORY** for all team members.
>
> **Progress Tracking Requirements:**
> - All items must be marked with their current status
> - Use the following status markers:
>   - `[ ]` = Not started
>   - `[P]` = In progress
>   - `[C]` = Completed
> - Add your initials and date when marking an item in progress: `[P-JD 2023-07-25]`
> - Add your initials and date when marking an item complete: `[C-JD 2023-07-26]`
> - Add detailed notes about implementation decisions under relevant items
> - Report blockers immediately to the project lead
>
> **Reporting Cadence:**
> - Daily updates required for all in-progress items
> - Weekly review of overall progress during team meetings
> - Completion percentage to be calculated based on completed items
>
> **NO WORK SHOULD BE CONSIDERED COMPLETE UNTIL MARKED AS [C] IN THIS LIST**

## 1. Entity Mapping Issues
### 1.1. Cisco ISE Analytics Rules
* [ ] **Rule 4: Certificate Expiration**
  * Add the following entity mappings:
    * Map `AccountCustomEntity` → `Account.FullName`
    * Map `HostCustomEntity` → `Host.HostName`
    * Map `IPCustomEntity` → `IP.Address`

* [ ] **Rule 5: Command with Highest Privileges from New IP**
  * Add the following entity mappings:
    * Map `AccountCustomEntity` → `Account.FullName`
    * Map `IPCustomEntity` → `IP.Address`
    * Update KQL query to extract relevant entity fields

* [ ] **Rule 6: Command with Highest Privileges by New User**
  * Add the following entity mappings:
    * Map `AccountCustomEntity` → `Account.FullName`
    * Map `IPCustomEntity` → `IP.Address`
    * Ensure entities are populated from correct fields in the KQL

* [ ] **Rule 7: Device Changed IP**
  * Add the following entity mappings:
    * Map `HostCustomEntity` → `Host.HostName`
    * Map `IPCustomEntity` → `IP.Address` (both old and new)
    * Add dynamics extraction for both old/new IP addresses

* [ ] **Rule 8: Device PostureStatus Changed**
  * Add the following entity mappings:
    * Map `IPCustomEntity` → `IP.Address`
    * Map `HostCustomEntity` → `Host.HostName` (if available)

* [ ] **Rule 9: Log Collector Suspended**
  * Add the following entity mappings:
    * Map `IPCustomEntity` → `IP.Address`
    * Map `HostCustomEntity` → `Host.HostName` (if available)

* [ ] **Rule 10: Log Files Deleted**
  * Add the following entity mappings:
    * Map `AccountCustomEntity` → `Account.FullName`
    * Map `HostCustomEntity` → `Host.HostName`
    * Map `IPCustomEntity` → `IP.Address`

### 1.2. Box Analytics Rules
* [ ] **Rule 3: Forbidden File Type**
  * Add the following entity mappings:
    * Map `AccountCustomEntity` → `Account.FullName`
    * Map `IPCustomEntity` → `IP.Address`
    * Map `FileCustomEntity` → `File.Name` (if available)

* [ ] **Rule 4: Inactive User Login**
  * Add the following entity mappings:
    * Map `AccountCustomEntity` → `Account.FullName`
    * Update KQL to extract additional user attributes

* [ ] **Rule 5: Item Shared to External Entity**
  * Add the following entity mappings:
    * Map `AccountCustomEntity` → `Account.FullName`
    * Map `FileCustomEntity` → `File.Name` (for shared item)
    * Add mapping for external entity as a custom entity

* [ ] **Rule 6: Many Items Deleted**
  * Add the following entity mappings:
    * Map `AccountCustomEntity` → `Account.FullName`
    * Map bulk delete events to a custom entity
    * Include count and timestamp fields

* [ ] **Rule 7: New External User**
  * Add the following entity mappings:
    * Map `AccountCustomEntity` → `Account.FullName`
    * Map `IPCustomEntity` → `IP.Address`
    * Add external domain mapping if available

* [ ] **Rule 8: File Containing Sensitive Data**
  * Add the following entity mappings:
    * Map `AccountCustomEntity` → `Account.FullName`
    * Map `IPCustomEntity` → `IP.Address`
    * Map `FileCustomEntity` → `File.Name` with sensitivity level

* [ ] **Rule 9: User Logged in as Admin**
  * Add the following entity mappings:
    * Map `AccountCustomEntity` → `Account.FullName`
    * Map `IPCustomEntity` → `IP.Address`
    * Include timestamp and admin privilege level

* [ ] **Rule 10: User Role Changed to Owner**
  * Add the following entity mappings:
    * Map `AccountCustomEntity` → `Account.FullName`
    * Map changed resource as a custom entity
    * Include previous and new role information

### 1.3. Ubiquiti Analytics Rules
* [ ] **Identify All Rules**
  * Review all 10 Ubiquiti rules in the template
    * Extract rule names, IDs, and current query structure
    * Document current entity extraction in queries
  
* [ ] **Map Common Entities**
  * For each rule, determine needed entities:
    * User/Account entities from login events
    * Host entities from device information
    * IP entities from network traffic
  
* [ ] **Implement Consistent Mappings**
  * Standardize entity mapping approach:
    * Use consistent field names across rules
    * Align with Microsoft Security Graph data model
    * Document any custom entity types

## 2. Parser Updates
### 2.1. CrowdStrike Parser Updates
* [ ] **Create New Parser Function**
  * Develop CrowdStrikeFalconEventStream parser:
    * Use SecureHats_CL table as the data source
    * Filter with LogSourceType == "CrowdStrike_CL"
    * Maintain field naming conventions from original parser

* [ ] **Update Query Logic**
  * Modify field extraction from RawData:
    * Extract JSON or structured data from RawData field
    * Use parse_json() for nested JSON objects
    * Normalize field names to match original parser

* [ ] **Dynamic Type Casting**
  * Implement proper data type conversion:
    * Convert string timestamps to datetime
    * Handle numeric fields appropriately
    * Preserve arrays and complex objects

### 2.2. Version Number Updates
* [ ] **Identify Current Versions**
  * For each parser function:
    * Document current version number in comments
    * Track version history if available
    * Create changelog for modifications

* [ ] **Version Increment Strategy**
  * Establish versioning convention:
    * Major version for breaking changes
    * Minor version for field additions/enhancements
    * Patch version for bug fixes
    * Update version numbers for all modified parsers

* [ ] **Documentation Updates**
  * Include version information in parser headers:
    * Add last modified date
    * Document changes in comments
    * Note compatibility requirements

### 2.3. Field Extraction Validation
* [ ] **Review All Parsers**
  * Systematically check each parser:
    * Verify all fields are correctly extracted from RawData
    * Check for data type inconsistencies
    * Ensure field names match the original parsers

* [ ] **Consistency Checks**
  * Compare field names across parsers:
    * Standardize common fields (timestamps, IPs, usernames)
    * Align with Microsoft Security Graph schema
    * Document any parser-specific field names

* [ ] **Performance Optimization**
  * Analyze and improve query performance:
    * Use project-away for unused fields
    * Optimize string parsing operations
    * Consider materialized views for frequent queries

## 3. Data Connector References
### 3.1. CrowdStrike Connector
* [ ] **Update Base Queries**
  * Modify graph query references:
    * Replace CommonSecurityLog_CL with SecureHats_CL
    * Update LogSourceType filter condition
    * Test updated queries for correct results

* [ ] **Fix Last Data Received Query**
  * Update lastDataReceivedQuery property:
    * Use SecureHats_CL with appropriate LogSourceType
    * Maintain backward compatibility for existing deployments
    * Test time range functionality

* [ ] **Update Connectivity Criteria**
  * Modify connectivityCriterias.value:
    * Reference proper table and field combination
    * Adjust threshold values if needed
    * Update sample queries

### 3.2. Display Name Updates
* [ ] **Identify Affected Connectors**
  * Review all data connector resources:
    * Check for hardcoded table references in titles
    * Identify inconsistent naming patterns
    * Document display name dependencies

* [ ] **Standardize Naming Convention**
  * Create consistent naming pattern:
    * Remove direct table references from titles
    * Use vendor/product naming instead of technical details
    * Update translation resources if multilingual

* [ ] **Update UI Components**
  * Fix all display name references:
    * Update connector cards
    * Fix status display text
    * Update connector documentation

### 3.3. Base Query Updates
* [ ] **Inventory All Queries**
  * Document all connector queries:
    * List queries by connector type
    * Note table dependencies
    * Categorize by function (status, data retrieval, etc.)

* [ ] **Standardize Query Structure**
  * Apply consistent patterns:
    * Use parser functions instead of direct table references
    * Optimize for performance with appropriate filters
    * Ensure consistent time range handling

* [ ] **Validate Updated Queries**
  * Test each query:
    * Verify data retrieval accuracy
    * Check performance impact
    * Compare results with original queries

## 4. Workbook Fixes
### 4.1. Box Workbook
* [ ] **Identify Direct References**
  * Scan all queries in the workbook JSON:
    * Find instances of BoxEvents_CL references
    * Document query location and purpose
    * Note dependencies on specific fields

* [ ] **Update to Parser Functions**
  * Convert each direct reference:
    * Replace BoxEvents_CL with BoxEvents parser function
    * Adjust field references if schema changed
    * Test each query after conversion

* [ ] **Validate Visualization**
  * Check all visualizations:
    * Verify charts render correctly with updated queries
    * Test dynamic parameters and filters
    * Ensure time range controls work properly

### 4.2. CiscoISE Workbook
* [ ] **Identify Table References**
  * Scan workbook queries:
    * Find direct CiscoISE_CL or syslog references
    * Document visualization dependencies
    * Note custom field references

* [ ] **Convert to CiscoISEEvent**
  * Update each query:
    * Replace direct table references with CiscoISEEvent parser
    * Adjust field names to match parser output
    * Test query performance and results

* [ ] **Fix Parameter Handling**
  * Review parameter passing:
    * Update parameters that reference old table names
    * Fix dropdown selections that depend on direct queries
    * Test parameter behavior with updated queries

### 4.3. CiscoUmbrella Workbook
* [ ] **Identify Non-Alias Queries**
  * Review all workbook queries:
    * Find queries not using Cisco_Umbrella alias
    * Document visualization impacts
    * Note any custom filtering logic

* [ ] **Update to Parser Alias**
  * Convert each query:
    * Replace direct table references with Cisco_Umbrella parser
    * Adjust field references to match parser output
    * Test visualizations after conversion

* [ ] **Validate Time Range Handling**
  * Check time-based visualizations:
    * Verify timeline charts work correctly
    * Test time range filtering
    * Ensure query performance at different time scales

### 4.4. PingFederate Workbook
* [ ] **Find CommonSecurityLog References**
  * Scan all workbook queries:
    * Identify direct CommonSecurityLog references for PingFederate
    * Document visualization dependencies
    * Note custom field references

* [ ] **Update to PingFederateEvent**
  * Convert each query:
    * Replace CommonSecurityLog references with PingFederateEvent parser
    * Adjust field mappings to match parser output
    * Test query results after conversion

* [ ] **Fix Visualization Logic**
  * Update data transformation logic:
    * Check any calculated columns
    * Update aggregation functions if needed
    * Test visualization rendering with new data source

### 4.5. CrowdStrike Workbook
* [ ] **Identify CommonSecurityLog_CL References**
  * Scan workbook queries:
    * Find direct CommonSecurityLog_CL references for CrowdStrike
    * Document query locations and visualization dependencies
    * Note any field dependencies

* [ ] **Update to CrowdStrikeFalconEventStream**
  * Convert each query:
    * Replace CommonSecurityLog_CL with CrowdStrikeFalconEventStream parser
    * Update field references to match new parser schema
    * Test queries with sample data

* [ ] **Validate Complex Visualizations**
  * Check advanced visualizations:
    * Test timeline and relationship visualizations
    * Verify drilldown functionality
    * Ensure entity-focused views work properly

### 4.6. Ubiquiti Workbook
* [ ] **Identify Direct Table References**
  * Scan workbook queries:
    * Find queries not using UbiquitiAuditEvent function
    * Document visualization impacts
    * Note any custom filtering logic

* [ ] **Convert to Parser Function**
  * Update each query:
    * Replace direct table references with UbiquitiAuditEvent parser
    * Adjust field references to match parser output
    * Test visualizations with updated queries

* [ ] **Fix Advanced Features**
  * Update any specialized functionality:
    * Check custom functions and calculations
    * Update drilldown links
    * Test interactive features with new data source

## 5. Hunting Query Issues
### 5.1. Parser Function References
* [ ] **Inventory Hunting Queries**
  * Identify all savedSearches resources:
    * Filter by category "Hunting Queries"
    * Document current table references
    * Group by data source type

* [ ] **Update Reference Patterns**
  * For each query group:
    * Replace direct table references with parser functions
    * Standardize query structure and patterns
    * Test updated queries against sample data

* [ ] **Document Query Purpose**
  * For each hunting query:
    * Document intended detection scenario
    * Note related MITRE ATT&CK techniques
    * Ensure query description matches updated implementation

### 5.2. KQL Syntax Verification
* [ ] **Identify Syntax Patterns**
  * Review all hunting queries:
    * Document common KQL patterns used
    * Identify potentially inefficient syntax
    * Note deprecated functions or operators

* [ ] **Standardize Query Structure**
  * Apply consistent patterns:
    * Use standard time range parameters
    * Standardize entity extraction logic
    * Apply consistent naming for projected fields

* [ ] **Optimize Query Performance**
  * Review and improve performance:
    * Add appropriate where clauses early in the query
    * Reduce unnecessary joins or complex operations
    * Test performance with larger datasets

## 6. Documentation Updates
### 6.1. InstructionSteps Updates
* [ ] **Identify Documentation References**
  * Review all instruction steps:
    * Find references to deprecated tables
    * Document affected solution templates
    * Note any screenshots needing updates

* [ ] **Update Table References**
  * For each affected instruction:
    * Replace old table names with current references
    * Update field names in examples
    * Modernize query examples with parser functions

* [ ] **Refresh Visual Guides**
  * Update any visual elements:
    * Replace screenshots showing old tables
    * Update diagrams reflecting deprecated architecture
    * Ensure consistency between text and visuals

### 6.2. DescriptionMarkdown Updates
* [ ] **Review All Description Sections**
  * Scan all description markdown:
    * Identify references to deprecated components
    * Note outdated architectural descriptions
    * Document any version-specific information

* [ ] **Update Technical Content**
  * For each affected description:
    * Update technical details to reflect current architecture
    * Replace references to old tables with parser functions
    * Refresh code samples and query examples

* [ ] **Standardize Format**
  * Apply consistent formatting:
    * Use consistent heading levels
    * Standardize code block formatting
    * Apply uniform terminology

### 6.3. AdditionalRequirementBanner Updates
* [ ] **Identify Banner Content**
  * Review all banner properties:
    * Document banners referencing deprecated features
    * Note inconsistent messaging across solutions
    * Identify out-of-date requirements

* [ ] **Update Banner Messages**
  * For each affected banner:
    * Update technical requirements
    * Remove references to deprecated components
    * Ensure accurate prerequisites

* [ ] **Standardize Messaging**
  * Apply consistent approach:
    * Use standard templates for similar banner types
    * Ensure consistent terminology
    * Apply uniform formatting

## 7. API Version Consistency
### 7.1. Resource API Versions
* [ ] **Inventory API Versions**
  * Document API versions by resource type:
    * List each resource type and current API version
    * Note latest available API versions
    * Identify resources using outdated versions

* [ ] **Update Log Analytics Resources**
  * For workspace resources:
    * Update to API version 2022-10-01 or newer
    * Document breaking changes between versions
    * Test deployment with updated versions

* [ ] **Update Microsoft.SecurityInsights Resources**
  * For SecurityInsights resources:
    * Update to API version 2023-11-01 or newer
    * Document property changes between versions
    * Test deployments with updated versions

### 7.2. Update Strategy
* [ ] **Define Version Policy**
  * Establish versioning standards:
    * Define minimum supported API versions
    * Document update cadence
    * Note version dependencies between resources

* [ ] **Document Version Dependencies**
  * Map inter-resource dependencies:
    * Identify resources that must share API versions
    * Document required property changes across versions
    * Note template sections requiring coordinated updates

* [ ] **Create Update Plan**
  * Develop staged update approach:
    * Prioritize critical resource updates
    * Group related resources for coordinated updates
    * Create testing plan for each update stage

## 8. Testing and Validation
### 8.1. Deployment Validation
* [ ] **Create Test Environments**
  * Establish testing infrastructure:
    * Deploy to isolated test subscriptions
    * Create repeatable testing process
    * Document expected deployment outcomes

* [ ] **Test All Solutions Combinations**
  * Validate different deployment options:
    * Test each solution individually
    * Test various solution combinations
    * Validate parameters and user options

* [ ] **Validate Resource Provisioning**
  * Verify all resources:
    * Check workspace and Sentinel configuration
    * Verify DCE/DCR setup
    * Validate managed identity permissions

### 8.2. Analytics Rule Validation
* [ ] **Test Rule Triggering**
  * Validate detection capabilities:
    * Inject sample data matching rule conditions
    * Verify alert generation
    * Check alert properties and severity

* [ ] **Validate Custom Details**
  * Check extraction of custom details:
    * Verify entity mapping extraction
    * Validate custom fields in alerts
    * Test dynamic content in alert details

* [ ] **Test Rule Performance**
  * Analyze query performance:
    * Measure query execution time
    * Test with various data volumes
    * Validate scheduled runs

### 8.3. Entity Correlation Validation
* [ ] **Test Entity Mapping**
  * Validate entity extraction:
    * Verify entities appear in investigation graphs
    * Test entity property extraction
    * Validate entity relationships

* [ ] **Check Investigation Experience**
  * Test investigation workflows:
    * Verify entity timeline functionality
    * Test entity exploration features
    * Validate linked entities

* [ ] **Validate Entity Enrichment**
  * Test integration with enrichment:
    * Verify entity details expansion
    * Test integration with threat intelligence
    * Validate entity insights functionality 