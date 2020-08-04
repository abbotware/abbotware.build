$ErrorActionPreference       = "Stop"

$CWD                         = (get-location).Path + "/"
$EXIT_CODE                   = 0
$MAJOR_NUMBER                = "3"
$MINOR_NUMBER                = "2"
$BUILD_NUMBER                = "1"
$REVISION_NUMBER             = "0"

$env:DOTNET_CLI_TELEMETRY_OPTOUT = 1
$env:DOTNET_SKIP_FIRST_TIME_EXPERIENCE = "true"
$env:NUGET_XMLDOC_MODE = "skip"

if (-Not (Test-Path env:\GO_PIPELINE_LABEL))
{
	Write-Host "Setting GO_PIPELINE_LABEL to default"
	Set-Item env:GO_PIPELINE_LABEL "$MAJOR_NUMBER.$MINOR_NUMBER.$BUILD_NUMBER.$REVISION_NUMBER"
	Write-Host $env:GO_PIPELINE_LABEL
}

$a = $env:GO_PIPELINE_LABEL
$PACKAGE_VERSION = ($a.Split('.')[0], $a.Split('.')[1], $a.Split('.')[2])  -join,  "."

write GO_PIPELINE_LABEL:$env:GO_PIPELINE_LABEL
write PACKAGE_VERSION:$PACKAGE_VERSION

if ([System.IO.File]::Exists($PSScriptRoot + "/../../config.ps1")) 
{
. $PSScriptRoot/../../config.ps1
}

$SourcePath			   = $CWD
Set-Item env:SourcePath $SourcePath
Write-Host "SourcePath:" $env:SourcePath

$BuildTargetPath            = $CWD + "_Target/"
Set-Item env:BuildTargetPath $BuildTargetPath
Write-Host "BuildTargetPath:" $env:BuildTargetPath

$BuildRootPath            = $CWD + "Build/"
$BuildCommonPath          = $BuildRootPath + "Common/"
$LogPath                  = $BuildTargetPath + "Logs/"
$CodeCoveragePath         = $BuildTargetPath + "CodeCoverage/"
$TestResultsPath          = $BuildTargetPath + "TestResults/"

$ProfilePath              = $env:USERPROFILE
$DotNetToolsPath          = $ProfilePath + "/.dotnet/tools"
$AwsEbToolPath            = $DotNetToolsPath + "/dotnet-eb"


if ($ENV:OS -eq "Windows_NT") {
$ActiveRuntime	       = "win-x64"
$TestFilter 		   = "Category!=linux"
} else {
$ActiveRuntime	       = "linux-x64"
$TestFilter 		   = "Category!=windows"
}

If(!(Test-Path -Path $LogPath))
{
	Write-Host "Log Folder:$LogPath - DOES NOT EXIST"
	New-Item -ItemType Directory -Force -Path $LogPath
	New-Item -ItemType File -Path $LogPath -Name empty.log -Force  -Value "test" 
} else 
{
	Write-Host "Log Folder:$LogPath - EXISTS"
	New-Item -ItemType File -Path $LogPath -Name empty.log -Force  -Value "test"
}

if (Test-Path env:\NUGET_UPGRADE_FILTER)
{
	Write-Host "NUGET_UPGRADE_FILTER:  $env:NUGET_UPGRADE_FILTER"
	$NugetUpgradeFilter = $env:NUGET_UPGRADE_FILTER
}


"Active Runtime:$ActiveRuntime"