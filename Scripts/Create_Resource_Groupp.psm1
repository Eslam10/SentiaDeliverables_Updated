function Create_Resource_Group
{
	echo "############################################Create Resource Group############################################" >> C:\AzureLog_$DATE.txt;
	$webRGParameters  = Invoke-WebRequest $FileLocations['RGParametersFileLocation']
	$webRGTag         = Invoke-WebRequest $FileLocations['RGTagFileLocation']
	$RGParameters     = ConvertFrom-StringData -StringData $webRGParameters.Content
	$RGTag            = ConvertFrom-StringData -StringData $webRGTag.Content
	$ResourceGroupExist = Get-AzureRmResourceGroup -Name $RGParameters['Name'] -ErrorAction SilentlyContinue
	if(!$ResourceGroupExist)
	{
		New-AzureRmResourceGroup @RGParameters -Tag $RGTag -Force;
		if($? -eq "True")
		{
			echo "Resource Group [$RG_Name] successfully created" >> C:\AzureLog_$DATE.txt;
		}
		else
		{
			echo "Resource Group deployment failed" >> C:\AzureLog_$DATE.txt;
		}	
		$RG_Name = $RGParameters['Name'];
	}
	else
	{
		echo "Resource Group [$RG_Name] already exists" >> C:\AzureLog_$DATE.txt; 
	}
		return $RGParameters['Name'];
}