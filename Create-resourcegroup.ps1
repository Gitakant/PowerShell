function create-resourceGroup{
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
        process 
        {
            Write-Output "Resource Group provisioing will start"
            $RG= New-AzResourceGroup -ResourceGroupName $ResourceGroupName.ToUpper() -Location $Location -Tag $Tags -Verbose
            Write-Host "$($RG.ResourceGroupName) : Resource Group provisioning in $($RG.Location) location is $($RG.Location)" -ForegroundColor Green
            Write-Output "$($RG.ResourceGroupName) : Resource Group provisioned in $($RG.Location) location"
        }
}

$RGcreation = Read-Host "Do you want to create a resource group(Yes/No)"
$RGcreation.ToLower()
if($RGcreation -eq "yes" -or $RGcreation -eq "y")
{
create-resourceGroup
}
else
{"ResourceGroup is not required"}

function create-vnet{
    [CmdletBinding()]
        param(
      [parameter(Mandatory=$True,
                 ValueFromPipeline=$True,
                 ValueFromPipelineByPropertyName=$True,
                 HelpMessage="Enter the resource group name in which keyvault should be created")]
                  [string]$ResourceGroupName,
      [parameter(Mandatory=$True,
                 HelpMessage="Enter the KeyVaultName")]
                 [string]$VNETName,
      [parameter(Mandatory=$True,
                 HelpMessage="Enter the address space of virtual network")]
                 [string]$AddressSpace,
      [parameter(Mandatory=$True,
                 HelpMessage="Enter the location")]
                 [string]$Location,
      [parameter(Mandatory=$True,
                 HelpMessage="Enter the SubnetName")]
                 [string]$SubnetName,
      [parameter(Mandatory=$True,
                 HelpMessage="Enter the SubnetAddressSpace")]
                 [string]$SubnetAddressSpace,
      [parameter(Mandatory=$True,
                 HelpMessage="Enter the DNSServer")]
                 [Array]$DNSServers
  )

      


        process 
        {

            Write-Output "Provisioing of VNET will be started"
            $VNet= New-AzVirtualNetwork -ResourceGroupName $ResourceGroupName.ToUpper() -Location $Location -Name $VNETName.ToLower() -AddressPrefix $AddressSpace -ErrorAction Stop -Verbose
            Write-Output "$($VNet.name) : VNET provisioned in $($VNet.Location) location"    

                     $subnet =Add-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $SubnetAddressSpace -VirtualNetwork $VNet -ErrorAction Stop
                     Write-Output "$($SubnetName) : subnet provisioned in $($VNet.Name)"
                     $VNet | Set-AzVirtualNetwork
                    Write-Output "Updating $($VNet.Name) with $($DNSServers) as DNS servers"
                    foreach ($IP in $DNSServers)
                    {
                    $VNet.DhcpOptions.DnsServers += $IP
                    }
                    $VNet | Set-AzVirtualNetwork
                     

        }
}

$VNETcreation = Read-Host "Do you want to create a Virtul network(Yes/No)"
$VNETcreation.ToLower()
if($VNETcreation -eq "yes" -or $VNETcreation -eq "y")
{
create-vnet
}
else
{"Virtual network is not required"}


function create-keyvault{
    [CmdletBinding()]
        param(
      [parameter(Mandatory=$True,
                 ValueFromPipeline=$True,
                 ValueFromPipelineByPropertyName=$True,
                 HelpMessage="Enter the resource group name in which keyvault should be created")]
                  [string]$ResourceGroupName,
      [parameter(Mandatory=$True,
                 HelpMessage="Enter the KeyVaultName")]
                 [string]$KeyVaultName,
      [parameter(Mandatory=$True,
                 HelpMessage="Enter the location")]
                 [string]$Location
    )
        process 
        {
            Write-Output "Provisioing of KeyVault will be started"
            $KeyVault= New-AzKeyVault -ResourceGroupName $ResourceGroupName.ToUpper() -Location $Location -VaultName $KeyVaultName.ToLower() -EnabledForTemplateDeployment -EnableSoftDelete -Verbose
            Write-Output "$($KeyVault.VaultName) : KeyVault provisioned in $($KeyVault.Location) location"

            #Add access policy
            Write-Output "Adding access policy for object on KeyVault"
            $AccessPolicy = Set-AzKeyVaultAccessPolicy -VaultName $KeyVaultName.ToLower() -ObjectId '437c3a2c-3bb2-4e4d-ab90-f1f621e03c7c' `
            -PermissionsToKeys get,list,update,create,import,delete,recover,backup,restore `
            -PermissionsToSecrets get,list,set,delete,recover,backup,restore `
            -PermissionsToCertificates get,list,update,create,import,delete,recover,managecontacts,manageissuers,getissuers,listissuers,setissuers,deleteissuers `
            -Verbose
        }
}

$KVcreation = Read-Host "Do you want to create a KeyVault(Yes/No)"
$KVcreation.ToLower()
if($KVcreation -eq "yes" -or $KVcreation -eq "y")
{
create-keyvault
}
else
{"KeyVault is not required"}