[CmdletBinding()]
param(
)
. "./Settings.ps1"

$AllStacks = @($EnvironmentStack)
function Wait-Stack
{
	param(
		[string]
		$StackName
	)
	while(Test-CFNStack -StackName $StackName){
		Write-Verbose "Waiting for Stack $StackName to be deleted"
		Start-Sleep -Seconds 3
	}
}
$AllStacks | % {
	if (Test-CFNStack -StackName $_){
		Remove-CFNStack -StackName $_ -Force
	}
}

$AllStacks | % {
	Wait-Stack -StackName $_
}
$CommandDocs = @($RestartWindowsUpdateDoc, $GetCredentialDoc, $ConfigureServicesDoc, $DscComplianceDoc, $RestartServiceCommandDoc)

$CommandDocs | % {
	Remove-SSMDocument -Name $_ -Force
}

$AutomationDocs = @($RestartWindowsUpdateApprovalDoc, $RestartServiceDoc)

$AutomationDocs | % {
	Remove-SSMDocument -Name $_ -Force
}
Get-SSMAssociationList | foreach AssociationId | %{Remove-SSMAssociation -AssociationId $_ -Force}


# Remove SSM Parameters
Remove-SSMParameter -Name "DBString" -Force

Remove-SSMParameter -Name "DBPassword" -Force

aws ssm delete-inventory --type-name 'Custom:DscCompliance' --schema-delete-option DeleteSchema