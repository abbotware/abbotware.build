# NuGet API key
$apiKey = ""

# Array of package names to delist
$packageNames = @("..")
$nugetSource = "https://api.nuget.org/v3/index.json"


# Set the path to nuget.exe (Update this path to the actual location of nuget.exe on your machine)
$nugetPath = "c:\\temp\\nuget.exe"

# Check if nuget.exe exists at the specified path
if (-not (Test-Path $nugetPath)) {
    Write-Output "NuGet.exe not found at '$nugetPath'. Please check the path and try again."
    return
}

foreach ($packageName in $packageNames) {
    Write-Output "Processing package '$packageName'..."

    # Get all versions of the specified package
    try {
        $versions = (Invoke-RestMethod -Uri "https://api.nuget.org/v3-flatcontainer/$packageName/index.json").versions
    } catch {
        Write-Output "Failed to fetch versions for package '$packageName'. Skipping..."
        continue
    }

    if ($versions.Count -eq 0) {
        Write-Output "No versions found for package '$packageName'. Skipping..."
        continue
    }

    # Delist each version
    foreach ($version in $versions) {
        Write-Output "Delisting package '$packageName' version '$version'..."
        & $nugetPath delete $packageName $version -Source $nugetSource -ApiKey $apiKey -NonInteractive

        if ($LASTEXITCODE -eq 0) {
            Write-Output "Successfully delisted '$packageName' version '$version'."
        } else {
            Write-Output "Failed to delist '$packageName' version '$version'."
        }

        # Delay of 1 second between each delist operation
        Start-Sleep -Seconds 1
    }

    Write-Output "Finished processing package '$packageName'."
}

Write-Output "All specified packages have been processed."