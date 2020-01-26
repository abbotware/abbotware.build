. $PSScriptRoot/common.ps1

if (-Not (Test-Path env:\NUGET_API_KEY))
{
	Write-Host "Error NUGET_API_KEY not set"
	Exit 1
}

if (-Not (Test-Path env:\NUGET_API_KEY))
{
	Write-Host "Error NUGET_PUBLISH_URL not set"
	Exit 1
}

Write-Host "Push Nugets to $env:NUGET_PUBLISH_URL"

dotnet nuget push _Target/Release/nuget/*.nupkg -k $env:NUGET_API_KEY -s $env:NUGET_PUBLISH_URL

if (!$?) {
    $EXIT_CODE=1
}

Exit $EXIT_CODE