. $PSScriptRoot/common.ps1

echo "$BuildCommonPath\Msbuild.props\Abbotware.Settings.Metadata.props"
Get-Content "$BuildCommonPath\Msbuild.props\Abbotware.Settings.Metadata.props" | foreach {Write-Output $_}

foreach ($P in $Projects.Keys ) {
	$Project = $Projects[$P]
    $Type = $Project.Type
	
	if ($Type -ne "build") {continue}

    $Name = $Project.Name
    $Action = $Project.Action
    $Source = $Project.Source
    $Framework = $Project.Framework
    $Runtime = $Project.Runtime
    $Configuration = $Project.Configuration
	$Tuple = "$Name.$Configuration.$Runtime.$Framework"
	
	$Output = "$BuildTargetPath$Configuration\$Runtime\$Framework\$Name\"
	$BaseLogFile = "$LogPath$Tuple"
	
	$WarningsLogFile = "$LogPath$Tuple" + ".warnings.txt"
	$ErrorsLogFile = "$LogPath$Tuple" + ".errors.txt"
	
	if ($Action -eq "publish") 
	{
		Write-Host "Publish: $Tuple) to $Output"
		dotnet publish $Source -c $Configuration -r $Runtime -f $Framework -o $Output -flp1:logfile=$ErrorsLogFile -flp1:errorsonly -flp2:logfile=$WarningsLogFile -flp2:warningsonly
	}

	if ($Action -eq "build") 
	{
		Write-Host "Build: $Tuple)"
		dotnet build $Source -c $Configuration -flp1:logfile=$ErrorsLogFile -flp1:errorsonly -flp2:logfile=$WarningsLogFile -flp2:warningsonly
	}

	if (!$?) {
		$EXIT_CODE=1
	}
}

echo "Exit build.ps1 with $EXIT_CODE"

Exit $EXIT_CODE