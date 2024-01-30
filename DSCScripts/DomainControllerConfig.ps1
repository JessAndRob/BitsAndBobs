configuration DomainControllerConfig
{
    param
    (    
        [Parameter(mandatory = $true)]
        [System.Management.Automation.PSCredential]$creds,
        [Parameter(mandatory = $true)]
        [string]$domain,
        [Parameter(mandatory = $true)]
        [string]$newForest,
        [Parameter(mandatory = $false)]
        [string]$site
    )
    
    Import-DscResource -ModuleName PsDesiredStateConfiguration 
    node localhost
    {
        WindowsFeature ADDSInstall {
            Ensure               = 'Present'
            Name                 = 'AD-Domain-Services'
            IncludeAllSubFeature = $true
        }
    
        #Script SetupDisk {
        #    DependsOn = "[WindowsFeature]ADDSInstall"
        #    GetScript  = {
        #        return @{'Result' = '' }
        #    }
        #    SetScript  = {
        #        $disk = Get-Disk -Number 2
        #        New-Volume -Disk $disk -FileSystem NTFS -DriveLetter N -FriendlyName "NTDS"
        #        $disk = Get-Disk -Number 3
        #        New-Volume -Disk $disk -FileSystem NTFS -DriveLetter S -FriendlyName "SYSVOL"
        #    }
        
        
        #    TestScript = {
        #        return ((Get-Volume -DriveLetter N -ErrorAction SilentlyContinue) -ne $null)
        #    }
        #}
    
        Script DCPromo {
            GetScript  = {
                return @{'Result' = '' }
            }
            SetScript  = {
                
                #$securepassword = ConvertTo-SecureString -String $using:password -AsPlainText -Force
                $domainCredential = $using:creds
                if((Get-Item -Path "C:\NTDS" -ErrorAction SilentlyContinue) -eq $null)
                {
                    New-Item -Path "C:\NTDS" -ItemType Directory;
                }
                if((Get-Item -Path "C:\SYSVOL" -ErrorAction SilentlyContinue) -eq $null)
                {
                    New-Item -Path "C:\SYSVOL" -ItemType Directory;
                }
                $stringOutput = $using:creds.UserName + " " + $using:domain + " " + $using:site + " " + $using:creds.Password 
                Add-Content -Path "C:\users.txt" -Value $stringOutput
                if($using:newForest -ne $true)
                {
                    Install-ADDSDomainController -SkipPreChecks -DomainName $using:domain -SafeModeAdministratorPassword $domainCredential.Password -SiteName $using:site -Credential $domainCredential -DatabasePath "C:\NTDS" -SysvolPath "C:\SYSVOL" -LogPath "C:\NTDS"  -Confirm:$false -Force;
                }
                else {
                    Install-ADDSForest -SkipPreChecks -DomainName $using:domain -SafeModeAdministratorPassword $domainCredential.Password -DatabasePath "C:\NTDS" -SysvolPath "C:\SYSVOL" -LogPath "C:\NTDS" -NoRebootOnCompletion:$false -Confirm:$false -Force;
                }

                # create OU for SQL Servers
                if(-not (Get-ADOrganizationalUnit -Filter {Name -eq 'SQL'} -ErrorAction SilentlyContinue) {
                    New-ADOrganizationalUnit -Name 'SQL'
                }
            }
            TestScript = {
                return ((Get-Item -Path C:\SYSVOL\sysvol -ErrorAction SilentlyContinue) -ne $null)
            }
        } 
    }
}