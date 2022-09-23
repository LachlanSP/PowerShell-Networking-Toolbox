Write-Host "Welcome to the MultiPing tool!"
try {
    $numPing = [int](read-host "How many devices do you wish to ping?") 
}
catch { # If the user does not enter a valid integer, display error and exit
    Write-Host "Invalid entry. Please enter a integer between 1 and 10"
    exit
}

if(($numPing -lt 1) -or ($numPing -gt 10)){ # If entered number is not between 1-10, exit.
    "Invalid entry. Please enter a integer between 1 and 10"
}
else{
    $addressArray = @()

    for($i = 1; $i -le $numPing; $i++){ # Fill array with addresses to ping
        $address = Read-Host "Enter Address for Device #"$i
        $addressArray += $address
    }

    Write-Host "Beginning ping sweep..."

    foreach($address in $addressArray){ # Ping all provided addresses in sequence
        write-host "Pinging "$address -BackgroundColor Yellow
        try {
            $ping = Test-Connection -ComputerName $address -Count 1 -ErrorAction Stop #Ping provided address once
            Write-Host "Ping Successful!"
            Write-Host "IP Address: "$ping.IPV4Address
            Write-Host "Buffer Size: "$ping.BufferSize
            Write-Host "Reply Size: "$ping.ReplySize
            Write-Host "Destination Response Time (ms): "$ping.ResponseTime
        }
        catch { # If any error occurs, exit ping attempt and move to next address
            write-host "Ping failed!"
        }
    }

    Write-Host "Operation Complete. Exiting..."
}