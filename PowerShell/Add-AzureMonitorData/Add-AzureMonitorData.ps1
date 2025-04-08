[CmdletBinding(DefaultParameterSetName = "CloudRepo")]
param (
    [Parameter(ParameterSetName = "CloudRepo")]
    [String]$RepoUri,

    [Parameter(ParameterSetName = "LocalRepo")]
    [String]$RepoDirectory,

    [Parameter(Mandatory = $true)]
    [String]$WorkspaceName,

    [Parameter(Mandatory = $false)]
    [Array]$DataProvidersArray,

    [Parameter(Mandatory = $false)]
    [String]$subscriptionId,

    [Parameter(Mandatory = $false)]
    [String]$CustomTableName = 'SecureHats',

    # New parameters for Logs Ingestion API
    [Parameter(Mandatory = $true)]
    [String]$dceUri,

    [Parameter(Mandatory = $true)]
    [String]$dcrImmutableId
)

Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

# New function to send data using Logs Ingestion API
Function Send-ToDce {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$JsonBody, # Expecting a JSON string representing an array of log entries
        
        [Parameter(Mandatory = $true)]
        [string]$DceUri, # Data Collection Endpoint URI
        
        [Parameter(Mandatory = $true)]
        [string]$DcrImmutableId, # Data Collection Rule Immutable ID
        
        [Parameter(Mandatory = $true)]
        [string]$StreamName # Name of the stream declared in the DCR (e.g., "Custom-SecureHatsStream")
    )
    
    $headers = @{ "Content-Type" = "application/json" }
    $uri = "$($DceUri)/dataCollectionRules/$($DcrImmutableId)/streams/$($StreamName)?api-version=2023-01-01"
    
    try {
        Write-Output "Sending data to DCE: $uri (Stream: $StreamName)"
        # Use -Body parameter directly with the JSON string
        $response = Invoke-RestMethod -Uri $uri -Method Post -Body $JsonBody -Headers $headers -UseDefaultCredentials # Use managed identity credentials

        Write-Output "Data successfully sent to DCE (Status: $($response.StatusCode))"
        
    } catch {
        Write-Error "Error sending data to DCE: $($_.Exception.Message)"
        Write-Error "Response: $($_.Exception.Response.GetResponseStream() | New-Object System.IO.StreamReader | %{$_.ReadToEnd()})"
    }
}

