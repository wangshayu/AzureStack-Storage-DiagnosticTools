# Import Module Script
$currentDir = Split-Path -Parent $Script:MyInvocation.MyCommand.Definition
$testHelperModelPath = Join-Path $currentDir "TestHelper.psm1"
$fileHelperModelPath = Join-Path $currentDir "FileHelper.psm1"
$CSVHelperModelPath = Join-Path $currentDir "CSVHelper.psm1"
$eventHelperModelPath = Join-Path $currentDir "WindowsEventHelper.psm1"
$CLIHelperModelPath = Join-Path $currentDir "CLIHelper.psm1"

Import-Module $testHelperModelPath -Force
Import-Module $fileHelperModelPath -Force
Import-Module $CSVHelperModelPath -Force
Import-Module $eventHelperModelPath -Force
Import-Module $CLIHelperModelPath -Force

<#
    .Synopsis
    Get Current Script File Full Path
#>
Function GetCurrentScriptFilePath
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param()

    Split-Path -Parent $Script:MyInvocation.MyCommand.Definition
}


<#
    .Synopsis
    Create PSCustom Object For CI Analysis
#>
Function CreatePSCustomObjectForCIAnalysis
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject] $PSObject,

        [Parameter(Mandatory=$false)]
        [System.Diagnostics.Eventing.Reader.EventLogRecord[]] $EventLogRecordSet,

        [Parameter(Mandatory=$false)]
        [PSCustomObject[]] $CSVRecords,

        [Parameter(Mandatory=$false)]
        [System.Collections.Hashtable] $Property
    )

    [System.Collections.Hashtable] $local:Property = `
    @{
        "Object" = $local:PSObject;
        "WindowsEvents" = $local:EventLogRecordSet;
        "CSVRecords" = $local:CSVRecords;
        "Property" = $local:Property
    }

    $CIAnalysisPSObject = CreatePSCustomObjectWithNoteProperty -Property $local:Property
    $CIAnalysisPSObject
}


<#
    .Synopsis
    Get Zip File Path By Path And Test Name.

    The following example shows how to use :
        GetZipFilePathByPathAndTestName -zipFilePath <String> -testName <String>
#>
Function GetZipFilePathByPathAndTestName
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $zipFilePath,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $testName
    )

    return Get-ChildItem $zipFilePath |? { $_.Name.ToLower().Contains("$testName-".ToLower()) } |% { "$zipFilePath\$_" }
}


<#
    .Synopsis
    Download Zip Files By Test Name And Return Their Full Path Of Local Location

    .Description
    The DownloadZipFilesByTestName function can get the corresponding zip file through the test name prefix.

    .Return
    A Object array of download Zip files local full paths.
#>
Function DownloadZipFilesByTestName
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $zipFileRootPath,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $targetFilePath,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $testName,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateRange(1,100)]
        [int]$maxRetryCount
    )

    $zipFilePathList =  GetZipFilePathByPathAndTestName -zipFilePath $zipFileRootPath -testName $testName
    return $zipFilePathList |% `
    { 
        Write-Host "Copy Zip File From" $_ "To" $targetFilePath "`n"
        CopyFileWithRetry -sourseFilePath $_ -targetFilePath $targetFilePath -maxRetryCount $maxRetryCount | Out-Null
        "{0}\{1}" -f $targetFilePath, [System.IO.DirectoryInfo]::new($_).Name
    }
}


<#
    .Synopsis
    Download And Extract Zip Files By Test Name.

    .Description
    Download test zip files and automatically extract files to the same name folder.

    .parameter zipFileRootPath
    Specify the path to copy test zip files, where is a remote share path.

    .parameter targetFilePath
    Specify the path to the local directory in which to place the extracted files.

    .parameter testName
    Specify a test Name prefix that to determine the corresponding zip test files in the remote directory.
    e.g : "Storage" or "storage" can match "Storage-xxx.zip" and "Storage-xxx2-xxx"

    .parameter maxRetryCount
    Specify a value that number of times to download a single zip file, when downloading fails.

    .Return
    A Object array of download Zip files local full paths.
#>
Function DownloadAndExtractZipFiles
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $zipFileRootPath,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $targetFilePath,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $testName,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [int] $maxRetryCount
    )

    $zipFilePathList = DownloadZipFilesByTestName -zipFileRootPath $zipFileRootPath -targetFilePath $targetFilePath -testName $testName -maxRetryCount $maxRetryCount
    ExtractZipFilesToDirectory -zipFilePathList $zipFilePathList -destinationDirectoryName $targetFilePath
    $zipFilePathList
}