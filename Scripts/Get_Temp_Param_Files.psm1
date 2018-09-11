function Get_Temp_Param_Files 
{
    ##Get all temp/param files dirs from FileLocations file
    $webFileLocations = Invoke-WebRequest https://raw.githubusercontent.com/Eslam10/Updated_Repo/master/FileLocations_RGParameters/FileLocations3.txt
    $FileLocations    = ConvertFrom-StringData -StringData $webFileLocations.Content
    
    ##Deploy on this subscription
    Get-AzureRmSubscription –SubscriptionName $FileLocations['SubscriptionName'] | Select-AzureRmSubscription 
	return $FileLocations;
}
