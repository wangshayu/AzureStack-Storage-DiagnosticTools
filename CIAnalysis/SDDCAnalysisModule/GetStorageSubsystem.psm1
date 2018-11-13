<#
    The script block be used to parsing PS custom objects.
    We can make some customized analysis operations for the PS custom objects in this script block.
    The PS custom objects is stored in the script variable '$AnalyzeObject'.
#>

Function AnalysisPSObject
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [PSCustomObject[]] $AnalyzeObject,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $DownloadFilePath
    )

    #
    # Preview PS Custom Object
    #
    Write-Host "[StorageSubSystem] begins to be analyzed. `n"  -BackgroundColor Green

    #
    # Analysis Operations Here
    #
    
    # Screening Out 'UnHealthy' Storage Sub System :
    $AnalyzeObject |% `
    {
        [CimInstance]$storageSubSystem = [CimInstance]$_

        if(($storageSubSystem.HealthStatus -ne "Healthy"))
        {
            Write-Host "[Storage Sub System Name]" $storageSubSystem.Name "health status is" $($storageSubSystem.HealthStatus) -BackgroundColor Red
        }
    }

    Write-Host "[StorageSubSystem] was analyzed. `n"  -BackgroundColor Green

    # Output CI Analysis PS Object Set
    $AnalyzeObject
}