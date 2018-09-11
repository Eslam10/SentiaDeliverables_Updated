function Create_Policy_Assignment
{
	echo "############################################Create Policy Assignment with REST API############################################" >> C:\AzureLog_$DATE.txt;
	##Authentication and getting token for REST API
	$azContext     = Get-AzureRmContext
	$azProfile     = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
	$profileClient = New-Object -TypeName Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient -ArgumentList ($azProfile)
	$token         = $profileClient.AcquireAccessToken($azContext.Subscription.TenantId)
	$authHeader    = @{
	'Authorization'='Bearer ' + $token.AccessToken
	}
	$webBodyPALocations = Invoke-WebRequest $FileLocations['PolicyAssBody'];
	$Body_2             = $webBodyPALocations.Content;
	$RG_ID 				= (Get-AzureRmResourceGroup -Name $RG_Name).ResourceId;
	$SubID = (Get-AzureRmSubscription -SubscriptionName $FileLocations['SubscriptionName']).Id;
	
	##Update PolicyAssignment body file with RG and created policy definition IDs
	echo $Body_2 > C:\Body_PA.json;
	echo '"scope":' """$RG_ID""," >> C:\Body_PA.json;
	echo '"policyDefinitionId":' """$Resp_PD_id""" "} }" >> C:\Body_PA.json;
	$Body_3 =  Get-Content  C:\Body_PA.json;
	
	$URLPA  = "https://management.azure.com/%2Fsubscriptions%2F$SubID%2FresourceGroups%2F$RG_Name/providers/Microsoft.Authorization/policyAssignments/SentiaPA?api-version=2018-03-01"
	
	$invokeRestPA = @{
	Uri 		  = $URLPA
	Method 	  = 'Put'
	ContentType = 'application/json'
	Headers     = $authHeader
	Body        = $Body_3
	}
	
	# Invoke the REST API
	$responsePA = Invoke-RestMethod @invokeRestPA;
	if($? -eq "True")
	{
		echo "Policy Assignment successfully created" >> C:\AzureLog_$DATE.txt;
	}
	else
	{
		echo "Policy Assignment deployment failed" >> C:\AzureLog_$DATE.txt;
	}	
	$Resp_PA_id = $responsePA.id;
	
	#Remove temp file created
	Remove-Item C:\Body_PA.json;
}