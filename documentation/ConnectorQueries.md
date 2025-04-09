# Microsoft Sentinel Connector Query Inventory

This document inventories all connector queries, categorizing them by connector type and function with their respective table dependencies.

## 1. CrowdStrike Connectors

### 1.1. CrowdStrike Falcon

**Base Queries:**
- **Graph Query**: 
  - Table: `RiskLogicGroup_CL` with filter `where LogSourceType == "CrowdStrike_CL"`
  - Parser: `CrowdStrikeFalconEventStream`
  - Function: Status monitoring (for connector health)

**Sample Queries:**
- "Top 10 Hosts with Detections"
  - Query: `CrowdStrikeFalconEventStream | where EventType == "DetectionSummaryEvent" | summarize count() by DstHostName | top 10 by count_`
  - Function: Data retrieval/visualization
  - Table Dependencies: Relies on parser function to transform raw data

- "Top 10 Users with Detections" 
  - Query: `CrowdStrikeFalconEventStream | where EventType == "DetectionSummaryEvent" | summarize count() by DstUserName | top 10 by count_`
  - Function: Data retrieval/visualization
  - Table Dependencies: Relies on parser function to transform raw data

**Last Data Received Query:**
- Query: `RiskLogicGroup_CL | where LogSourceType == "CrowdStrike_CL" | summarize Time = max(TimeGenerated) | where isnotempty(Time)`
- Function: Status monitoring
- Table Dependencies: `RiskLogicGroup_CL` table with filter

**Connectivity Query:**
- Query: `RiskLogicGroup_CL | where LogSourceType == "CrowdStrike_CL" | summarize LastLogReceived = max(TimeGenerated) | project IsConnected = LastLogReceived > ago(30d)`
- Function: Status monitoring
- Table Dependencies: `RiskLogicGroup_CL` table with filter

### 1.2. CrowdStrike Falcon Data Replicator

**Base Queries:**
- **Graph Query**: 
  - Table: `RiskLogicGroup_CL` with filter `where LogSourceType == "CrowdstrikeReplicator_CL"`
  - Parser: `CrowdstrikeReplicator`
  - Function: Status monitoring (for connector health)

**Sample Queries:**
- "Data Replicator - All Activities"
  - Query: `CrowdstrikeReplicator | sort by TimeGenerated desc`
  - Function: Data retrieval/exploration
  - Table Dependencies: Relies on parser function to transform raw data

**Last Data Received Query:**
- Query: `RiskLogicGroup_CL | where LogSourceType == "CrowdstrikeReplicator_CL" | summarize Time = max(TimeGenerated) | where isnotempty(Time)`
- Function: Status monitoring
- Table Dependencies: `RiskLogicGroup_CL` table with filter

**Connectivity Query:**
- Query: `RiskLogicGroup_CL | where LogSourceType == "CrowdstrikeReplicator_CL" | summarize LastLogReceived = max(TimeGenerated) | project IsConnected = LastLogReceived > ago(30d)`
- Function: Status monitoring
- Table Dependencies: `RiskLogicGroup_CL` table with filter

## 2. Palo Alto Connectors

### 2.1. Palo Alto Prisma Cloud

**Base Queries:**
- **Graph Queries**: 
  - Table: `PaloAltoPrismaCloudAlert_CL`
    - Parser: `PaloAltoPrismaCloud` (alerts)
    - Function: Status monitoring (for connector health)
  - Table: `PaloAltoPrismaCloudAudit_CL`
    - Parser: `PaloAltoPrismaCloud` (audit logs)
    - Function: Status monitoring (for connector health)

**Sample Queries:**
- "All Prisma Cloud alerts"
  - Query: `PaloAltoPrismaCloudAlert_CL | sort by TimeGenerated desc`
  - Function: Data retrieval/exploration
  - Table Dependencies: Direct table reference

- "All Prisma Cloud audit logs"
  - Query: `PaloAltoPrismaCloudAudit_CL | sort by TimeGenerated desc`
  - Function: Data retrieval/exploration
  - Table Dependencies: Direct table reference

**Last Data Received Queries:**
- For Alerts: `PaloAltoPrismaCloudAlert | summarize Time = max(TimeGenerated) | where isnotempty(Time)`
- For Audit Logs: `PaloAltoPrismaCloudAudit | summarize Time = max(TimeGenerated) | where isnotempty(Time)`
- Function: Status monitoring
- Table Dependencies: Parser function

