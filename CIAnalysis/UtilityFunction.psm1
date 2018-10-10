# Import Module Script
$currentDir = Split-Path -Parent $Script:MyInvocation.MyCommand.Definition
$testHelperModelPath = Join-Path $currentDir "TestHelper.psm1"
$fileHelperModelPath = Join-Path $currentDir "FileHelper.psm1"
$CSVHelperModelPath = Join-Path $currentDir "CSVHelper.psm1"
$eventHelperModelPath = Join-Path $currentDir "WindowsEventHelper.psm1"
$CLIHelperModelPath = Join-Path $currentDir "CLIHelper.psm1"
$PSCredentialHelperModelPath = Join-Path $currentDir "PSCredentialHelper.psm1"

Import-Module $testHelperModelPath -Force
Import-Module $fileHelperModelPath -Force
Import-Module $CSVHelperModelPath -Force
Import-Module $eventHelperModelPath -Force
Import-Module $CLIHelperModelPath -Force
Import-Module $PSCredentialHelperModelPath -Force

<#
    .Synopsis
    Get Current Script File Full Path
#>
Function GetCurrentScriptFilePath
{
    [CmdletBinding()]
    Param()

    Split-Path -Parent $Script:MyInvocation.MyCommand.Definition
}

<#
    .Synopsis
    Linking Computers To Shared Resources
#>
Function ConnectSharedResource
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $DomainUserName,

        [Parameter(Mandatory=$false)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $DomainPassWord,

        [Parameter(Mandatory=$false)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $ResourceNetWorkPath
    )

    [System.IO.DirectoryInfo] $rootPath = [System.IO.DirectoryInfo]::new($ResourceNetWorkPath)
    net use $($rootPath.Root.FullName) /user:$DomainUserName $DomainPassWord
}



<#
    .Synopsis
    Create PSCustom Object For CI Analysis
#>
Function CreatePSCustomObjectForCIAnalysis
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [PSCustomObject] $PSObject,

        [Parameter(Mandatory=$false)]
        [System.Diagnostics.Eventing.Reader.EventLogRecord[]] $EventLogRecordSet,

        [Parameter(Mandatory=$false)]
        [PSCustomObject[]] $CSVRecords,

        [Parameter(Mandatory=$false)]
        [System.Collections.Hashtable] $Property
    )

    [System.Collections.Hashtable] $local:Properties = `
    @{
        "Object" = $local:PSObject;
        "WindowsEvents" = $local:EventLogRecordSet;
        "CSVRecords" = $local:CSVRecords;
        "Property" = $local:Property
    }

    $CIAnalysisPSObject = CreatePSCustomObjectWithNoteProperty -Property $local:Properties
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
    [CmdletBinding()]
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
    [CmdletBinding()]
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
    if($zipFilePathList -eq $null)
    {
        return $null
    }

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
    [CmdletBinding()]
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
    if($zipFilePathList -ne $null)
    {
        ExtractZipFilesToDirectory -zipFilePathList $zipFilePathList -destinationDirectoryName $targetFilePath
    }
    else
    {
        Write-Host "The specified file does not exist." -ForegroundColor Red
    }
    $zipFilePathList
}

<#
    .Synopsis
    Load CLI XML And Return CI Analysis PSObject

    .parameter DownloadZipFilePathRoot
    The download Zip file path root of test log zip

    .Return
    A PSCustomObject array of CI Analysis PSObjects.
#>
Function GetCIAnalysisPSObject
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $CLIXmlPath,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $DownloadZipFilePathRoot
    )

    # Import Health Analysis Module Script
    $cliFilesName = GetFileNameWithoutExtension -fullFilePath $CLIXmlPath
    $modelScriptFullPath = Join-Path @(GetCurrentScriptFilePath) "SDDCAnalysisModule\${cliFilesName}.psm1"

    if(-not (Test-Path -Path $modelScriptFullPath))
    {
       Write-Host "Missing Health Analysis Module Script File :" $modelScriptFullPath -BackgroundColor Red
       return $null
    }

    Import-Module $modelScriptFullPath -Force

    # Importing PS Custom Object That To Be Analyzed
    $local:analyzeObject = CLIXMLToPSCustomObject -cliXmlPath $CLIXmlPath

    # Check The Content Of The CLI XML
    if($local:analyzeObject -eq $null)
    {
        Write-Host "This Is A CLI XML Without Content Or Illegality :" $CLIXmlPath -BackgroundColor Red
        return $null
    }

    # Analysis PS Custom Object
    $local:CIAnalysisPSObjectSet = AnalysisPSObject -AnalyzeObject $local:analyzeObject -DownloadFilePath $DownloadZipFilePathRoot

    # The CI Analysis PSObject results are stored in this local variable CIAnalysisPSObjectSet
    return $local:CIAnalysisPSObjectSet
}


<#
    .Synopsis
    Initialization CI Parameters
#>
Function InitializationCI
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string[]] $AllCLIXMLFiles,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $DownloadFilePath
    )

    $script:allCLIXMLFiles = $AllCLIXMLFiles
    $script:downloadFilePath = $DownloadFilePath
}


<#
    .Synopsis
    Get All CLI XML Files Full Path
#>
Function GetAllCLIXMLFiles
{
    [CmdletBinding()]
    Param()

    $script:allCLIXMLFiles
}


<#
    .Synopsis
    Load Specified CLI XML And Return CI Analysis PSObject By Xml File Name

    .Return
    A PSCustomObject array of CI Analysis PSObjects.
#>
Function GetCIAnalysisPSObjectByName
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $CLIXmlName
    )

    $targetCLIXmlFullPath = GetAllCLIXMLFiles |? `
    { 
        $fileName = GetFileNameWithoutExtension -fullFilePath $_
        $fileName.ToLower() -eq $CLIXmlName.ToLower()
    }
    
    if($targetCLIXmlFullPath -ne $null)
    {
        GetCIAnalysisPSObject -CLIXmlPath $targetCLIXmlFullPath -DownloadZipFilePathRoot $script:downloadFilePath
    }
}