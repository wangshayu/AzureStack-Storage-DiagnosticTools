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
    Write-Host "[GetStorageEnclosure] begins to be analyzed. `n"  -BackgroundColor Green

    #
    # Analysis Operations Here
    #

    # Screening Out 'Status Not OK and HealthStatus Not Healthy' Storage Enclosure :
    $AnalyzeObject |% `
    {
        [CimInstance]$enclosure = [CimInstance]$_

        if(($enclosure.OperationalStatus -ne "OK") -or ($enclosure.HealthStatus -ne "Healthy"))
        {
            Write-Host "[Storage Enclosure]" $enclosure.ClientName "'OperationalStatus' is" $enclosure.OperationalStatus "and 'HealthStatus' is" $enclosure.HealthStatus -BackgroundColor Red
            $enclosure
        }
    }

    Write-Host "[GetStorageEnclosure] was analyzed. `n"  -BackgroundColor Green
    return $null
}