function Set-AzMonitorFunction {
    param (
        [Parameter(Mandatory = $true)]
        [String]$resourceGroupName,

        [Parameter(Mandatory = $true)]
        [String]$displayName,

        [Parameter(Mandatory = $true)]
        [String]$kqlQuery,

        [Parameter(Mandatory = $false)]
        [String]$category = 'SecureHats'

    )

    $payload = @{
        ResourceGroupName    = "$resourceGroupName"
        ResourceProviderName = 'Microsoft.OperationalInsights'
        ResourceType         = "workspaces/$($WorkspaceName)/savedSearches"
        ApiVersion           = '2022-10-01' # Updated API Version for saved searches
        Name                 = "$displayName"
        Method               = 'GET'
    }
    
    $ctx = Invoke-AzRestMethod @payload
    if ($ctx.StatusCode -ne 200) {
        New-AzOperationalInsightsSavedSearch `
            -ResourceGroupName $resourceGroupName `
            -WorkspaceName $WorkspaceName `
            -SavedSearchId $displayName `
            -DisplayName $displayName `
            -Category $category `
            -Query "$kqlQuery" `
            -FunctionAlias $displayName
    }
}

function pathBuilder {
    param (
        [Parameter(Mandatory = $true)]
        [String]$uri,

        [Parameter(Mandatory = $false)]
        [String]$provider

    )

    if ($provider) {
        if ($uri[-1] -ne '/') {
            $uri = '{0}{1}' -f $uri, '/'
        }
        $_path = '{0}{1}' -f $uri, $provider
    }
    else {
        $_path = $uri
    }

    $uriArray = $_path.Split("/")
    $gitOwner = $uriArray[3]
    $gitRepo = $uriArray[4]
    $gitPath = $uriArray[7]
    $solution = $uriArray[8]

    $apiUri = "https://api.github.com/repos/$gitOwner/$gitRepo/contents/$gitPath/$solution"

    return $apiUri
}

function processResponse {
    param (
        [Parameter(Mandatory = $true)]
        [string]$resourceGroupName,

        [Parameter(Mandatory = $true)]
        [object]$responseBody,

        # Pass DCE parameters through
        [Parameter(Mandatory = $true)]
        [string]$DceUri,

        [Parameter(Mandatory = $true)]
        [string]$DcrImmutableId,

        [Parameter(Mandatory = $true)]
        [string]$DcrStreamName
    )

    foreach ($responseObject in $responseBody) {
        if ($responseObject.type -eq 'dir') {
            # This recursive call needs to pass the DCE params too
            $nestedResponseBody = (Invoke-WebRequest (PathBuilder -uri $responseObject.html_url)).Content | ConvertFrom-Json
            Write-Output "Processing nested directory: $($responseObject.html_url)"
            processResponse -resourceGroupName $resourceGroupName -responseBody $nestedResponseBody -DceUri $DceUri -DcrImmutableId $DcrImmutableId -DcrStreamName $DcrStreamName
            # Skip processing the directory entry itself after recursion
            continue 
        }

        # Ensure we are processing file objects now
        if ($responseObject.type -ne 'file') {
            Write-Verbose "Skipping non-file object: $($responseObject.name) ($($responseObject.type))"
            continue
        }
        
        $fileObject = $responseObject # Rename for clarity

        if ($fileObject.name -like "*.csl") {
            Write-Output "Processing KQL function file: $($fileObject.name)"
            try {
                $kqlQuery = (Invoke-RestMethod -Method Get -Uri $fileObject.download_url) -replace '<CustomLog>', ($CustomTableName + '_CL')
                
                Set-AzMonitorFunction `
                    -resourceGroupName $resourceGroupName `
                    -displayName (($fileObject.name) -split "\.")[0] `
                    -kqlQuery "$($kqlQuery)"
            } catch {
                 Write-Error "Error processing KQL file $($fileObject.name): $($_.Exception.Message)"
            }
        }
        elseif ($fileObject.name -like "*.json") {
            Write-Output "Processing JSON data file: $($fileObject.name)"
            try {
                # Get the raw JSON content
                $jsonContent = Invoke-RestMethod -Method Get -Uri $fileObject.download_url

                # Ensure it's valid JSON array string for the API
                # The API expects an array of objects. If the downloaded content is a single object, wrap it in an array.
                $jsonPayloadString = $jsonContent | ConvertTo-Json -Depth 10 -Compress
                if ($jsonPayloadString -notlike '[*]') {
                    $jsonPayloadString = "[$jsonPayloadString]"
                }

                # Call the new function to send data to DCE
                Send-ToDce `
                    -JsonBody $jsonPayloadString `
                    -DceUri $DceUri `
                    -DcrImmutableId $DcrImmutableId `
                    -StreamName $DcrStreamName

            } catch {
                Write-Error "Error processing JSON file $($fileObject.name): $($_.Exception.Message)"
            }
        }
        else {
            Write-Output "Skipping file (not .csl or .json): $($fileObject.name)"
        }
    }
}

Write-Output "Script starting. Parameters: WorkspaceName=$WorkspaceName, CustomTableName=$CustomTableName, dceUri=$dceUri, dcrImmutableId=$dcrImmutableId"

