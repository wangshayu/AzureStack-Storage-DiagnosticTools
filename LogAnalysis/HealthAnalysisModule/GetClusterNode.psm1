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
    Write-Host "[GetClusterNode] begins to be analyzed. `n"  -BackgroundColor Green
    #$analyzeObject

    #
    # Analysis Operations Here
    #

    # Screening Out 'Down' Cluster Nodes :
    $analyzeObject |% `
    {
        if(($_.State.Value -ne "Up") -or ($_.StatusInformation.Value -ne "Normal"))
        {
            Write-Host "[Cluster Net Node]" $_.Name "'State' is" $_.State.Value "and 'StatusInformation' is" $_.StatusInformation.Value -BackgroundColor Red
            $_
        }
    }

    Write-Host "[GetClusterNode] was analyzed. `n"  -BackgroundColor Green
}
