<#
    The script block be used to parsing PS custom objects.
    We can make some customized analysis operations for the PS custom objects in this script block.
    The PS custom objects is stored in the script variable '$AnalyzeObject'.
#>

Function AnalysisPSObject
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [PSCustomObject[]] $AnalyzeObject,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $DownloadFilePath
    )
      
    #
    # Preview PS Custom Object
    #
    Write-Host "[GetSmbWitness(Client)] begins to be analyzed. `n"  -BackgroundColor Green

    #
    # Analysis Operations Here
    #

    # Screening Out 'Not Connected' Smb Witness (Client) :
    $AnalyzeObject |% `
    {
        [CimInstance]$client = [CimInstance]$_

        if(($client.State -ne "Connected"))
        {
            Write-Host "[Smb Witness (Client) Name]" $client.ClientName "status is" $client.State -BackgroundColor Red
            $client
        }
    }

    Write-Host "[GetSmbWitness(Client)] was analyzed. `n"  -BackgroundColor Green
    return $null
}
