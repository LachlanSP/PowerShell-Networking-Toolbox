#Start of Functions Section
function Get-AdapterSettings{
    $interfaceDetails = Get-NetIPAddress -IPAddress "192.*" # Get interface with IP starting with 192. 
    $netAdapterName = $interfaceDetails.InterfaceAlias # Get name for interface
    $physicalAddress = (Get-NetAdapter -name $netAdapterName).MacAddress # Get MAC address for interface
    $localAddress = $interfaceDetails.IPAddress # Get IP Address of interface
    $defaultGateway = (Get-NetIPConfiguration -InterfaceIndex $interfaceDetails.InterfaceIndex).IPv4DefaultGateway.NextHop # Get configurated default gateway for interface

    Write-Host -BackgroundColor Yellow "Local Network Settings: "
    Write-Host "Network Adapter Name: "$netAdapterName
    Write-Host "Local IP Address: "$localAddress
    Write-Host "Physical (MAC) Address: "$physicalAddress
    Write-Host "Default Gateway (Router) Address: "$defaultGateway

}

function Get-PublicDetails{
    $publicDetails = Invoke-RestMethod -Uri ('https://ipinfo.io/') -ErrorAction Stop #Query public REST API for IP info
    $publicAddress = $publicDetails.ip # WAN IP Address
    $location = $publicDetails.city + ", " + $publicDetails.region + ", " + $publicDetails.country + ", " + $publicDetails.loc # Concat location details into single output

    Write-Host -BackgroundColor Yellow "Public Network Settings:"
    Write-Host "Public IP Address: "$publicAddress
    Write-Host "Location: "$location
}

function Set-DomainProvider{
    write-host "This option will change your DNS provider from default (typically ISP) to Cloudflare or Google"
    $interfaceIndex = (Get-NetIPAddress -IPAddress "192.*").InterfaceIndex # Get interface with IP starting with 192. 
    $currentProvider = ($interfaceIndex | Get-DnsClientServerAddress).ServerAddresses # Get currently configured DNS provider
    $selection = Read-Host "1. Change DNS provider to Google (8.8.8.8)`n2. Change DNS provider to Cloudflare (1.1.1.1)`n3.Exit"

    switch ($selection) {
        1 { # Change DNS to Google
            $googlePrimary = "8.8.8.8"
            $googleSecondary = "8.8.4.4"
            if(($googlePrimary -like $currentProvider) -or ($googleSecondary -like $currentProvider)){
                Write-Host "Google is already DNS provider! Exiting..." # If Google is already provider, skip
            }
            else{
                Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses ($googlePrimary, $googleSecondary)
                Clear-DnsClientCache
            }
         }
        2 { # Change DNS to Cloudflare
            $cloudflarePrimary = "1.1.1.1"
            $cloudflareSecondary = "1.0.0.1"
            if(($cloudflarePrimary -like $currentProvider) -or ($cloudflareSecondary -like $currentProvider)){
                Write-Host "Cloudflare is already DNS provider! Exiting..." # If cloudflare is already provider, skip
            }
            else{
                Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses ($cloudflarePrimary, $cloudflareSecondary)
                Clear-DnsClientCache
            }
        }
        Default {Write-Host "Exiting..."}
    }
}

function Set-NewAddress{
    Get-AdapterSettings # Display current interface confinguration

    $selection = Read-Host "This will clear and refresh the local IP address provided by your router/DHCP server. Enter Y to continue."
    if(($selection -eq "Y") -or ($selection -eq "y")){ #If the user does not explicitly say yes, exit
        Get-WmiObject Win32_NetworkAdapterConfiguration -Filter 'IpEnabled=True AND DhcpEnabled=True' | ForEach-Object{$_.RenewDHCPLease()} | Out-Null
        
    }
}

function Get-MACAddress{
    Write-Host "Table of IPv4 Addresses correlated to MAC Addresses:`n"
    Get-NetNeighbor | where-object -filterscript {$_.LinkLayerAddress -ne ""} | Select-Object IPAddress,LinkLayerAddress

}

# End of Functions Section

write-host "Welcome to the Network Management tool! Please select an option below"

$selection = Read-Host "1. Display Current Settings `n2. Update DNS Provider`n3. Renew DHCP IP Address`n4. Display IP-MAC Table"

switch ($selection) {
    1 {
        Get-AdapterSettings
        Get-PublicDetails
     }# Display
    2 {
        Set-DomainProvider
    } #Settings
    3 {
        Set-NewAddress
    }
    4 {
        Get-MACAddress
    }
    Default {
        Write-Host "Invalid option...exiting"
        start-sleep 1
    }#Invalid
}