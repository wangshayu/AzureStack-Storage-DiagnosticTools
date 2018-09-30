<#

#>

# Import Utility Function Module Script
$utilityFuncModelPath = Join-Path @(Split-Path -Parent $Script:MyInvocation.MyCommand.Definition) "UtilityFunction.psm1"
Import-Module $utilityFuncModelPath -Force

# Linking Computers To Shared Resources
$domainUserName = "v-jizhou@microsoft.com"
$domainPassWord = "OpsMgr2008R2!"
net use \\ecg /user:$domainUserName $domainPassWord

# Download Configuration
$zipFileRootPath = "\\ecg\azurestack\MasVP\MASCILogs\14393.0.161119-1705-MAS_Prod_1.1810.0.22\fe7713e7-2c79-642c-be71-39817e58d33f-09-23-2018-18.46.33\BVTResults\AzureStackLogs-20180924212655"
$downloadFilePath = "C:\Users\v-jizhou\Desktop\Download"
$testName = "Storage"

# Second Level Zip File Selection
[ScriptBlock] $filter = `
{  
    if(-not $_.ToLower().Contains("storagediagnosticinfo"))
    {
        return
    }
    Write-Host "This is :" $_
}

# Download And Extract Zip Files
#$localZIPFileFullPath = DownloadAndExtractZipFiles -zipFileRootPath $zipFileRootPath -targetFilePath $downloadFilePath -testName $testName -maxRetryCount 3

# Delete Zip Files
#Remove-Item -Path $localZIPFileFullPath -ErrorAction Ignore -Force

# Get All HealthTest.zip (Under folder StorageDiagnosticInfo)
$healthTestZipFileFullPath = GetFileNamesByPathAndExtension -path $downloadFilePath -fileExtension "zip" -Recurse

# Extract Every HealthTest.zip And Analysis CLI XML Content
$healthTestZipFileFullPath |% `
{
    # Check and filter folders
    $filter.Invoke()

    # Extract Every HealthTest.zip
    ExtractZipFileToDirectory -sourceArchiveFileName $_ -ToCurrentDir

    # After Extract, Locate The Folder That Containing CLI XML Files.
    $CLIXMLPath = GetFileNameWithoutExtension -fullFilePath $_ -AbsolutePath

    # Get All CLI XML Files
    $CLIXMLFiles = GetFileNamesByPathAndExtension -path $CLIXMLPath -fileExtension "xml"

    # Analysis CLI XML Content
    $CLIXMLFiles |% `
    {
        $CliFilesName = GetFileNameWithoutExtension -fullFilePath $_
        GetCIAnalysisPSObject -CLIXmlPath $_ -DownloadZipFilePathRoot $downloadFilePath
    }
}
