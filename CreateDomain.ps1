#CreateDomain.ps1
#meide@hbs.net - 2021-11-16
#To-Do - figure out how to pass in parameters See:https://azsec.azurewebsites.net/2020/01/20/what-blue-team-needs-to-know-about-run-script-feature-in-azure/

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'

#Get Environment Configuration Parameters
#. ./Lab-Env-Variables.ps1

#Define Test AD Domain
$DomainName = "test.com"

# Install AD role
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
    
# Configure forest deployment parameters
$adRestorePassword = ConvertTo-SecureString -String "4sZ434q!0Jz0" -AsPlainText -Force
    $ADParameters = @{
        CreateDnsDelegation = $false
        DomainName = $DomainName
        NoRebootOnCompletion = $true
        SafeModeAdministratorPassword = $adRestorePassword
        Force = $true
        Verbose = $true
    }

# Install domain controller and DNS with new forest
Install-ADDSForest @ADParameters

# Schedule restart after script finishes
Invoke-Expression "shutdown /r /t 10"