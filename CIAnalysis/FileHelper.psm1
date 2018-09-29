<#
    .Synopsis
    Get File Names By Path And File Name Extension.

    .Description
    The GetFileNamesByPathAndExtension can find files with specified name extension under the path recursively, and return their full paths.

    .parameter cliXmlPath
    Specifies the CLI XML file full path.

    .Return
    A string array of file names.
#>
Function GetFileNamesByPathAndExtension
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $path,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $fileExtension,

        [Parameter(Mandatory=$false)]
        [switch]$Recurse
    )

    [string]$filter = [System.IO.Path]::Combine($path, "*.${fileExtension}")
    if($Recurse)
    {
        $files = Get-ChildItem -Path $filter -Recurse
    }
    else
    {
        $files = Get-ChildItem -Path $filter
    }

    $files |% { $_.FullName }
}



<#
    .Synopsis
    Get File Name Without Extension.

    .Description
    Get the name of the file that does not contain the extension.

    .parameter AbsolutePath
    Specifies the name of the file with full path.
#>
Function GetFileNameWithoutExtension
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $fullFilePath,

        [Parameter(Mandatory=$false)]
        [switch]$AbsolutePath
    )

    [System.IO.DirectoryInfo] $local:file = [System.IO.DirectoryInfo]::new($fullFilePath)
    if($AbsolutePath)
    {
        $local:file.FullName.Replace($local:file.Extension, [String]::Empty)
    }
    else
    {
        $local:file.Name.Replace($local:file.Extension, [String]::Empty)
    }
}


<#
    .Synopsis
    Copy File With Retry Count.

    The following example shows how to use :
         CopyFileWithRetry -sourseFilePath <String> -targetFilePath <String> -maxRetryCount <int>
#>
Function CopyFileWithRetry
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $sourseFilePath,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $targetFilePath,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateRange(1,999)]
        [int]$maxRetryCount
    )

    if(!(test-path $targetFilePath))
    {
        New-Item -path $targetFilePath -type directory -Force -ErrorAction Stop
    } 

    for([int] $i = 0; $i -lt $maxRetryCount;$i++)
    {
        xcopy $sourseFilePath $targetFilePath /Y
        if(!$?)
        {
            Write-Host $Error[0] -BackgroundColor Red
        }
        else
        {
            break
        }

        if($i -eq ($maxRetryCount - 1))
        {
            Write-Host "Fail to Copy From" $sourseFilePath "To" $targetFilePath
        }
    }
}



<#
    .Synopsis
    Call .Net CLR Method To Extract Zip File.

    .Description
    Helper function, only .Zip suffix files are supported.
#>
Function ExtractZipFileToDirectory
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("^(?i)[\d\D]+\.zip$")]
        [string] $sourceArchiveFileName,

        [Parameter(Mandatory=$false)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $destinationDirectoryName,

        [Parameter(Mandatory=$false)]
        [switch]$ToCurrentDir
    )

    try
    {
        if($ToCurrentDir)
        {
             $destinationDirectoryName = $sourceArchiveFileName.Substring(0, $sourceArchiveFileName.IndexOf("."))
        }

        Add-Type -AssemblyName 'System.IO.Compression.FileSystem'
        [IO.Compression.ZipFile]::ExtractToDirectory($sourceArchiveFileName, $destinationDirectoryName)
    }
    catch [System.Exception]
    {
        Write-Host $Error[0]
    }
}


<#
    .Synopsis
    Call .Net CLR Method To Extract Many Zip Files

    .Description
    Helper function, only .Zip suffix files are supported.
#>
Function ExtractZipFilesToDirectory
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string[]] $zipFilePathList,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $destinationDirectoryName
    )

    $zipFilePathList |% `
    { 
        $zipFileName = [System.IO.DirectoryInfo]::new($_).Name
        $zipFolderName = $zipFileName.Substring(0,$zipFileName.IndexOf("."))
        $tempDestinationDirectoryName = "$destinationDirectoryName\$zipFolderName"

        Write-Host "Extract Zip File From" $_ "To" $tempDestinationDirectoryName "`n"
        ExtractZipFileToDirectory -sourceArchiveFileName $_ -destinationDirectoryName $tempDestinationDirectoryName
    }
}