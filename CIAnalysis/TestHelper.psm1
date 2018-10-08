<#
    .Synopsis
    Get the text content between the two lines.

    .parameter StartLineContent
    Text content of the start line

    .parameter EndLineContent
    Text content of the End line
#>
Function GetTextBetweenTwoLines
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("^(?i)[\d\D]+\.[\d\D]+$")]
        [string] $LogPath,

        [Parameter(Mandatory=$false)]
        [string] $StartLineContent,

        [Parameter(Mandatory=$false)]
        [string] $EndLineContent
    )

    $content = Get-Content -Path $LogPath
    $index = $content.IndexOf($StartLineContent)
    if($index -ne -1)
    {
        $index++
    }

    [System.Text.StringBuilder] $strBuilder = [System.Text.StringBuilder]::new()
    while(($content[$index] -ne $EndLineContent) -and ($index -lt $content.Length - 1))
    {
        $strBuilder.AppendLine($content[$index++]) | Out-Null
    }

    $strBuilder.ToString()
}


<#
    .Synopsis
    Searches the specified input string for the first occurrence of the regular expression specified in the Regex constructor.

    .Return
    The first occurrence of the regular expression specified.
#>
Function GetRegexMatchFirstResult
{
    [CmdletBinding()]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $inputStr,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $pattern
    )

    [System.Text.RegularExpressions.MatchCollection] $matchCollection = [Regex]::matches($inputStr, $pattern)
    $matchCollection[0].Value
}