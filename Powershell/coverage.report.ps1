. $PSScriptRoot/common.ps1

dotnet tool update -g dotnet-reportgenerator-globaltool

if (!$?) {
	$EXIT_CODE=1
	echo "dotnet tool update EXIT_CODE=$EXIT_CODE"
}

if ($ActiveRuntime -eq "linux-x64") 
{
	echo "using reportgenerator via DotNetCliTools"

	cd $SourcePath/Build/Common/Tools
	
	dotnet restore
    
	if (!$?) {
        $EXIT_CODE=1
		echo "dotnet restore EXIT_CODE=$EXIT_CODE"
    }

    dotnet reportgenerator -reports:$TestResultsPath/*coverage*.xml -targetdir:$CodeCoveragePath$Name\ -sourcedirs:$SourcePath -assemblyfilters:$ReportGeneratorAssemblyFilters

	if (!$?) {
        $EXIT_CODE=1
		echo "dotnet reportgenerator EXIT_CODE=$EXIT_CODE"
    }

	cd $SourcePath	 
} 
else 
{
	$ReportGeneratorToolPath  = $DotNetToolsPath + "/reportgenerator.exe"
	$ReportCmd = "$($ReportGeneratorToolPath) -reports:$($TestResultsPath)/*coverage*.xml -targetdir:$($CodeCoveragePath)$($Name)\ -sourcedirs:$($SourcePath) -assemblyfilters:$($ReportGeneratorAssemblyFilters)"
    Write-Host($ReportCmd)
	
    Invoke-Expression $ReportCmd
	
    if (!$?) {
	    $EXIT_CODE=1
	    echo "ReportCmd EXIT_CODE=$EXIT_CODE"
    }
}


echo "Exit coverage.report.ps1 with $EXIT_CODE"

Exit $EXIT_CODE