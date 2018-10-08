<#
    .Synopsis
    Create PSCredential By UserName And PassWord
#>
Function CreatePSCredential
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $UserName,

        [Parameter(Mandatory=$false)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $PassWord
    )

    $SecurePword =  ConvertTo-SecureString -String $PassWord -AsPlainText -Force
    New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $UserName, $SecurePword
}


<#
    .Synopsis
    Get PlainText PassWord From PSCredential
#>
Function GetPlainTextPWDFromPSCredential
{
    [CmdletBinding()]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential] $PSCredential
    )

    [IntPtr] $local:inPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($PSCredential.Password)
    [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($local:inPtr)
}