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
    Write-Host "[GetSmbWitness(Client)] begins to be analyzed. `n"  -BackgroundColor Green
    #$analyzeObject

    #
    # Analysis Operations Here
    #

    # Screening Out 'Not Connected' Smb Witness (Client) :
    $analyzeObject |% `
    {
        [CimInstance]$client = [CimInstance]$_

        if(($client.State -ne "Connected"))
        {
            Write-Host "[Smb Witness (Client) Name]" $client.ClientName "status is" $client.State -BackgroundColor Red
            $client
        }
    }

    Write-Host "[GetSmbWitness(Client)] was analyzed. `n"  -BackgroundColor Green
}
