# Import Utility Function Module Script
$currentDir = Split-Path -Parent $Script:MyInvocation.MyCommand.Definition
$utilityFuncModelPath = Join-Path $currentDir "UtilityFunction.psm1"
Import-Module $utilityFuncModelPath -Force

<#
    Get Plain Text PWD From PSCredential
#>
$domainUserName = "Tom"
$domainPassWord = "123456A"
$securePword =  ConvertTo-SecureString -String $domainPassWord -AsPlainText -Force
[System.Management.Automation.PSCredential] $PSCred = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $domainUserName, $securePword
Write-Host "PlainText PWD :" $PSCred | GetPlainTextPWDFromPSCredential

<#
    Download And Extract Zip Files
#>
$zipFileRootPath = "\\ecg\azurestack\MasVP\MASCILogs\14393.0.161119-1705-MAS_ReleaseB_1.1809.0.52\3ce48536-e650-06b4-0c5b-7e09d3585c21-09-12-2018-00.23.15\Update\AzureStackLogs-20180913225257"
$targetFilePath = "C:\Users\v-jizhou\Desktop\Download"
$testName = "Storage"
$localZIPFileFullPath = DownloadAndExtractZipFiles -zipFileRootPath $zipFileRootPath -targetFilePath $targetFilePath -testName $testName -maxRetryCount 3

<#
    CMDlet Export To XML File
#>
Get-PhysicalDisk | Export-Clixml -Path "C:\Users\v-jizhou\Desktop\result.xml"
CLIXMLToPSCustomObject -cliXmlPath "C:\Users\v-jizhou\Desktop\result.xml"


<#
    Extract Zip Files To Directory
#>
$paths = "C:\Users\v-jizhou\Desktop\zip\Storage-20180505055532.zip","C:\Users\v-jizhou\Desktop\zip\Storage-part2-20180505055710.zip","C:\Users\v-jizhou\Desktop\zip\Storage-part3-20180505055812.zip","C:\Users\v-jizhou\Desktop\zip\Storage-part4-20180505055820.zip","C:\Users\v-jizhou\Desktop\zip\Storage-part5-20180505055830.zip","C:\Users\v-jizhou\Desktop\zip\Storage-part6-20180505055831.zip","C:\Users\v-jizhou\Desktop\zip\Storage-part7-20180505055845.zip"
ExtractZipFilesToDirectory -zipFilePathList $paths -destinationDirectoryName "C:\Users\v-jizhou\Desktop\zip"

<#
    Get EventLogRecords From EVTX File
#>
$eventLogRecordList = GetWindowsEventsByPath -WindowsEventPath "C:\Users\v-jizhou\Desktop\Download\Storage-20180505055532\ASRR1N22R14U01\WinEvents\Event_Microsoft-Windows-StorageSpaces-Driver-Operational.EVTX"
$eventLogRecord = $eventLogRecordList[0]

<#
    Get Value From EventLogRecord By Xpath
#>
$xpathArrayA = @("Event/EventData/Data[@Name='ID']","Event/EventData/Data[@Name='Status']")
GetValuesFromEventByXpaths -EventLogRecord $eventLogRecord -XPaths $xpathArrayA 

$xpathArrayB = @("Event/@xmlns")
GetValuesFromEventByXpaths -EventLogRecord $eventLogRecord -XPaths $xpathArrayB 

<#
    Get Value From EventLogRecord By Prefabrication Function
#>
$eventLogRecord | GetEventXMLNamespaces

$eventLogRecord | GetEventSystemNameAndGuid

$eventLogRecord | GetEventSystemEventID

$eventLogRecord | GetEventSystemVersion

$eventLogRecord | GetEventSystemLevel

$eventLogRecord | GetEventSystemTask

$eventLogRecord | GetEventSystemOpcode

$eventLogRecord | GetEventSystemKeywords

$eventLogRecord | GetEventSystemTimeCreated

$eventLogRecord | GetEventSystemEventRecordID

$eventLogRecord | GetEventSystemCorrelation

$eventLogRecord | GetEventSystemExecutionProcessIDAndThreadID

$eventLogRecord | GetEventSystemChannel

$eventLogRecord | GetEventSystemComputer

$eventLogRecord | GetEventSystemSecurity

$eventLogRecord | GetEventEventDataId

$eventLogRecord | GetEventEventDataStatus

$eventLogRecord | GetEventEventDataDeviceNumber

$eventLogRecord | GetEventEventDataDriveManufacturer

$eventLogRecord | GetEventEventDataDriveModel

$eventLogRecord | GetEventEventDataDriveSerial

$eventLogRecord | GetEventEventDataEnclosureManufacturer

$eventLogRecord | GetEventEventDataEnclosureModel

$eventLogRecord | GetEventEventDataEnclosureSerial

$eventLogRecord | GetEventEventDataSlot

<#
    Get Value From EventLogRecord Set By Filter Function
#>
$eventLogRecordList | GetEventsFromEventSetByEventId -Id 203

$eventLogRecordList | GetEventsFromEventSetByProcessId -ProcessId 10100

$eventLogRecordList | GetEventsFromEventSetByTimeCreated -StartTime ([DateTime]::Parse("5/5/2018 5:57:02 PM")) -EndTime ([DateTime]::Parse("5/5/2018 5:57:04 PM"))

