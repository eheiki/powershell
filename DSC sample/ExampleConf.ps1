$data = @{
    AllNodes = @(
        @{ 
        NodeName = '*'
        }
        @{ 
        NodeName = 'server1'
        Role = 'Web'
        OSVersion = 6.3
        }
        @{ 
        NodeName = 'server2'
        Role = 'Print'
        OSVersion = 10.0
        }
    )
}
Configuration ExampleConf
{
    Import-DscResource –ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xTimeZone
    Import-DscResource -ModuleName xSMBShare

    Node $Allnodes.NodeName
    {
        xTimezone UTCTimeZone 
        {
            timeZone = 'UTC'
            IsSingleInstance = 'Yes'
        }
    
        WindowsFeature TelnetClient
        {
            Ensure = 'Absent'
            Name   = 'Telnet-Client'
        }

        File FileCopy
        {
            Ensure = 'Present'
            Type = 'Directory'
            Recurse = $true
            MatchSource = $true #all new files added to source are copied to destination. files removed from source are not removed.
            SourcePath = '\\server1\source\'
            DestinationPath = 'C:\Files'
        }
    }

    Node $AllNodes.Where({$_.Role -contains 'Web'}).NodeName
    {
        WindowsFeature WebServer
        {
            Ensure = 'Present'
            Name   = 'Web-Server'
        }

        File 'Web'
        {
            DestinationPath = 'C:\Web';
            Type = 'Directory';
        }

        xSmbShare WebSMBShare
        {
            Ensure = 'Present'
            Name   = 'WebShare'
            Path = 'C:\Web'
            Description = 'SMB Share on Web server'
            DependsOn = '[File]Web'
        }
    }

    Node $AllNodes.Where({$_.OSVersion -lt 10}).NodeName
    {
        WindowsFeature TelnetServer
        {
            Ensure = 'Absent'
            Name   = 'Telnet-Server'
        }
    }

    Node $AllNodes.Where({$_.Role -contains 'Print'}).NodeName
    {
        WindowsFeature PrintServer
        {
            Ensure = 'Present'
            Name   = 'Print-Server'
        }
    }
    Node $AllNodes.Where({$_.NodeName -contains 'server2'}).NodeName
    {

        File 'TestFolder' 
        {
            DestinationPath = 'C:\Testfolder';
            Type = 'Directory';
        }

        xSmbShare TestSMBShare
        {
            Ensure = 'Present'
            Name   = 'TestShare'
            Path = 'C:\TestFolder'
            Description = 'SMB Test share'
            DependsOn = '[File]TestFolder'      
        }
    
        Registry HideClock
        {
            Ensure      = 'Present'
            Key         = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Explorer'
            ValueName   = 'HideClock'
            ValueData   = '1'
        }
    }
}

ExampleConf2 -Configurationdata $data -OutputPath ([IO.Path]::Combine($PSScriptRoot, 'ExampleConf'))