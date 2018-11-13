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
    Write-Host "[GetVirtualDisk] begins to be analyzed. `n"  -BackgroundColor Green

    #
    # Analysis Operations Here
    #

    # Screening Out 'Status Not OK and HealthStatus Not Healthy' Virtual Disk :
    $AnalyzeObject |% `
    {
        [CimInstance]$virtualDisk = [CimInstance]$_

        if(($virtualDisk.OperationalStatus -ne "OK") -or ($virtualDisk.HealthStatus -ne "Healthy"))
        {
            Write-Host "[Virtual Disk]" $virtualDisk.FriendlyName "'OperationalStatus' is" $virtualDisk.OperationalStatus "and 'HealthStatus' is" $virtualDisk.HealthStatus -BackgroundColor Red
            $virtualDisk
        }
    }

    Write-Host "[GetVirtualDisk] was analyzed. `n"  -BackgroundColor Green
    return $null
}
