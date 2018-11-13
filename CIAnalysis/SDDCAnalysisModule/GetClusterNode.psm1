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
    Write-Host "[GetClusterNode] begins to be analyzed. `n"  -BackgroundColor Green

    #
    # Analysis Operations Here
    #

    # Screening Out 'Down' Cluster Nodes :
    $AnalyzeObject |% `
    {
        if(($_.State.Value -ne "Up") -or ($_.StatusInformation.Value -ne "Normal"))
        {
            Write-Host "[Cluster Net Node]" $_.Name "'State' is" $_.State.Value "and 'StatusInformation' is" $_.StatusInformation.Value -BackgroundColor Red
            $_
        }
    }

    Write-Host "[GetClusterNode] was analyzed. `n"  -BackgroundColor Green
    return $null
}
