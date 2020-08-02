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


$ProfilePath = $env:USERPROFILE
$ToolsPath = $ProfilePath + "/.dotnet/tools"
$DotNetEbToolPath = $ToolsPath + "/dotnet-eb"
write $DotNetEbToolPath

$DotNetEbToolPathCmd = $DotNetEbToolPath + " package -cfg Build/Configuration/Prod/Aws.Deploy/" + $EbsProject + ".json"
write $DotNetEbToolPathCmd

Invoke-Expression $DotNetEbToolPathCmd

if (!$?) {
	$EXIT_CODE=1
}

Exit $EXIT_CODE