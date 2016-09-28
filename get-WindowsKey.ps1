# get-WindowsKey.ps1

function Get-OsData {

    param ($targets = ".")

    $HKLM = 2147483650
    $regPath = "Software\Microsoft\Windows NT\CurrentVersion"
    $regValue = "DigitalProductId"

    Foreach ($target in $targets) {
        # очищаем переменные
        $productKey = $null
        $osData = $null

        $wmi = [WMIClass]"\\$target\root\default:stdRegProv"
        $data = $wmi.GetBinaryValue($HKLM, $regPath, $regValue)
        $binArray = ($data.uValue)[52..66]
        $charsArray = "B","C","D","F","G","H","J","K","M","P","Q","R","T",
"V","W","X","Y","2","3","4","6","7","8","9"

        # раскодировка бинарных данных
        For ($i = 24; $i -ge 0; $i--) {
            $k = 0
            For ($j = 14; $j -ge 0; $j--) {
                $k = $k * 256 -bxor $binArray[$j]
                $binArray[$j] = [math]::truncate($k / 24)
                $k = $k % 24
            }

            $productKey = $charsArray[$k] + $productKey
            If (($i % 5 -eq 0) -and ($i -ne 0)) {
                $productKey = "-" + $productKey
            }
        }

        # Создаем запрос к WMI
        $osData = Get-WmiObject Win32_OperatingSystem -computer $target
        # Формируем вывод результатов
        # для наглядности выводятся доп. данные - организация, пользователь, номер билда и пр.
        $obj = New-Object Object
        $obj | Add-Member Noteproperty Computer -value $target
        $obj | Add-Member Noteproperty Caption -value $osData.Caption
	$obj | Add-Member Noteproperty Organization -value $osData.Organization
	$obj | Add-Member Noteproperty Name -value $osData.Name
	$obj | Add-Member Noteproperty Version -value $osData.Version
        $obj | Add-Member Noteproperty OSArch -value $osData.OSArchitecture
        $obj | Add-Member Noteproperty BuildNumber -value $osData.BuildNumber
        $obj | Add-Member Noteproperty RegisteredTo -value $osData.RegisteredUser
        $obj | Add-Member Noteproperty ProductID -value $osData.SerialNumber 
        $obj | Add-Member Noteproperty ProductKey -value $productkey
        $obj
    }
}
# для получения данных с локального компьютера введите
Get-OsData

# для получения данных с удаленного компьютера введите
# Get-OsData "computername"
