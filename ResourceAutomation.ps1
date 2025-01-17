
[CmdletBinding()]
param(
  [parameter(Mandatory=$True,
             ValueFromPipeline=$True,
             ValueFromPipelineByPropertyName=$True,
             HelpMessage="Enter the resource group name as per standard naming conventions")]
  [string]$ResourceGroupName,
  [parameter(Mandatory=$True,
             HelpMessage="Enter the location")]
  [string]$Location,
  [parameter(Mandatory=$True,
             HelpMessage="Enter the Portfolio")]
  [string]$Portfolio,
  [parameter(Mandatory=$True,
             HelpMessage="Enter the Environment")]
  [string]$Environment,
  [parameter(Mandatory=$True,
             HelpMessage="Provide the name of application")]
  [string]$Application,
  [parameter(Mandatory=$True,
             HelpMessage="Provide the name of project")]
  [string]$Project,
  [parameter(Mandatory=$True,
             HelpMessage="Enter the Business Criticality")]
  [string]$BusinessCriticality,
  [parameter(Mandatory=$True,
             HelpMessage="Enter classification of data as per business requirements")]
  [string]$DataClassification,
  [parameter(Mandatory=$True,
             HelpMessage="Please provide the business application owner contact")]
  [string]$ContactEmail,
  [parameter(Mandatory=$True,
             HelpMessage="Enter the value of IO number for billing")]
  [string]$BillTo,
  [parameter(Mandatory=$True,
             HelpMessage="The date on which this Resource Group was provisioned")]
  [string]$TimeProvisioned,
  #Storing in order
  [Hashtable]$Tags = [ordered]@{
    'Portfolio'=$Portfolio
    'Environment'=$Environment
    'Application'=$Application
    'Project'=$Project
    'BusinessCriticality'=$BusinessCriticality
    'DataClassification'=$DataClassification
    'ContactEmail'=$ContactEmail
    'BillTo'=$BillTo
    'TimeProvisioned'=$TimeProvisioned
    
}

)
Write-Output "Resource Group provisioing will start"
$RG= New-AzResourceGroup -ResourceGroupName $ResourceGroupName.ToUpper() -Location $Location -Tag $Tags -Verbose
Write-Host "$($RG.ResourceGroupName) : Resource Group provisioned in $($RG.Location) location" -ForegroundColor Green
Write-Output "$($RG.ResourceGroupName) : Resource Group provisioned in $($RG.Location) location"