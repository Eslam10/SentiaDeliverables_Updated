function Create_Policy_Definition
{
	echo "############################################Create Policy Definition With REST API############################################" >> C:\AzureLog_$DATE.txt
	##Authentication and getting token for REST API
	$azContext     = Get-AzureRmContext
	$azProfile     = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
	$profileClient = New-Object -TypeName Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient -ArgumentList ($azProfile)
	$token         = $profileClient.AcquireAccessToken($azContext.Subscription.TenantId)
	$authHeader    = @{
	'Authorization'='Bearer ' + $token.AccessToken
	}
	$SubID = (Get-AzureRmSubscription -SubscriptionName $FileLocations['SubscriptionName']).Id; #To be used in URLPD
	$URLPD   = "https://management.azure.com/subscriptions/$SubID/providers/Microsoft.Authorization/policyDefinitions/SentiaPD?api-version=2018-03-01";
	
	$webBodyPDLocations = Invoke-WebRequest $FileLocations['PolicyDefBody'];
	$Body_1             = $webBodyPDLocations.Content;
	
	$invokeRestPD = @{
	Uri         = $URLPD
	Method      = 'Put'
	ContentType = 'application/json'
	Headers     = $authHeader
	Body        = $Body_1
	}
	
	# Invoke the REST API
	$responsePD = Invoke-RestMethod @invokeRestPD;
	if($? -eq "True")
	{
		echo "Policy Definition successfully created" >> C:\AzureLog_$DATE.txt;
	}
	else
	{
		echo "Policy Definition deployment failed" >> C:\AzureLog_$DATE.txt;
	}	
	
	$Resp_PD_id = $responsePD.id; #To be used in created Policy assignment based on this policy definition
	
	return $Resp_PD_id;
}