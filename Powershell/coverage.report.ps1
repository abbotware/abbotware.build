. $PSScriptRoot/common.ps1

dotnet tool update -g dotnet-reportgenerator-globaltool

if (!$?) {
	$EXIT_CODE=1
	echo "EXIT_CODE=$EXIT_CODE"
}

reportgenerator "-reports:$TestResultsPath/*coverage*.xml" -targetdir:$CodeCoveragePath$Name\ "-sourcedirs:$SourcePath" -assemblyfilters:$ReportGeneratorAssemblyFilters

if (!$?) {
	$EXIT_CODE=1
	echo "EXIT_CODE=$EXIT_CODE"
}

cd $CWD 

echo "Exit coverage.report.ps1 with $EXIT_CODE"

Exit $EXIT_CODE