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
    Write-Host "[GetStorageEnclosure] begins to be analyzed. `n"  -BackgroundColor Green
    #$analyzeObject

    #
    # Analysis Operations Here
    #

    # Screening Out 'Status Not OK and HealthStatus Not Healthy' Storage Enclosure :
    $analyzeObject |% `
    {
        [CimInstance]$enclosure = [CimInstance]$_

        if(($enclosure.OperationalStatus -ne "OK") -or ($enclosure.HealthStatus -ne "Healthy"))
        {
            Write-Host "[Storage Enclosure]" $enclosure.ClientName "'OperationalStatus' is" $enclosure.OperationalStatus "and 'HealthStatus' is" $enclosure.HealthStatus -BackgroundColor Red
            $enclosure
        }
    }

    Write-Host "[GetStorageEnclosure] was analyzed. `n"  -BackgroundColor Green
}
