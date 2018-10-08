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
    Write-Host "[GetParameters] begins to be analyzed. `n"  -BackgroundColor Green

    #
    # Analysis Operations Here
    #

    # Preview Parameters
    Write-Host "TodayDate :" $AnalyzeObject.TodayDate
    Write-Host "ExpectedNodes :" $AnalyzeObject.ExpectedNodes
    Write-Host "ExpectedVolumes :" $AnalyzeObject.ExpectedVolumes
    Write-Host "ExpectedPhysicalDisks :" $AnalyzeObject.ExpectedPhysicalDisks
    Write-Host "ExpectedPools :" $AnalyzeObject.ExpectedPools
    Write-Host "ExpectedEnclosures :" $AnalyzeObject.ExpectedEnclosures
    Write-Host "HoursOfEvents :" $AnalyzeObject.HoursOfEvents

    Write-Host "[GetParameters] was analyzed. `n"  -BackgroundColor Green
    return $null
}
