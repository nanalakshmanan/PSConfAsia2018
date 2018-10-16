[CmdletBinding()]
param(
)

. "./Settings.ps1"

$AllStacks = @($EnvironmentStack)
function Get-Parameter
{
	param(
		[Parameter(Position=0)]
		[string]
		$Key,

		[Parameter(Position=1)]
		[string]
		$Value
	)
	$Param = New-Object Amazon.CloudFormation.Model.Parameter
	$Param.ParameterKey = $Key
	$Param.ParameterValue = $Value
	
	return $Param
}

function Wait-Stack
{
	param(
		[string]
		$StackName
	)
	$Status = (Get-CFNStack -StackName $StackName).StackStatus
	
	while ($Status -ne 'CREATE_COMPLETE'){
		Write-Verbose "Waiting for stack creation to complete  $StackName"
		Start-Sleep -Seconds 5
		$Status = (Get-CFNStack -StackName $StackName).StackStatus
	}
}

# create the cloud formation stacks
$contents = Get-Content ./CloudFormationTemplates/Environment.yml -Raw
$Role = Get-Parameter 'RoleName' $RoleName
$LambdaFunction = Get-Parameter 'FunctionName' $LambdaFunctionName
$InstanceProfile = Get-Parameter 'InstanceProfileName' $InstanceProfileName
$KeyPair = Get-Parameter 'KeyPairName' $KeyPairName
$AmiId = Get-Parameter 'AmiId' $WindowsAmidId
$Vpc = Get-Parameter 'VpcId' $VpcId

New-CFNStack -StackName $EnvironmentStack -TemplateBody $contents -Parameter @($InstanceProfile, $KeyPair, $AmiId, $Vpc, $Role, $LambdaFunction) -Capability CAPABILITY_NAMED_IAM

# wait for the stack creation to complete
$AllStacks | %{
	Wait-Stack -StackName $_
}

$contents = Get-Content ../Documents/Nana-BounceHostRunbook.json -Raw
New-SSMDocument -Content $contents -DocumentType Automation -Name $BounceHostName

$contents = Get-Content ../Documents/Nana-RestartNodeWithApproval.json -Raw
New-SSMDocument -Name $RestartNodeWithApprovalDoc -DocumentType Automation -TargetType '/AWS::EC2::Instance' -Content $contents

<#
# Create State manager associations
$target = New-Object Amazon.SimpleSystemsManagement.Model.Target 
$target.Key = 'tag:HRAppEnvironment'
$target.Values = 'Production'

New-SSMAssociation -AssociationName HRAppInventoryAssociation -Name AWS-GatherSoftwareInventory -Target $target -ScheduleExpression 'cron(0 */30 * ? * *)'

$AllDocs = @($BounceHostName, $RestartNodeWithApprovalDoc, $StartEC2InstanceDoc, $StartEC2WaitForRunningDoc, $CheckCTLoggingStatusDoc, $AuditCTLoggingDoc)
$YamlDocs = @($StartEC2InstanceDoc, $StartEC2WaitForRunningDoc, $CheckCTLoggingStatusDoc, $AuditCTLoggingDoc)

$YamlDocs | % {
	$contents = Get-Content "../Documents/$($_).yml" -Raw
	New-SSMDocument -Content $contents -DocumentFormat YAML -DocumentType Automation -Name $_ 
}

#>