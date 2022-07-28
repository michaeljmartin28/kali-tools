param (
    [string]$protocol,
    [string]$host_ip,
    [string]$target_ip,
    [int]$local_port, 
    [int]$target_port
)

if ($protocol -eq 'ftp'){
    $local_port=10021
    $connect_port=21
}elseif($protocol -eq 'http'){
    $local_port=10080
    $connect_port=80
}elseif($protocol -eq 'https'){
    $local_port=10443
    $connect_port=443
}elseif($protocol -eq 'smtp'){
    $local_port=10025
    $connect_port=25
}



Write-Host " [+]   Creating port forward from $host_ip on port $local_port to $target_ip on port $connect_port"

netsh interface portproxy add v4tov4 listenport=$local_port listenaddress=$host_ip connectport=$connect_port connectaddress=$target_ip
netsh advfirewall firewall add rule name="forward_port_rule" protocol=TCP dir=in localip=$host_ip localport=$local_port action=allow


netstat -anp TCP | findstr.exe $local_port