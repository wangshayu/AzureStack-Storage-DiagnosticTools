<#
    .Synopsis
    Get the specified CSV text content from the log file.

    .Description
    This is a highly customized method for get CSV text content from log file.

    .parameter SpecifiedCSVTitle
    Text Title of CSV text content
    For example : Test '[=== SBL Disks ===]' means that can get the CSV content by '[=== SBL Disks ===]' title.
#>
Function GetCSVTextFromLogFile
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("^(?i)[\d\D]+\.[\d\D]+$")]
        [string] $LogPath,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $SpecifiedCSVTitle
    )

    GetTextBetweenTwoLines -LogPath $LogPath -StartLineContent $SpecifiedCSVTitle -EndLineContent ([string]::Empty)
}


<#
    .Synopsis
    Get the specified CSV text content from the log file.

    .Description
    This is a highly customized method for get CSV text content from log file.
    In most cases, the performance of GetCSVTextFromLogFileRX is better than that of GetCSVTextFromLogFiler.

    .parameter SpecifiedCSVTitle
    Text Title of CSV text content
    For example : Test 'SBL Disks' means that can get the CSV content by '[=== SBL Disks ===]' title.
#>
Function GetCSVTextFromLogFileRX
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("^(?i)[\d\D]+\.[\d\D]+$")]
        [string] $LogPath,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $SpecifiedCSVTitleWithoutSymbol
    )

    $content = Get-Content -Path $LogPath -Raw
    $regexPattern = "(?<=\[=== {0} ===\])[\D\d]*?(?=(\n|$)(\r|$))" -f $SpecifiedCSVTitleWithoutSymbol

    GetRegexMatchFirstResult -input $content -pattern $regexPattern
}


<#
    .Synopsis
    Get the values of the specified column of the CSV file.

    .Description
    Returns a sequence gathered in CSV columns.

    .Return
    A List`1 Type Or Object[] Type Values of columns.
#>
Function GetCsvValueByColumnNames
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("^(?i)[\d\D]+\.csv$")]
        [string] $csvFilePath,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string[]] $columnNames
    )

    [Object[]] $csv = Import-Csv -Path $csvFilePath

    [Object[]] $columns = [Object[]]::new($columnNames.Count)
    $columnIndex = 0

    $columns.ForEach(
    {
        $columns[$columnIndex++] = [System.Collections.Generic.List`1[Object]]::new()
    })

    $csv |% `
    {
        $csvRow = $_
        $columnIndex = 0

        $columnNames |% `
        {
            $columns[$columnIndex++].Add($csvRow."$_")
        }
    }

    return $columns
}

<#
    .Synopsis
    Get the values of the specified column of Test content.

    .Description
    Returns a sequence gathered in CSV columns.

    .Return
    A List`1 Type Or Object[] Type Values of columns.
#>
Function GetCsvValueFromTestContentByColumnNames
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $csvTestContent,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [string[]] $columnNames
    )

    $tempCSVFileName = "$env:SystemDrive\Windows\Temp\{0}.csv" -f [Guid]::NewGuid().ToString()
    $csvTestContent.Trim() | Out-File -FilePath $tempCSVFileName -Encoding unicode
    [System.Collections.Generic.List`1[Object]] $result = GetCsvValueByColumnNames -csvFilePath $tempCSVFileName -columnNames $columnNames
    Remove-Item -Path $tempCSVFileName -Force | Out-Null
    $result
}


<#
    .Synopsis
    Get the values of the specified column of Test content.

    .Description
    Returns a sequence gathered in CSV rows.

    .Return
    A Object[] Type Values of rows.
#>
Function GetCustomObjectsFromTestContentByColumnNames
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $csvTestContent,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [string[]] $columnNames
    )

    $tempCSVFileName = "$env:SystemDrive\Windows\Temp\{0}.csv" -f [Guid]::NewGuid().ToString()
    $csvTestContent.Trim() | Out-File -FilePath $tempCSVFileName -Encoding unicode
    $result = Import-Csv -Path $tempCSVFileName -Header $columnNames
    Remove-Item -Path $tempCSVFileName -Force | Out-Null
    $result
}