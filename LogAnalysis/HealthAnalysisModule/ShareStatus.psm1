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
    Write-Host "[ShareStatus] begins to be analyzed. `n"  -BackgroundColor Green
    #$analyzeObject

    #
    # Analysis Operations Here
    #

    # Screening Out 'Status Not Healthy' Share :
    $analyzeObject |% `
    {
        [PSCustomObject]$shareStatus = [PSCustomObject]$_

        if($shareStatus.Health -ne "Accessible")
        {
            Write-Host "[Share Status]" $shareStatus.Name "'Health' is" $shareStatus.Health  -BackgroundColor Red
            $shareStatus
        }
    }

    Write-Host "[ShareStatus] was analyzed. `n"  -BackgroundColor Green
}
