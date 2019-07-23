control userpasswords2
net localgroup observators /add
net user observer /active:yes /add
net localgroup observer observators /add
net user Администратор /active:yes
net user Администратор 1
runas /savecred /user:\Администратор C:\ARM_AMC\AMC_Client.exe