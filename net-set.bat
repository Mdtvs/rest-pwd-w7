@echo off
set /p mesto="choice your settings (1 - work, 2 - home): "
echo your had - %mesto%

if %mesto% equ 2 goto home

:work
set IFACE="local"
set IP=10.9.10.115
set MASK=255.255.255.0
set GATEWAY=10.9.10.254
set GWMETRIC=1
set DNS1=90.188.32.22
set MAC=001122334455
goto smena

:home
set IFACE="local"
set IP=10.9.10.115
set MASK=255.255.255.0
set GATEWAY=10.9.10.254
set GWMETRIC=1
set DNS1=192.168.1.10
set MAC=221133004455
goto smena

:smena
echo Меняем MAC адрес на %MAC%
echo _____
macshift -i "local" %MAC%

echo _____
echo seting ip address-%IP%
echo subnetmask-%MASK%
echo native gateway-%GATEWAY%

netsh interface ip set address name=%IFACE% source=static addr=%IP% mask=%MASK% gateway=%GATEWAY% gwmetric=%GWMETRIC%

echo setting  DNS server %DNS1%
netsh interface ip set dns name=%IFACE% source=static addr=%DNS1% register=PRIMARY

echo settings has been changed:
ipconfig /all
echo _____
pause
