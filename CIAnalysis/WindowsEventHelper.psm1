Function GetWindowsEventsByPath
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("^(?i)[\d\D]+\.EVTX$")]
        [string] $WindowsEventPath
    )

    Get-WinEvent -Path $WindowsEventPath
}


Function GetEventsFromEventSetByEventId
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord[]] $EventLogRecordSet,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [int] $Id
    )

    process
    {
         if($_.ID -eq $Id)
         {
            $_
         }
    }
}


Function GetEventsFromEventSetByProcessId
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord[]] $EventLogRecordSet,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [int] $ProcessId
    )

    process
    {
         if($_.ProcessId -eq $ProcessId)
         {
            $_
         }
    }
}


Function GetEventsFromEventSetByLevelDisplayName
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord[]] $EventLogRecordSet,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $LevelDisplayName
    )

    process
    {
         if($_.LevelDisplayName.ToLower() -eq $LevelDisplayName.ToLower())
         {
            $_
         }
    }
}


Function GetEventsFromEventSetByMachineName
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord[]] $EventLogRecordSet,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $MachineName
    )

    process
    {
         if($_.MachineName.ToLower() -eq $MachineName.ToLower())
         {
            $_
         }
    }
}


Function GetEventsFromEventSetByProviderName
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord[]] $EventLogRecordSet,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $ProviderName
    )

    process
    {
         if($_.ProviderName.ToLower() -eq $ProviderName.ToLower())
         {
            $_
         }
    }
}



Function GetEventsFromEventSetByProviderId
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord[]] $EventLogRecordSet,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $ProviderId
    )

    process
    {
         if($_.ProviderId.Guid.ToLower() -eq $ProviderId.ToLower())
         {
            $_
         }
    }
}


Function GetEventsFromEventSetByTimeCreated
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord[]] $EventLogRecordSet,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [DateTime] $StartTime,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [DateTime] $EndTime
    )

    process
    {
         if(($_.TimeCreated -le $EndTime) -and ($_.TimeCreated -ge $StartTime))
         {
            $_
         }
    }
}


Function GetValuesFromEventByXpaths
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [string[]] $XPaths
    )

    $eventLogPropertySelector = [System.Diagnostics.Eventing.Reader.EventLogPropertySelector]::new($XPaths)
    $EventLogRecord.GetPropertyValues($eventLogPropertySelector)
}


Function GetEventXMLNamespaces
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/@xmlns")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventSystemNameAndGuid
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/System/Provider/@Name","Event/System/Provider/@Guid")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventSystemEventID
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/System/EventID")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventSystemVersion
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/System/Version")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventSystemLevel
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/System/Level")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventSystemTask
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/System/Task")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventSystemOpcode
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/System/Opcode")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventSystemKeywords
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/System/Keywords")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventSystemTimeCreated
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/System/TimeCreated/@SystemTime")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventSystemEventRecordID
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/System/EventRecordID")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventSystemCorrelation
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/System/Correlation")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventSystemExecutionProcessIDAndThreadID
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/System/Execution/@ProcessID","Event/System/Execution/@ThreadID")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventSystemChannel
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/System/Channel")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventSystemComputer
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/System/Computer")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventSystemSecurity
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/System/Security")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventEventDataId
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/EventData/Data[@Name='ID']")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventEventDataStatus
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/EventData/Data[@Name='Status']")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventEventDataDeviceNumber
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/EventData/Data[@Name='DeviceNumber']")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventEventDataDriveManufacturer
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/EventData/Data[@Name='DriveManufacturer']")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventEventDataDriveModel
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/EventData/Data[@Name='DriveModel']")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventEventDataDriveSerial
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/EventData/Data[@Name='DriveSerial']")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventEventDataEnclosureManufacturer
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/EventData/Data[@Name='EnclosureManufacturer']")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventEventDataEnclosureModel
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/EventData/Data[@Name='EnclosureModel']")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventEventDataEnclosureSerial
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/EventData/Data[@Name='EnclosureSerial']")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}


Function GetEventEventDataSlot
{
    [CmdletBinding(SupportsShouldProcess=$False, ConfirmImpact="none")]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Diagnostics.Eventing.Reader.EventLogRecord] $EventLogRecord
    )

    [string[]]$xpathQueries = @("Event/EventData/Data[@Name='Slot']")
    $EventLogRecord | GetValuesFromEventByXpaths -XPaths $xpathQueries
}