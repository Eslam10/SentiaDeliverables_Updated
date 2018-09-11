###################################################################################
# Author: Eslam Mahmoud
# Contact: eslamsayedattiama@gmail.com
# Creation date: September 2018
# Version 0.2
# Description: Script for Sentia company assessment "Cleanup"
###################################################################################

Import-Module "C:\Sentia\Scripts\Get_Temp_Param_Files.psm1" -Force;
$tmp = Get_Temp_Param_Files; #Return filelocations data to be used in all other modules.
$FileLocations = $tmp['1']; 
$webRGParameters  = Invoke-WebRequest $FileLocations['RGParametersFileLocation']
$webRGTag         = Invoke-WebRequest $FileLocations['RGTagFileLocation']
$RGParameters     = ConvertFrom-StringData -StringData $webRGParameters.Content
$RG_Name = $RGParameters['Name'];

$ResourceGroupExist = Get-AzureRmResourceGroup -Name $RGParameters['Name'] -ErrorAction SilentlyContinue
if($ResourceGroupExist)
{
    Get-AzureRmResourceGroup -Name $RGParameters['Name'] | Remove-AzureRmResourceGroup -Verbose -Force;
    if($? -eq "True")
    {
    	echo "Resource Group successfully Deleted";
    }
    else
    {
    	echo "Resource Group Delete failed";
    }
}
else
{
	echo "Resource Group [$RG_Name] doesn't exists";
}

Remove-AzureRmPolicyDefinition -Name $FileLocations['PolicyDefinition'] -Force;
if($? -eq "True")
{
	echo "Policy Definition successfully Deleted";
}
else
{
	echo "Policy Definition Delete failed";
}