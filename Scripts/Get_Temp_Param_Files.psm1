function Get_Temp_Param_Files 
{
    ##Get all temp/param files dirs from FileLocations file
    $webFileLocations = Invoke-WebRequest https://raw.githubusercontent.com/Eslam10/SentiaDeliverables_Updated/master/FileLocations_RGParameters/FileLocations.txt
    $FileLocations    = ConvertFrom-StringData -StringData $webFileLocations.Content
    
    ##Deploy on this subscription
    Get-AzureRmSubscription –SubscriptionName $FileLocations['SubscriptionName'] | Select-AzureRmSubscription 
	return $FileLocations;
}
