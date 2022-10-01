do{
    Write-Host "Welcome to the PowerShell Networking Toolbox! Please select a tool below"

    $selection = read-host "1. MultiPing Tool `n2. Network Management and Configuration`r`n"
    switch($selection){
        1 {.\MultiPing.ps1 #1. Run MultiPing file
            Write-Host "Returning to main menu..."}
        2 {.\NetworkConfig.ps1 #3. Run Network Adapter Config file
            Write-Host "Returning to main menu..."}
        default {
            Write-Host "Invalid option...exiting"
            start-sleep 1
        }
    }

}
until(($selection -ne '1') -and ($selection -ne '2'))
