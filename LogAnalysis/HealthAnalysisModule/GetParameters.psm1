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
    Write-Host "[GetParameters] begins to be analyzed. `n"  -BackgroundColor Green
    #$analyzeObject

    #
    # Analysis Operations Here
    #

    # Preview Parameters
    Write-Host "TodayDate :" $analyzeObject.TodayDate
    Write-Host "ExpectedNodes :" $analyzeObject.ExpectedNodes
    Write-Host "ExpectedVolumes :" $analyzeObject.ExpectedVolumes
    Write-Host "ExpectedPhysicalDisks :" $analyzeObject.ExpectedPhysicalDisks
    Write-Host "ExpectedPools :" $analyzeObject.ExpectedPools
    Write-Host "ExpectedEnclosures :" $analyzeObject.ExpectedEnclosures
    Write-Host "HoursOfEvents :" $analyzeObject.HoursOfEvents

    Write-Host "[GetParameters] was analyzed. `n"  -BackgroundColor Green
}
