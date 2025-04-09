# Box Workbook Direct References Analysis

This document identifies and documents all direct references to the `BoxEvents_CL` table in the Box workbook and related files.

## 1. Table References in Box Connector

Based on the examination of files in the Sentinel-playground repository, the following direct references to `BoxEvents_CL` have been identified:

### 1.1. In Parser Function

**File Location:** `ARM-Templates/LinkedTemplates/Box/mainTemplate.json`  
**Query Purpose:** Parser function that transforms `BoxEvents_CL` raw data into the `BoxEvents` schema

```kql
RiskLogicGroup_CL
| where LogSourceType == "BoxEvents_CL"
```

### 1.2. In Sample Data

**File Location:** `samples/Box/BoxEvents_CL.json`  
**Purpose:** Provides sample data for the `BoxEvents_CL` table with the following field mapping:
- Type: "BoxEvents_CL"

## 2. Key Field Dependencies

The following fields are directly referenced from the raw `BoxEvents_CL` table:

1. **RawData** - Used to extract JSON payload from raw events
2. **LogSourceType** - Used to filter "BoxEvents_CL" logs
3. **TimeGenerated** - Used for time-based queries

## 3. Current Query Structure

### 3.1. Parser Function

The current parser function maps from `BoxEvents_CL` to `BoxEvents` normalized format:

```kql
RiskLogicGroup_CL
| where LogSourceType == "BoxEvents_CL"
| extend RawDataObject = todynamic(RawData)
| extend
    // multiple field extractions from RawDataObject
| project-rename
    // field renaming operations
| extend EventType = EventOriginalType,
         AccountName = coalesce(ActorUserName, SourceName, SourceUserName),
         AccountUpn = coalesce(ActorUserUpn, SourceLogin),
         EventProduct = 'Box',
         EventVendor = 'Box',
         EventSchema = 'FileOperations',
         EventSchemaVersion = '0.1.2',
         EventResult = 'Success'
```

### 3.2. Current Usage Pattern

The current pattern is:
1. Raw data is ingested as `BoxEvents_CL`
2. All queries use the `BoxEvents` parser function
3. No direct references to `BoxEvents_CL` in workbook queries or alert rules

## 4. Standardized Pattern Assessment

The Box connector already follows the standardized pattern:

1. All connector queries use the `BoxEvents` parser function:
   - Graph Query: `BoxEvents`
   - Sample Query: `BoxEvents | sort by TimeGenerated desc`
   - Last Data Received Query: `BoxEvents | summarize Time = max(TimeGenerated) | where isnotempty(Time)`
   - Connectivity Query: `BoxEvents | summarize LastLogReceived = max(TimeGenerated) | project IsConnected = LastLogReceived > ago(1d)`

2. All alert rules use the `BoxEvents` parser function:
   - Example: `BoxEvents | where SourceItemName =~ 'id_rsa' or SourceItemName contains 'password'...`

## 5. Conclusion

The Box workbook and related components already follow the standardized query pattern, using the `BoxEvents` parser function instead of direct `BoxEvents_CL` table references. No updates are needed to the workbook queries.

The only direct reference is in the parser function itself, which is the expected and correct pattern:

```kql
RiskLogicGroup_CL
| where LogSourceType == "BoxEvents_CL"
```

No further updates are needed for the Box workbook to conform to standardized query patterns. 