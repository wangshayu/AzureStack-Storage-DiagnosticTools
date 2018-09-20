# Import Utility Function Module Script
$utilityFuncModelPath = Join-Path @(Split-Path -Parent $Script:MyInvocation.MyCommand.Definition) "UtilityFunction.psm1"
Import-Module $utilityFuncModelPath -Force

<#
    Download And Extract Zip Files
#>
$zipFileRootPath = "\\ecg\azurestack\MasVP\MASCILogs\14393.0.161119-1705-MAS_ReleaseB_1.1809.0.52\3ce48536-e650-06b4-0c5b-7e09d3585c21-09-12-2018-00.23.15\Update\AzureStackLogs-20180913225257"
$targetFilePath = "C:\Users\v-jizhou\Desktop\Download"
$testName = "Storage"
$localZIPFileFullPath = DownloadAndExtractZipFiles -zipFileRootPath $zipFileRootPath -targetFilePath $targetFilePath -testName $testName -maxRetryCount 3

<#
    CMDlet Export To XML File
#>
Get-PhysicalDisk | Export-Clixml -Path "C:\Users\v-jizhou\Desktop\result.xml"
CLIXMLToPSCustomObject -cliXmlPath "C:\Users\v-jizhou\Desktop\result.xml"


<#
    Extract Zip Files To Directory
#>
$paths = "C:\Users\v-jizhou\Desktop\zip\Storage-20180505055532.zip","C:\Users\v-jizhou\Desktop\zip\Storage-part2-20180505055710.zip","C:\Users\v-jizhou\Desktop\zip\Storage-part3-20180505055812.zip","C:\Users\v-jizhou\Desktop\zip\Storage-part4-20180505055820.zip","C:\Users\v-jizhou\Desktop\zip\Storage-part5-20180505055830.zip","C:\Users\v-jizhou\Desktop\zip\Storage-part6-20180505055831.zip","C:\Users\v-jizhou\Desktop\zip\Storage-part7-20180505055845.zip"
ExtractZipFilesToDirectory -zipFilePathList $paths -destinationDirectoryName "C:\Users\v-jizhou\Desktop\zip"

