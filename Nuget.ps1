# Script to scan a folder for all package.config files and collect all 
# of the packages used and write to a csv file.
# TODO: Get a Distinct List as well as one per each project
# Typically our source code is located in this directory

# Package object to hold the information about the Nuget
class Package
{
    [String]$id
    [String]$version
    [String]$targetFramework
    [String]$path
}

# Get the information we want to collect from the package.config file.
function GatherPackageInfo([string]$path) {
    $packages = @()
    [xml]$XmlDocument = Get-Content -Path $path
    Foreach($p in $XmlDocument.Packages.package) {
        $pak = New-Object Package
        $pak.id = $p.id
        $pak.version = $p.version
        $pak.targetFramework = $p.targetFramework
        $pak.path = $path
        $packages += $pak 
    }
    return $packages 
}

# Create variable to hold all the Packages
$allPackages = @()

# CHANGE THIS TO YOUR ROOT DIRECTORY WHERE THE CODE IS KEPT
$sourceFolder = 'C:\Escrow\3.12-Release\UCentra with VAMS\UCentra-3.12\Source Code\'

# recursively loop over the folders inthe sourceFolder and put the packages.config file in memory
$filesToWorkWith = Get-ChildItem -Path $sourceFolder -Filter "packages.config" -Recurse -ErrorAction SilentlyContinue -Force

# Loop over all the files (packages.config) and collect the data in each of the files for our csv output
ForEach ($file in $filesToWorkWith)
{
    $allPackages += $packages = GatherPackageInfo($file.FullName);
}

# Write all the data to a CSV file
$allPackages | export-csv -path 'C:\Escrow\3.12-Release\UCentra with VAMS\UCentra-3.12\Source Code\nugets.csv' -NoTypeInformation