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
    Write-Host "[GetVirtualDisk] begins to be analyzed. `n"  -BackgroundColor Green
    #$analyzeObject

    #
    # Analysis Operations Here
    #

    # Screening Out 'Status Not OK and HealthStatus Not Healthy' Virtual Disk :
    $analyzeObject |% `
    {
        [CimInstance]$virtualDisk = [CimInstance]$_

        if(($virtualDisk.OperationalStatus -ne "OK") -or ($virtualDisk.HealthStatus -ne "Healthy"))
        {
            Write-Host "[Virtual Disk]" $virtualDisk.FriendlyName "'OperationalStatus' is" $virtualDisk.OperationalStatus "and 'HealthStatus' is" $virtualDisk.HealthStatus -BackgroundColor Red
            $virtualDisk
        }
    }

    Write-Host "[GetVirtualDisk] was analyzed. `n"  -BackgroundColor Green
}
