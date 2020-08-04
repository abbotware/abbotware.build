. $PSScriptRoot/common.ps1

dotnet tool update -g Amazon.ElasticBeanstalk.Tools

if (!$?) {
	$EXIT_CODE=1
}

$AwsEbCmd =  "$($AwsEbToolPath) deploy-environment -cfg Build/Configuration/Prod/Aws.Deploy/$($EbsProject).json --version-label $($env:GO_PIPELINE_LABEL) --aws-access-key-id $($env:AWS_ACCESS_KEY_ID) --aws-secret-key $($env:AWS_SECRET_KEY)"
write $AwsEbCmd

Invoke-Expression $AwsEbCmd
if (!$?) {
	$EXIT_CODE=1
}

Exit $EXIT_CODE