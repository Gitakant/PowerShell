
<#
.SYNOPSIS
Update the ContactEmail tag on provided resource group
.DESCRIPTION
Script will update the ContactEmail tag on provided resource group
testing
.PARAMETER SubscriptionName - Provide the subscription where resource groups resides
    ResourceGroupName - Provide the resource group where tag needs to be updated
.EXAMPLE
.\UpdateAztag_testtt.ps1 -SubscriptionName "GITAKANT-PAYASYOUGO-BRICICI" -ResourceGroupName (get-Content -Path .\rg.csv) -ShowProgress -Verbose
#>

[CmdletBinding()]
param(
  [parameter(Mandatory=$True,
             HelpMessage="Enter the subscription name")]
  [string[]]$SubscriptionName,
  [parameter(Mandatory=$True,
             ValueFromPipeline=$True,
             ValueFromPipelineByPropertyName=$True,
             HelpMessage="Enter the resource group name")]
  [string[]]$ResourceGroupName,
  [switch]$ShowProgress
  
)

        foreach($Subscription in $SubscriptionName)
        {
        Write-Output -Message "Selecting subscription $($Subscription)"
        Select-AzSubscription -SubscriptionName $Subscription -Verbose
           
                        foreach($ResourceGroup in $ResourceGroupName)
                        {    

                            #Get RG where we need to update tag value
                            Write-Output -Message "Selecting Resource Group where we need to update tag $($ResourceGroup)"
                            $RG = Get-AzResourceGroup -Name $ResourceGroup -Verbose

                            $tags = @{"ContactEmail" = "jyotigitakantmungal@gmail.com"}

                            Write-Output -Message "Replacing the ContactEmail Tag value to bhagwatmungal@gmail.com"
                            if($tags.Count -ne 0)
                            {
                            Update-AzTag -ResourceId $RG.ResourceId -Tag $tags -Operation Merge -Verbose
                            
                            Write-Output "Tag updated successfully on " $RG.ResourceGroupName
                            }
                            else
                            {Write-Output "No tags to be updated"}
                        }

            }