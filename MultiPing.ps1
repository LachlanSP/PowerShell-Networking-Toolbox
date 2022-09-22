Write-Host "Welcome to the MultiPing tool!"
try {
    $numPing = [int](read-host "How many devices do you wish to ping?")
}
catch {
    Write-Host "Invalid entry. Please enter a integer between 1 and 10"
    exit
}

if(($numPing -lt 1) -or ($numPing -gt 10)){
    "Invalid entry. Please enter a integer between 1 and 10"
}
else{
    $addressArray = @()

    for($i = 1; $i -le $numPing; $i++){ 
        $address = Read-Host "Enter Address for Device #"$i
        $addressArray += $address
    }

    Write-Host "Beginning ping sweep..."

    foreach($address in $addressArray){
        write-host "Pinging "$address -BackgroundColor Yellow
        try {
            $ping = Test-Connection -ComputerName $address -Count 1 -ErrorAction Stop #Ping provided address once
            Write-Host "Ping Successful!"
            Write-Host "IP Address: "$ping.IPV4Address
            Write-Host "Buffer Size: "$ping.BufferSize
            Write-Host "Reply Size: "$ping.ReplySize
            Write-Host "Destination Response Time (ms): "$ping.ResponseTime
        }
        catch {
            write-host "Ping failed!"
        }
    }

    Write-Host "Operation Complete. Exiting..."
}