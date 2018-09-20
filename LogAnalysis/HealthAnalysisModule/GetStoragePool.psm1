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
    Write-Host "[GetStoragePool] begins to be analyzed. `n"  -BackgroundColor Green
    #$analyzeObject

    #
    # Analysis Operations Here
    #

    # Screening Out 'Status Not OK and HealthStatus Not Healthy' Storage Pool :
    $analyzeObject |% `
    {
        [CimInstance]$storagePool = [CimInstance]$_

        if(($storagePool.OperationalStatus -ne "OK") -or ($storagePool.HealthStatus -ne "Healthy"))
        {
            Write-Host "[Storage Pool]" $storagePool.FriendlyName "'OperationalStatus' is" $storagePool.OperationalStatus "and 'HealthStatus' is" $storagePool.HealthStatus -BackgroundColor Red
            $storagePool
        }
    }

    Write-Host "[GetStoragePool] was analyzed. `n"  -BackgroundColor Green
}
