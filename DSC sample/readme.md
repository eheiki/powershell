# Example of Powershell DSC configuration

These two sample Powershell DSC files are for testing DSC in your own environment. Feel free to download and modify to test different configuration options.

# Prerequisites

* xTimeZone and xSMBShare Powershell modules are installed to both destination computers and to computer where you create a MOf file. 

To install modules
```powershell
Install-Module -Name xSmbShare
Install-Module -Name xTimeZone
```
Or you can get latest modules from following links and download and install manually.
[xSMBShare](https://github.com/PowerShell/xSmbShare)
[xTimeZone](https://github.com/PowerShell/xtimezone)

* Share named SOURCE on 'server1' 

Create a share named SHARE on 'server1' and add some files and folders there.

# Usage

* Download a scripts and copy them to separate folder on your computer
* Replace 'server1' and 'server2' in both scripts with your server names
* Open Powershell comand prompt and change to the folder to where you copied scripts.
* Run both scripts. As a result to subfolders should be created 'ExampleConf' and 'SetLCMConf' and in both subfolders you should see two .mof files with configurations. In 'ExampleConf' you should see 'server1.mof' and 'server2.mof' and in 'SetLCMConf' 'setver1.meta.mof' and 'server2.meta.mof'.
* To apply LCM configuration to both servers run following command
```powershell
Set-DscLocalConfigurationManager -Path .\SetLCMConf -Verbose
```
* To apply sample server configuration to both servers run following command
```powershell
Start-DscConfiguration -Path "C:\DSC\ExampleConf" -Wait -Verbose
```

For testing I user one Windows 2016 server and one Windows 2012 R2 server. Both servers had WMF 5.1 installed.