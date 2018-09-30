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
        [ValidateNotNullOrEmpty()]
        [PSCustomObject[]] $AnalyzeObject,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string] $DownloadFilePath
    )

    #
    # Preview PS Custom Object
    #
    Write-Host "[GetPhysicalDisk] begins to be analyzed. `n"  -BackgroundColor Green

    #
    # Analysis Operations Here
    #

    #
    # Do Some Type Conversion Here.
    #
    [flagsattribute()]
    Enum PhysicalDiskUsage
    {
        Unknown      = 0
        AutoSelect   = 1
        ManualSelect = 2
        HotSpare     = 3
        Retired      = 4
        Journal      = 5
    }

    [flagsattribute()]
    Enum PhysicalDiskHealthStatus
    {
        Healthy   = 0
        Warning   = 1
        Unhealthy = 2
        Unknown   = 5
    }

    # Screening Out 'Down' Physical Disk :
    $AnalyzeObject |% `
    {
        [CimInstance]$physicalDisk = [CimInstance]$_

        if(([PhysicalDiskHealthStatus]$physicalDisk.HealthStatus -ne "Healthy"))
        {
            Write-Host "[Physical Disk Friendly Name]" $physicalDisk.FriendlyName "health status is" ([PhysicalDiskHealthStatus]$physicalDisk.HealthStatus) -BackgroundColor Red
        }
    }


    # Get All Event Files From Download File Path: 
    $EVTXFiles = GetFileNamesByPathAndExtension -path $DownloadFilePath -fileExtension "EVTX" -Recurse

    # Filter Target EVTX Files
    $targetEVTXFiles = $EVTXFiles |? { $_.ToLower().Contains("Event_Microsoft-Windows-StorageSpaces-Driver-Operational".ToLower()) }

    # Get All Record List From Target EVTX Files
    $eventLogRecordList = $targetEVTXFiles |% `
    { 
        Write-Host "Loading Event Log Record File :" $_
        GetWindowsEventsByPath -WindowsEventPath $_
    }


    # Get CSV Log From Download File Path
    $logFilePathSet = GetFileNamesByPathAndExtension -path $DownloadFilePath -fileExtension "log" -Recurse
    $SLBDiskCSVLogFiles = $logFilePathSet |? { $_.ToLower().Contains("\Cluster.log".ToLower()) }
    $AllSLBDiskCSVContentSet = $SLBDiskCSVLogFiles |% `
    {
        Write-Host "Loading CSV Text From Log File :" $_
        $csvContent = GetCSVTextFromLogFileRX -LogPath $_ -SpecifiedCSVTitleWithoutSymbol "SBL Disks"
        GetCustomObjectsFromTestContentByColumnNames -csvTestContent $csvContent -columnNames "DiskId","DiskState","HealthCounters"
    }
    
    # Analyze All PS Object Object And Return CI Analysis PS Object Models
    $CIAnalysisPSObjectSet = $analyzeObject |% `
    {
        # Get Physical Disk ID
        $objectID = GetRegexMatchFirstResult -inputStr $_.ObjectId -pattern "(?<=PD:{)[\d\D]*?(?=})" # "(?<=ObjectId=""{)[\d\D]*?(?=})"

        # Get Corresponding Events Through Physical Disk ID
        $WindowsEvents = $eventLogRecordList |? { ($_ | GetEventEventDataId).Guid.ToLower() -eq $objectID.ToLower() }

        Write-Host "Analysising PS Object :" $_ $objectID

        # Get CSV Content Through Physical Disk ID
        $SLBDiskCSVRows = $AllSLBDiskCSVContentSet |% `
        { 
            # One SLB Disk CSV Content
            if($_.DiskId.ToLower().Contains($objectID.ToLower()))
            {
                $_
            } 
        }

        $CIAnalysisPSObject = CreatePSCustomObjectForCIAnalysis -PSObject $_ -EventLogRecordSet $WindowsEvents -CSVRecords $SLBDiskCSVRows
        $CIAnalysisPSObject
    }

    Write-Host "[GetPhysicalDisk] was analyzed. `n"  -BackgroundColor Green

    # Output CI Analysis PS Object Set
    $CIAnalysisPSObjectSet
}
