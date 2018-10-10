[CmdletBinding()]
Param
(
    [Parameter(Mandatory=$true)]
    [ValidateNotNull()]
    [System.Management.Automation.PSCredential] $credential,

    [Parameter(Mandatory=$true)]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string] $zipFileRootPath,

    [Parameter(Mandatory=$true)]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string] $downloadFilePath,

    [Parameter(Mandatory=$true)]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [string] $testName
)

# Import Utility Function Module Script
$utilityFuncModelPath = Join-Path @(Split-Path -Parent $Script:MyInvocation.MyCommand.Definition) "UtilityFunction.psm1"
Import-Module $utilityFuncModelPath -Force

# Get PlainText PWD
$domainUserName = $credential.UserName
$domainPassWord = $credential | GetPlainTextPWDFromPSCredential

# Initialization Parameter
$allCLIXMLFiles = $null
$downloadFilePath | Out-Null

# Linking Computers To Shared Resources
ConnectSharedResource -ResourceNetWorkPath $zipFileRootPath -DomainUserName $domainUserName -DomainPassWord $domainPassWord

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
$localZIPFileFullPath = DownloadAndExtractZipFiles -zipFileRootPath $zipFileRootPath -targetFilePath $downloadFilePath -testName $testName -maxRetryCount 3

# Delete Zip Files
Remove-Item -Path $localZIPFileFullPath -ErrorAction Ignore -Force

# Get All HealthTest.zip (Under folder StorageDiagnosticInfo)
$healthTestZipFileFullPath = GetFileNamesByPathAndExtension -path $downloadFilePath -fileExtension "zip" -Recurse

# Extract Every HealthTest.zip And Get All CLI XML Files
$allCLIXMLFiles = $healthTestZipFileFullPath |% `
{
    # Check and filter folders
    $filter.Invoke()

    # Extract Every HealthTest.zip
    ExtractZipFileToDirectory -sourceArchiveFileName $_ -ToCurrentDir

    # After Extract, Locate The Folder That Containing CLI XML Files.
    $CLIXMLPath = GetFileNameWithoutExtension -fullFilePath $_ -AbsolutePath

    # Get All CLI XML Files
    $CLIXMLFiles = GetFileNamesByPathAndExtension -path $CLIXMLPath -fileExtension "xml"

    # Return CLI XML Files
    $CLIXMLFiles
}

# Initialization CI Parameters
InitializationCI -AllCLIXMLFiles $allCLIXMLFiles -DownloadFilePath $downloadFilePath

# Begin To Analysis CLI XML Content
$allCLIXMLFiles |% `
{
    GetCIAnalysisPSObject -CLIXmlPath $_ -DownloadZipFilePathRoot $downloadFilePath
}