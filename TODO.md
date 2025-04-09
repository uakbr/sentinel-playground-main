# Microsoft Sentinel Playground - TODO List

## Entity Mapping Issues
* Missing entity mappings in Cisco ISE analytics rules (rules 4-10)
* Missing entity mappings in Box analytics rules (rules 3-10)
* Missing entity mappings in Ubiquiti analytics rules (all 10 rules)
* Inconsistent entity type mappings across similar rules

## Parser Updates
* CrowdStrikeFalconEventStream parser needs updating to use SecureHats_CL table
* Parser version numbers need updating after changes
* Field extraction consistency needs verification across parsers

## Data Connector References
* CrowdStrike data connector still references CommonSecurityLog_CL instead of SecureHats_CL
* Data connector display names may reference old table names
* Base queries and connectivity criteria need updates for modern tables

## Workbook Fixes
* Box workbook queries may directly reference BoxEvents_CL instead of BoxEvents parser
* CiscoISE workbook queries may reference direct tables instead of CiscoISEEvent parser
* CiscoUmbrella workbook queries may not use Cisco_Umbrella alias
* PingFederate workbook queries may reference CommonSecurityLog directly
* CrowdStrike workbook queries likely reference CommonSecurityLog_CL
* Ubiquiti workbook queries may not use UbiquitiAuditEvent function alias

## Hunting Query Issues
* Hunting queries may use direct table references instead of parser functions
* KQL syntax consistency needs verification

## Documentation Updates
* InstructionSteps references to old tables need updating
* DescriptionMarkdown sections need review for deprecated information
* AdditionalRequirementBanner properties may need updates

## API Version Consistency
* Resources may use inconsistent API versions

## Testing and Validation
* End-to-end deployment validation needed with all solutions
* Analytics rule functionality needs verification with sample data
* Entity correlation in investigations needs verification 