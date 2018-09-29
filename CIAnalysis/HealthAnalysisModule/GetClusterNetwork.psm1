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
    Write-Host "[GetClusterNetwork] begins to be analyzed. `n"  -BackgroundColor Green
    #$analyzeObject

    #
    # Analysis Operations Here
    #

    # Screening Out 'Down' Cluster Network :
    $analyzeObject |% `
    {
        if($_.State.Value -ne "Up")
        {
            Write-Host "[Cluster Net work]" $_.Name "is" $_.State.Value -BackgroundColor Red
            $_
        }
    }

    Write-Host "[GetClusterNetwork] was analyzed. `n"  -BackgroundColor Green
}
