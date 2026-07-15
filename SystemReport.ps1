# Xử lý trước ra ngoài here-string
$diskInfo = Get-WmiObject Win32_DiskDrive | ForEach-Object {
    $disk = $_
    $partitions = Get-WmiObject -Query "ASSOCIATORS OF {Win32_DiskDrive.DeviceID='$($disk.DeviceID)'} WHERE AssocClass=Win32_DiskDriveToDiskPartition"
    foreach ($part in $partitions) {
        $volumes = Get-WmiObject -Query "ASSOCIATORS OF {Win32_DiskPartition.DeviceID='$($part.DeviceID)'} WHERE AssocClass=Win32_LogicalDiskToPartition"
        foreach ($vol in $volumes) {
            "[$($vol.DeviceID)]  $($disk.Model)  Tổng: $([math]::Round($disk.Size/1GB,1))GB  Trống: $([math]::Round($vol.FreeSpace/1GB,1))GB"
        }
    }
} | Out-String

$softwareInfo = Get-WmiObject Win32_Product |
    Select-Object Name, Version |
    Sort-Object Name |
    ForEach-Object { "$($_.Name) - $($_.Version)" } | Out-String

$report = @"
===== BÁO CÁO CẤU HÌNH MÁY TÍNH =====
Thời gian: $(Get-Date -Format "dd/MM/yyyy HH:mm:ss")

[HỆ THỐNG]
Hostname       : $env:COMPUTERNAME
Username       : $env:USERNAME
Domain         : $env:USERDOMAIN
OS             : $(([System.Environment]::OSVersion).VersionString)
OS Build       : $((Get-WmiObject Win32_OperatingSystem).BuildNumber)
OS Edition     : $((Get-WmiObject Win32_OperatingSystem).Caption)
Cài đặt lần đầu: $((Get-WmiObject Win32_OperatingSystem).InstallDate)
Last Boot      : $((Get-WmiObject Win32_OperatingSystem).LastBootUpTime)

[CPU]
$(Get-WmiObject Win32_Processor | ForEach-Object {
  "Tên CPU      : $($_.Name)`nSố nhân      : $($_.NumberOfCores)`nSố luồng     : $($_.NumberOfLogicalProcessors)`nTốc độ       : $($_.MaxClockSpeed) MHz"
})

[RAM]
Tổng RAM       : $([math]::Round((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory/1GB,2)) GB
RAM khả dụng   : $([math]::Round((Get-WmiObject Win32_OperatingSystem).FreePhysicalMemory/1MB,2)) GB

[ĐĨA CỨNG]
$diskInfo
[GPU]
$(Get-WmiObject Win32_VideoController | ForEach-Object {
  "GPU: $($_.Name)  VRAM: $([math]::Round($_.AdapterRAM/1MB))MB"
})

[MÀN HÌNH]
$(Get-WmiObject Win32_DesktopMonitor | ForEach-Object { "Màn hình: $($_.Name)" })

[MẠNG]
$(Get-NetAdapter | Where-Object Status -eq 'Up' | ForEach-Object {
  "Adapter: $($_.Name) | MAC: $($_.MacAddress) | Speed: $($_.LinkSpeed)"
})
IP: $((Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike "*Loopback*"}).IPAddress -join ", ")

[PHẦN MỀM]
$softwareInfo
"@

$path = "$env:USERPROFILE\Desktop\SystemReport_$env:COMPUTERNAME.txt"
$report | Out-File -FilePath $path -Encoding UTF8
Write-Host "✅ Đã xuất báo cáo ra: $path" -ForegroundColor Green
Start-Sleep 2
