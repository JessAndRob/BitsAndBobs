# BitsAndBobs

A public repo for bits and bobs (original purpose was for DSC scripts to be pulled down by VMs in the build process)

## DSCScripts

This folder is used in the SQLBitsInfra bicep deployment.

- DomainControllerConfig.zip - the AD DC pulls this down as part of the deployment to install AD and configure the vm as a domain controller.

## Scripts

This folder has scripts in 😉

- reboot-vms.ps1 - pass this an array of vm name, resource group and subscription - and it'll restart vms for you