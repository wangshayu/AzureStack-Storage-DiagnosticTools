<#
    The script block be used to parsing PS custom objects.
    We can make some customized analysis operations for the PS custom objects in this script block.
    The PS custom objects is stored in the script variable '$AnalyzeObject'.
#>

Function AnalysisPSObject
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject[]] $AnalyzeObject,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $DownloadFilePath
    )

    #
    # Preview PS Custom Object
    #
    Write-Host "[GetVolume] begins to be analyzed. `n"  -BackgroundColor Green

    #
    # Analysis Operations Here
    #

    # Screening Out 'Status Not OK and HealthStatus Not Healthy' Volume :
    $AnalyzeObject |% `
    {
        [CimInstance]$volume = [CimInstance]$_

        if(($volume.OperationalStatus -ne "OK") -or ($volume.HealthStatus -ne "Healthy"))
        {
            Write-Host "[Volume]" $volume.DriveLetter $volume.FriendlyName "'OperationalStatus' is" $volume.OperationalStatus "and 'HealthStatus' is" $volume.HealthStatus -BackgroundColor Red
            $volume
        }
    }

    Write-Host "[GetVolume] was analyzed. `n"  -BackgroundColor Green
    return $null
}
