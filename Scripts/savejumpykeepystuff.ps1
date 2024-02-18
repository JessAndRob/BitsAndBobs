# ran for jumpy when we delete everything SQLBitsInfra so we don't lose our user settings
$keepyFolder = 'C:\Users\keepyStuff\'
$profileFolder = 'C:\Users\sqladmin.SQLBITS2024'

# clear out keepyStuff
Get-ChildItem $keepyFolder -recurse | remove-item -force -recurse

# keep things from . folders
if (Get-ChildItem ('{0}\.*' -f $profileFolder)) {
  Copy-Item ('{0}\.*' -f $profileFolder) $keepyFolder -recurse
}

# keep anything on the desktop
if (Get-ChildItem ('{0}\Desktop' -f $profileFolder)) {
  if(-not (test-path ('{0}\Desktop\*' -f $keepyFolder))) {
    New-Item ('{0}\Desktop\*' -f $keepyFolder) -Type Directory
  }
  Copy-Item ('{0}\Desktop\*' -f $profileFolder) ('{0}\Desktop\*' -f $keepyFolder) -recurse
}