# Authenticate using Managed Identity (expected within Deployment Script context)
try {
    Write-Output "Connecting to Azure using Managed Identity..."
    Connect-AzAccount -Identity
    Write-Output "Successfully connected to Azure."
    # Set context if subscriptionId is provided (though typically not needed with MI in deployment script)
    if ($subscriptionId -and ((Get-AzContext).Subscription.Id -ne $subscriptionId)) {
        Write-Output "Setting context to subscription: $subscriptionId"
        Set-AzContext -SubscriptionId $subscriptionId
    }
} catch {
    Write-Error "Failed to connect to Azure using Managed Identity: $($_.Exception.Message)" -ErrorAction Stop
}

# Module Installation Check - Keep this as a safeguard
Write-Output "Validating if required module is installed"
$AzModule = Get-InstalledModule -Name Az -ErrorAction SilentlyContinue

if ($null -eq $AzModule) {
    Write-Warning "The Az PowerShell module is not found"
    #check for Admin Privleges
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

    if (-not ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
        #Not an Admin, install to current user
        Write-Warning -Message "Can not install the Az module. You are not running as Administrator"
        Write-Warning -Message "Installing Az module to current user Scope"
        Install-Module Az -Scope CurrentUser -Force -Repository PSGallery
    }
    else {
        #Admin, install to all users
        Write-Warning -Message "Installing the Az module to all users"
        Install-Module -Name Az -Force -Repository PSGallery
        Import-Module -Name Az -Force
    }
}

# Removed redundant Get-AzContext check after Connect-AzAccount

Write-Output "Retrieving Log Analytics workspace [$($WorkspaceName)]"
try {
    $workspace = Get-AzResource `
        -Name "$WorkspaceName" `
        -ResourceType 'Microsoft.OperationalInsights/workspaces'

    Write-Output "Found workspace: $($workspace.Name) in RG: $($workspace.ResourceGroupName)"
    $ResourceGroupName = $workspace.ResourceGroupName
    # Removed $workspaceId = ... as it's no longer needed for the API call
} catch {
    Write-Error "Log Analytics workspace [$($WorkspaceName)] not found in the current context: $($_.Exception.Message)" -ErrorAction Stop
}

# Determine DCR Stream Name based on ARM template variable
$dcrStreamName = "Custom-SecureHatsStream" # Hardcoded based on DCR definition
Write-Output "Using DCR Stream Name: $dcrStreamName"

if ($DataProvidersArray) {
    $dataProviders = $DataProvidersArray | ConvertFrom-Json
    
    foreach ($provider in $dataProviders) {
        Write-Output "Processing Provider: $provider"
        $returnUri = PathBuilder -uri $RepoUri -provider $provider
        Write-Verbose "Fetching provider data from: $returnUri"

        try {
            $response = (Invoke-WebRequest $returnUri).Content | ConvertFrom-Json
            # Pass DCE/DCR info to processResponse
            processResponse -resourceGroupName $ResourceGroupName -responseBody $response -DceUri $dceUri -DcrImmutableId $dcrImmutableId -DcrStreamName $dcrStreamName
        }
        catch {
            Write-Error "No data found or error processing provider '$provider' at URI '$returnUri': $($_.Exception.Message)"
        }
    }
}
else {
    # Handle case where no specific providers are given (use base repo path?)
    # The original script seemed to require a provider in this case, which might be an error.
    # Assuming we fetch from the base repoUri if no providers specified.
    Write-Output "No specific data providers specified. Processing base RepoUri: $RepoUri"
    $returnUri = PathBuilder -uri $RepoUri # No provider specified
    Write-Verbose "Fetching base data from: $returnUri"
    try {
        $response = (Invoke-WebRequest $returnUri).Content | ConvertFrom-Json
        # Pass DCE/DCR info to processResponse
        processResponse -resourceGroupName $ResourceGroupName -responseBody $response -DceUri $dceUri -DcrImmutableId $dcrImmutableId -DcrStreamName $dcrStreamName
    }
    catch {
        Write-Error "No data found or error processing base URI '$returnUri': $($_.Exception.Message)"
    }
}

Write-Output "Script finished."
