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
        [PSCustomObject[]] $AnalyzeObject,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $DownloadFilePath
    )

    #
    # Preview PS Custom Object
    #
    Write-Host "[ShareStatus] begins to be analyzed. `n"  -BackgroundColor Green

    #
    # Analysis Operations Here
    #

    # Screening Out 'Status Not Healthy' Share :
    $AnalyzeObject |% `
    {
        [PSCustomObject]$shareStatus = [PSCustomObject]$_

        if($shareStatus.Health -ne "Accessible")
        {
            Write-Host "[Share Status]" $shareStatus.Name "'Health' is" $shareStatus.Health  -BackgroundColor Red
            $shareStatus
        }
    }

    Write-Host "[ShareStatus] was analyzed. `n"  -BackgroundColor Green
    return $null
}
