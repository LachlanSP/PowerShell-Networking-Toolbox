Write-Host "Welcome to the PowerShell Networking Toolbox! Please select a tool below"

$selection = read-host "1. MultiPing Tool `n2. Network Management and Configuration`r`n"
switch($selection){
    1 {.\MultiPing.ps1}#1. Run pingsweep file
    2 {.\NetworkConfig.ps1}#3. Run Network Adapter Config
    default {
        Write-Host "Invalid option...exiting"
        start-sleep 1
    }
}

