 param (
    [Parameter(Mandatory=$true)][string]$testtype
 )

. $PSScriptRoot/common.ps1

foreach ($P in $Projects.Keys ) {
	$Project = $Projects[$P]
    $Type = $Project.Type
	
	if ($Type -ne $testtype) {continue}

	if (-Not $Project.Runtime.Split(";").Contains($ActiveRuntime)) {continue}

	$Runtime = $ActiveRuntime

    $Name = $Project.Name
    $Source = $Project.Source
    $Framework = $Project.Framework
    $Configuration = $Project.Configuration
	$NetCoreSdk = $Project.NetCoreSdk
	
	
	$Tuple = "$Name.$Configuration.$Runtime.$Framework"

    $TrxFile =  $Tuple + ".trx"
    $XmlFile =  $Tuple + ".xml"
    $CoverageDataFile = $Tuple + ".coverage.xml"

    Write-Host "$testtype : $Tuple"

	if ($NetCoreSdk) {
		dotnet new globaljson --sdk-version $NetCoreSdk --force 

		$env:NetCoreSdk = $NetCoreSdk

		if (!$?) {
			$EXIT_CODE=1
			echo "dotnet new EXIT_CODE=$EXIT_CODE"
		}	
	}

    dotnet test $Source --filter $TestFilter -f $Framework -c $Configuration /p:NetCoreSdk=$NetCoreSdk --logger:"trx;LogFileName=$TrxFile" --results-directory:$TestResultsPath /p:CoverletOutputFormat=cobertura /p:CoverletOutput=$TestResultsPath$CoverageDataFile /p:CollectCoverage=true /p:ExcludeByAttribute="Obsolete%2cGeneratedCodeAttribute%2cCompilerGeneratedAttribute" -nodeReuse:false

    if (!$?) {
        $EXIT_CODE=1
		echo "dotnet test EXIT_CODE=$EXIT_CODE"
    }

    $xslt = New-Object System.Xml.Xsl.XslCompiledTransform;
    $xslt.load( "$BuildCommonPath/Xslt/trx-to-junit.xslt" )
    $xslt.Transform( $TestResultsPath + $TrxFile, $TestResultsPath + $XmlFile )
	
	if (!$?) {
		$EXIT_CODE=1
		echo "xslt EXIT_CODE=$EXIT_CODE"
	}	
}

. $PSScriptRoot/coverage.report.ps1

if (!$?) {
	$EXIT_CODE=1
	echo "coverage.report.ps1 EXIT_CODE=$EXIT_CODE"
}

echo "Exit test.ps1 with $EXIT_CODE"

Exit $EXIT_CODE