. $PSScriptRoot/common.ps1

# remove any existing settings
Get-ChildItem -Path $EbsProject/AppSettings/ -File | Remove-Item -Verbose

if (!$?) {
	$EXIT_CODE=1
}

# copy 'production' settings

Copy-Item -Path Build/Configuration/Prod/$EbsProject/* -Destination $EbsProject/AppSettings/ -force -Verbose

if (!$?) {
	$EXIT_CODE=1
}

dotnet tool update -g Amazon.ElasticBeanstalk.Tools

if (!$?) {
	$EXIT_CODE=1
}

dotnet tool list -g

if (!$?) {
	$EXIT_CODE=1
}

$AwsEbCmd = $AwsEbToolPath + " package -cfg Build/Configuration/Prod/Aws.Deploy/" + $EbsProject + ".json"
write $AwsEbCmd

Invoke-Expression $AwsEbCmd

if (!$?) {
	$EXIT_CODE=1
}

Exit $EXIT_CODE