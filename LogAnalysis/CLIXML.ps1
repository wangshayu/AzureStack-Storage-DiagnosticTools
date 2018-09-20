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
$zipFileRootPath = "\\ecg\azurestack\MasVP\MASCILogs\14393.0.161119-1705-MAS_ReleaseB_1.1809.0.52\3ce48536-e650-06b4-0c5b-7e09d3585c21-09-12-2018-00.23.15\Update\AzureStackLogs-20180913225257"
$targetFilePath = "C:\Users\v-jizhou\Desktop\Download"
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
#$localZIPFileFullPath = DownloadAndExtractZipFiles -zipFileRootPath $zipFileRootPath -targetFilePath $targetFilePath -testName $testName -maxRetryCount 3

# Delete Zip Files
#Remove-Item -Path $localZIPFileFullPath -ErrorAction Ignore -Force

# Get All HealthTest.zip (Under folder StorageDiagnosticInfo)
$healthTestZipFileFullPath = GetFileNamesByPathAndExtension -path $targetFilePath -fileExtension "zip" -Recurse

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
        # Get CLI XML File Name
        $CliFilesName = GetFileNameWithoutExtension -fullFilePath $_

        # Import Health Analysis Module Script
        $modelScriptFullPath = Join-Path @(GetCurrentScriptFilePath) "HealthAnalysisModule\${CliFilesName}.psm1"
        if(-not (Test-Path -Path $modelScriptFullPath))
        {
            Write-Host "Missing Health Analysis Module Script File :" $modelScriptFullPath -BackgroundColor Red
            return $null
        }

        Import-Module $modelScriptFullPath -Force

        # Importing PS Custom Object That To Be Analyzed
        $local:analyzeObject = CLIXMLToPSCustomObject -cliXmlPath $_

        # Analysis PS Custom Object
        $Global:analysisScript.Invoke()
    }
}
