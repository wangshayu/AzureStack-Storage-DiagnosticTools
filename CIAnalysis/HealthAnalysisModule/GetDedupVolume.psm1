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
    Write-Host "[GetDedupVolume] begins to be analyzed. `n"  -BackgroundColor Green
    #$analyzeObject

    #
    # Analysis Operations Here
    #

    Write-Host "[GetDedupVolume] was analyzed. `n"  -BackgroundColor Green
}
