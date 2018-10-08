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
    Write-Host "[GetClusterGroup] begins to be analyzed. `n"  -BackgroundColor Green

    #
    # Analysis Operations Here
    #

    # For Example, Screening Out Offline Clusters :
    $AnalyzeObject |% `
    {
        if($_.State.Value -ne "Online")
        {
            Write-Host "[Cluster]" $_.Name "is" $_.State.Value -BackgroundColor Red
            $_
        }
    }

    Write-Host "[GetClusterGroup] was analyzed. `n"  -BackgroundColor Green
    return $null
}