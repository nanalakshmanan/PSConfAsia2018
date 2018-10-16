$RoleName = 'SendMailLambdaRole'
$InstanceProfileName = 'NanaSSM'
$KeyPairName = 'NanasTestKeyPair'
#ami id - us-east-1
#$WindowsAmidId = 'ami-01945499792201081'
#ami id - ap-south-1
$WindowsAmidId = 'ami-038ba93548f26cb9c'
#VPC ID for us-east-1
#$VpcId = 'vpc-9920dce0'
#VPC ID for ap-south-1
$VpcId = 'vpc-cdaedea4'
$BounceHostName = 'Nana-BounceHostRunbook'
$LambdaFunctionName = 'SendEmail'
$RestartNodeWithApprovalDoc = 'Nana-RestartNodeWithApproval'
$EnvironmentStack = 'DemoEnvironmentPSConf2018'

$RestartWindowsUpdateDoc = 'Nana-RestartWindowsUpdate'
$RestartWindowsUpdateApprovalDoc = 'Nana-RestartWindowsUpdateWithApproval'
<#$StartEC2InstanceDoc = 'Nana-StartEC2Instance'
$CheckCTLoggingStatusDoc = 'Nana-CheckCloudTrailLoggingStatus'
$AuditCTLoggingDoc = 'Nana-AuditCloudTrailLogging'
$StartEC2WaitForRunningDoc = 'Nana-StartEC2InstanceWaitForRunning'
#>