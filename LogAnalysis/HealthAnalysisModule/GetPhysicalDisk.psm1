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
    Write-Host "[GetPhysicalDisk] begins to be analyzed. `n"  -BackgroundColor Green
    #$analyzeObject

    #
    # Analysis Operations Here
    #

    # Screening Out 'Down' Physical Disk :
    $analyzeObject |% `
    {
        [CimInstance]$physicalDisk = [CimInstance]$_

        if(($physicalDisk.HealthStatus -ne "Healthy"))
        {
            Write-Host "[Physical Disk Friendly Name]" $physicalDisk.FriendlyName "health status is" $physicalDisk.HealthStatus -BackgroundColor Red
            $physicalDisk
        }
    }

    Write-Host "[GetPhysicalDisk] was analyzed. `n"  -BackgroundColor Green
}