$eventLogRecordList | GetEventsFromEventSetByLevelDisplayName -LevelDisplayName "Error"

$eventLogRecordList | GetEventsFromEventSetByMachineName -MachineName "ASRR1N22R14U01.n22r1401.masd.stbtest.microsoft.com"

$eventLogRecordList | GetEventsFromEventSetByProviderName -ProviderName "Microsoft-Windows-StorageSpaces-Driver"

$eventLogRecordList | GetEventsFromEventSetByProviderId -ProviderId "595F7F52-C90A-4026-A125-8EB5E083F15E"


<#
    Get CVS Content By Column Names
#>
Import-Csv -Path "C:\Users\v-jizhou\Desktop\SLB.csv" -Header "DiskId","HasSeekPenalty"

GetCsvValueByColumnNames -csvFilePath "C:\Users\v-jizhou\Desktop\SLB.csv" -columnNames "DiskId","HasSeekPenalty"

<#
    Get Content From Text log
#>
GetRegexMatchFirstResult -input $content -pattern "(?<=\[=== SBL Disks ===\])[\D\d]*?(?=(\n|$)(\r|$))"

GetTextBetweenTwoLines -LogPath $LogPath -StartLineContent "[=== SBL Disks ===]" -EndLineContent ([string]::Empty)

<#
    Get CSV Content From Text log By Title
#>
GetCSVTextFromLogFile -LogPath $LogPath -SpecifiedCSVTitle "[=== SBL Disks ===]"

GetCSVTextFromLogFileRX -LogPath $LogPath -SpecifiedCSVTitleWithoutSymbol "SBL Disks"


<#
    Parsing Specified CSV Content From Text Content
#>
$LogPath = "C:\Users\v-jizhou\Desktop\Download\Storage-part4-20180505055820\ASRR1N22R14U01\Reports\Cluster.log"

$content = GetCSVTextFromLogFileRX -LogPath $LogPath -SpecifiedCSVTitleWithoutSymbol "SBL Disks"

GetCsvValueFromTestContentByColumnNames -csvTestContent $content -columnNames "DiskId","DeviceNumber"

GetCustomObjectsFromTestContentByColumnNames -csvTestContent $content -columnNames "DiskId","DeviceNumber"


$content = GetCSVTextFromLogFileRX -LogPath $LogPath -SpecifiedCSVTitleWithoutSymbol "Volumes"

GetCsvValueFromTestContentByColumnNames -csvTestContent $content -columnNames "_friendlyName","_volumeFullName"

GetCustomObjectsFromTestContentByColumnNames -csvTestContent $content -columnNames "_friendlyName","_volumeFullName"


<#
    Create PS Custom Object
#>
$PSObject = CreatePSCustomObjectWithNoteProperty -Property ([Ordered]@{Name="Server";System="Windows Server 2016";PSVersion="4.0"})

$PSObject | AddNotePropertyIntoPSCustomObject -PropertyName "SystemDirectory" -PropertyValue "C:\WINDOWS\system32"

$PSObject | AddNotePropertiesIntoPSCustomObject -Property ([Ordered]@{"RegisteredUser"="Windows User";"BuildNumber"="17134"})


<#
    Load CLI XML And Get CI Analysis PSObject
#>
$PhysicalDiskPSObject = GetCIAnalysisPSObject -CLIXmlPath "C:\Users\v-jizhou\Desktop\Download\Storage-part3-20180505055812\ASRR1N22R14U01\StorageDiagnosticInfo\HealthTest-s-cluster-20180505-0551\GetPhysicalDisk.XML" -DownloadZipFilePathRoot "C:\Users\v-jizhou\Desktop\Download"


<#
    Load CLI XML And Get CI Analysis PSObject
#>
[string] $domainUserName = "XXXXXX@microsoft.com"
[string] $domainPassWord = "XXXXXX"
[string] $zipFileRootPath = "\\ecg\azurestack\MasVP\MASCILogs\14393.0.161119-1705-MAS_Prod_1.1810.0.22\4daec17e-6986-b3f4-2a88-86e837065bb4-10-03-2018-21.16.49\BVTResults\AzureStackLogs-20181005073849"
[string] $downloadFilePath = "C:\Users\v-jizhou\Desktop\Download"
[string] $testName = "Storage"

$securePword =  ConvertTo-SecureString -String $domainPassWord -AsPlainText -Force
[System.Management.Automation.PSCredential] $PSCred = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $domainUserName, $securePword

. "$currentDir\CLIXML.ps1" `
        -reDownload `
        -credential $PSCred `
        -zipFileRootPath $zipFileRootPath `
        -downloadFilePath $downloadFilePath `
        -testName $testName

<#
    Get CI Analysis PSObject By CLI Xml Name
#>
GetCIAnalysisPSObjectByName -CLIXmlName "GetPhysicalDisk"


<#
    Extract All Zip Files In The Specified Directory Path Recursively
#>
ExtractZipFileRecursion -zipFileRootPath "C:\Users\v-jizhou\Desktop\DownloadA"
ExtractZipFileRecursion -zipFileRootPath "C:\Users\v-jizhou\Desktop\DownloadB" -DeleteOriginalZipFile