**Connectivity Queries:**
- For Alerts: `PaloAltoPrismaCloudAlert_CL | summarize LastLogReceived = max(TimeGenerated) | project IsConnected = LastLogReceived > ago(3d)`
- For Audit Logs: `PaloAltoPrismaCloudAudit_CL | summarize LastLogReceived = max(TimeGenerated) | project IsConnected = LastLogReceived > ago(3d)`
- Function: Status monitoring
- Table Dependencies: Direct table reference

## 3. Ubiquiti Connectors

### 3.1. Ubiquiti UniFi

**Base Queries:**
- **Graph Query**: 
  - Table: Uses parser function `UbiquitiAuditEvent` 
  - Function: Status monitoring (for connector health)

**Sample Queries:**
- "Top 10 Clients (Source IP)"
  - Query: `UbiquitiAuditEvent | summarize count() by SrcIpAddr | top 10 by count_`
  - Function: Data retrieval/visualization
  - Table Dependencies: Relies on parser function to transform raw data

**Last Data Received Query:**
- Query: `UbiquitiAuditEvent | summarize Time = max(TimeGenerated) | where isnotempty(Time)`
- Function: Status monitoring
- Table Dependencies: Parser function

**Connectivity Query:**
- Query: `UbiquitiAuditEvent | summarize LastLogReceived = max(TimeGenerated) | project IsConnected = LastLogReceived > ago(30d)`
- Function: Status monitoring
- Table Dependencies: Parser function

## 4. Cisco Connectors

### 4.1. Cisco Identity Services Engine

**Base Queries:**
- **Graph Query**: 
  - Table: Uses parser function `CiscoISEEvent`
  - Function: Status monitoring (for connector health)

**Sample Queries:**
- "Top 10 Reporting Devices"
  - Query: `CiscoISEEvent | summarize count() by DvcHostname | top 10 by count_`
  - Function: Data retrieval/visualization
  - Table Dependencies: Relies on parser function to transform raw data

**Last Data Received Query:**
- Query: `CiscoISEEvent | summarize Time = max(TimeGenerated) | where isnotempty(Time)`
- Function: Status monitoring
- Table Dependencies: Parser function

**Connectivity Query:**
- Query: `CiscoISEEvent | summarize LastLogReceived = max(TimeGenerated) | project IsConnected = LastLogReceived > ago(30d)`
- Function: Status monitoring
- Table Dependencies: Parser function

## 5. PingFederate Connectors

### 5.1. PingFederate

**Base Queries:**
- **Graph Query**: 
  - Table: Uses parser function `PingFederateEvent`
  - Function: Status monitoring (for connector health)

**Sample Queries:**
- "All logs"
  - Query: `PingFederateEvent | sort by TimeGenerated`
  - Function: Data retrieval/exploration
  - Table Dependencies: Relies on parser function to transform raw data

**Last Data Received Query:**
- Query: `PingFederateEvent | summarize Time = max(TimeGenerated) | where isnotempty(Time)`
- Function: Status monitoring
- Table Dependencies: Parser function

**Connectivity Query:**
- Query: `PingFederateEvent | summarize LastLogReceived = max(TimeGenerated) | project IsConnected = LastLogReceived > ago(30d)`
- Function: Status monitoring
- Table Dependencies: Parser function

## 6. Box Connectors

### 6.1. Box

**Base Queries:**
- **Graph Query**: 
  - Table: Uses parser function `BoxEvents`
  - Function: Status monitoring (for connector health)

**Sample Queries:**
- "All Box events"
  - Query: `BoxEvents | sort by TimeGenerated desc`
  - Function: Data retrieval/exploration
  - Table Dependencies: Relies on parser function to transform raw data

**Last Data Received Query:**
- Query: `BoxEvents | summarize Time = max(TimeGenerated) | where isnotempty(Time)`
- Function: Status monitoring
- Table Dependencies: Parser function

**Connectivity Query:**
- Query: `BoxEvents | summarize LastLogReceived = max(TimeGenerated) | project IsConnected = LastLogReceived > ago(1d)`
- Function: Status monitoring
- Table Dependencies: Parser function 