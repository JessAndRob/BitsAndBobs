# ran for jumpy when we delete everything SQLBitsInfra so we don't lose our user settings
$keepyFolder = 'C:\Users\keepyStuff\'

# clear out keepyStuff
Get-ChildItem $keepyFolder -recurse | remove-item -force -recurse

# keep things from . folders
if (Get-ChildItem ('{0}\.*' -f $env:USERPROFILE)) {
  Copy-Item ('{0}\.*' -f $env:USERPROFILE) $keepyFolder -recurse
}

# keep anything on the desktop
if (Get-ChildItem ('{0}\Desktop' -f $env:USERPROFILE)) {
  if(-not (test-path ('{0}\Desktop\*' -f $keepyFolder))) {
    New-Item ('{0}\Desktop\*' -f $keepyFolder) -Type Directory
  }
  Copy-Item ('{0}\Desktop\*' -f $env:USERPROFILE) ('{0}\Desktop\*' -f $keepyFolder) -recurse
}