Write-Host "Welcome to the MultiPing tool!"
try {
    $numPing = [int](read-host "How many devices do you wish to ping?") 
}
catch { # If the user does not enter a valid integer, display error and exit
    Write-Host "Invalid entry. Input requires an integer between 1 and 10`nExiting..."
    exit
}

if(($numPing -lt 1) -or ($numPing -gt 10)){ # If entered number is not between 1-10, exit.
    write-host"Invalid entry. Input requires an integer between 1 and 10`nExiting..."
    exit
}
else{
    $addressArray = @()

    for($i = 1; $i -le $numPing; $i++){ # Fill array with addresses to ping
        $address = Read-Host "Enter Web or IP Address for Device #"$i
        $addressArray += $address
    }

    Write-Host "Beginning ping sweep..."

    foreach($address in $addressArray){ # Ping all provided addresses in sequence
        write-host "Pinging "$address -ForegroundColor Yellow
        try {
            $ping = Test-Connection -ComputerName $address -Count 1 -ErrorAction Stop #Ping provided address once
            Write-Host "Ping Successful!" -ForegroundColor Green
            Write-Host "IP Address: "$ping.IPV4Address
            Write-Host "Buffer Size: "$ping.BufferSize
            Write-Host "Reply Size: "$ping.ReplySize
            Write-Host "Destination Response Time (ms): "$ping.ResponseTime
        }
        catch { # If any error occurs, exit ping attempt and move to next address
            write-host "Ping failed!" -ForegroundColor Red
        }
    }
    Write-Host "Operation Complete"

}