$data = @{
  AllNodes = @(
    @{ NodeName = 'server1'}
    @{ NodeName = 'server2'}
  )
}
Configuration SetLCMConf{
  Node $Allnodes.NodeName
  {
  LocalConfigurationManager {
    RefreshMode = 'Push'
    RebootNodeIfNeeded = $false
    ConfigurationMode = "ApplyAndAutoCorrect"
    ConfigurationModeFrequencyMins = 30
    }
  }
}
SetLCMConf2 -ConfigurationData $data -OutputPath ([IO.Path]::Combine($PSScriptRoot, "SetLCMConf"))