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
    Write-Host "[GetVolume] begins to be analyzed. `n"  -BackgroundColor Green
    #$analyzeObject

    #
    # Analysis Operations Here
    #

    # Screening Out 'Status Not OK and HealthStatus Not Healthy' Volume :
    $analyzeObject |% `
    {
        [CimInstance]$volume = [CimInstance]$_

        if(($volume.OperationalStatus -ne "OK") -or ($volume.HealthStatus -ne "Healthy"))
        {
            Write-Host "[Volume]" $volume.DriveLetter $volume.FriendlyName "'OperationalStatus' is" $volume.OperationalStatus "and 'HealthStatus' is" $volume.HealthStatus -BackgroundColor Red
            $volume
        }
    }

    Write-Host "[GetVolume] was analyzed. `n"  -BackgroundColor Green
}
