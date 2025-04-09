# Microsoft Sentinel Query Standardization

This document defines standardized query patterns to ensure consistency across all connectors.

## 1. General Query Structure Principles

### 1.1. Use Parser Functions Over Direct Table References

**Standard Pattern:**
```kql
// PREFERRED: Use parser function
ParserFunction
| where TimeGenerated > ago(1d)
| ... other operations

// AVOID: Direct table reference
RawTable_CL
| ... other operations
```

**Benefits:**
- Abstraction of raw data structure
- Consistent field naming
- Improved performance through optimized parsing
- Easier maintenance if raw data schema changes

### 1.2. Optimize Performance with Early Filters

**Standard Pattern:**
```kql
// PREFERRED: Early filtering
ParserFunction
| where TimeGenerated > ago(1d)
| where SeverityLevel == "Critical"
| project TimeGenerated, Computer, EventID, Message
| ... other operations

// AVOID: Late filtering
ParserFunction
| project TimeGenerated, Computer, EventID, Message
| where TimeGenerated > ago(1d)
| where SeverityLevel == "Critical"
| ... other operations
```

**Benefits:**
- Reduced data processing
- Improved query performance
- Lower resource utilization

### 1.3. Consistent Time Range Handling

**Standard Pattern:**
```kql
// PREFERRED: Use ago() function with consistent time units
ParserFunction
| where TimeGenerated > ago(1d)

// For parametrized queries
ParserFunction
| where TimeGenerated between (TimeRange:start) and (TimeRange:end)
```

**Benefits:**
- Consistent time handling
- Support for time range parameters in workbooks
- Clear intent

## 2. Specific Query Types

### 2.1. Connectivity Status Queries

**Standard Pattern:**
```kql
ParserFunction
| summarize LastLogReceived = max(TimeGenerated)
| project IsConnected = LastLogReceived > ago(30d)
```

### 2.2. Last Data Received Queries

**Standard Pattern:**
```kql
ParserFunction
| summarize Time = max(TimeGenerated)
| where isnotempty(Time)
```

### 2.3. Data Visualization Queries

**Standard Pattern:**
```kql
ParserFunction
| where TimeGenerated > ago(1d)
| where [specific filter condition]
| summarize Count = count() by Category
| top 10 by Count desc
```

## 3. Migrating to Parser Functions

### 3.1. CrowdStrike Connectors

**Current:**
```kql
RiskLogicGroup_CL
| where LogSourceType == "CrowdStrike_CL"
```

**Standard:**
```kql
CrowdStrikeFalconEventStream
```

### 3.2. Palo Alto Connectors

**Current:**
```kql
PaloAltoPrismaCloudAlert_CL
```

**Standard:**
```kql
PaloAltoPrismaCloud
| where EventType == "PaloAltoPrismaCloudAlert"
```

### 3.3. Ubiquiti Connectors

**Current:**
Already uses standard pattern with `UbiquitiAuditEvent` parser

### 3.4. Cisco ISE Connectors

**Current:**
Already uses standard pattern with `CiscoISEEvent` parser

### 3.5. PingFederate Connectors

**Current:**
Already uses standard pattern with `PingFederateEvent` parser

### 3.6. Box Connectors

**Current:**
Already uses standard pattern with `BoxEvents` parser

## 4. Implementation Steps

1. For each connector, identify queries using direct table references
2. Replace direct table references with appropriate parser functions
3. Add early filtering to optimize query performance
4. Standardize time range handling
5. Test each updated query for correctness and performance
6. Update sample queries in connector documentation
7. Update workbook queries to use standardized patterns 