<#
    The script block be used to parsing PS custom objects.
    We can make some customized analysis operations for the PS custom objects in this script block.
    The PS custom objects is stored in the script variable '$analyzeObject'.
#>
[ScriptBlock] $Global:analysisScript = `
{  
    #
    # Preview PS Custom Object
    #
    Write-Host "[GetClusterResource] begins to be analyzed. `n"  -BackgroundColor Green
    #$analyzeObject

    #
    # Analysis Operations Here
    #

    # Screening Out 'Down' Cluster Nodes :
    $analyzeObject |% `
    {
        if(($_.State.Value -ne "Online"))
        {
            Write-Host "[Cluster Resource]" $_.Name "is" $_.State.Value -BackgroundColor Red
            $_
        }
    }

    Write-Host "[GetClusterResource] was analyzed. `n"  -BackgroundColor Green
}
