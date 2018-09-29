<#
    .Synopsis
    Imports a CLIXML file, create and return corresponding objects in PowerShell.

    .Description
    The CLIXMLToPSCustomObject imports a CLIXML file with data that represents Microsoft .NET Framework objects and creates the objects in PowerShell.

    .parameter cliXmlPath
    Specifies the CLI XML file full path.

    .Return
    A PSCustomObject array.
#>
Function CLIXMLToPSCustomObject
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("^(?i)[\d\D]+\.xml$")]
        [string] $cliXmlPath
    )

    $objs = Import-Clixml -Path $cliXmlPath
    $objs | ft | Out-Null
    return $objs
}

<#
    .Synopsis
    Create a PSCustom Object With Note Property

    .Description
    The following example shows how to use :
    $PSObject = CreatePSCustomObjectWithNoteProperty -Property ([Ordered]@{Name="Server";System="Windows Server 2016";PSVersion="4.0"})

    .parameter Property
    Specifies a OrderedDictionary object is used as the properties of the PSCustom object.
#>
Function CreatePSCustomObjectWithNoteProperty
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(Mandatory=$false)]
        [System.Collections.Hashtable] $Property
    )

    [PSCustomObject] $PSObject = New-Object "PSCustomObject" -Property $Property
    $PSObject
}


<#
    .Synopsis
    Adding a note property into a PS custom object
#>
Function AddNotePropertyIntoPSCustomObject
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject] $PSObject,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [Object] $PropertyName,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [Object] $PropertyValue
    )

    $PSObject | Add-Member -MemberType NoteProperty -Name $PropertyName -Value $PropertyValue
}


<#
    .Synopsis
    Adding multiple properties into a PS custom object

    .parameter Property
    Specifies a OrderedDictionary object is used as the properties of the PSCustom object.
#>
Function AddNotePropertiesIntoPSCustomObject
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject] $PSObject,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [System.Collections.Hashtable] $Property
    )

    $PSObject | Add-Member -NotePropertyMembers $Property
}