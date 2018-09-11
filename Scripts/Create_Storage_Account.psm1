function Create_Storage_Account
{
	echo "############################################Create Storage Account############################################"
	echo "############################################Create Storage Account############################################" >> C:\AzureLog_$DATE.txt;
	New-AzureRmResourceGroupDeployment -ResourceGroupName $RG_Name `
	-TemplateUri $FileLocations['SAtemplate'] `
	-TemplateParameterUri $FileLocations['SAparameters'] >> C:\AzureLog_$DATE.txt;
	if($? -eq "True")
	{
		echo "Storage Account successfully created" >> C:\AzureLog_$DATE.txt;
	}
	else
	{
		echo "Storage Account deployment failed" >> C:\AzureLog_$DATE.txt;
	}	
}