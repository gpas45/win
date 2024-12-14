# Находим список баз
$filePath = Join-Path -Path $env:APPDATA -ChildPath '1C\1CEStart\ibases.v8i'

# Выбираем все файловые базы
$connectLines = Get-Content -Path $filePath | Where-Object { $_ -match '^Connect=File' }

# Добавляем папки с файловыми базами в исключения
foreach ($line in $connectLines) {
    if ($line -match 'Connect=File="([^"]+)"') {
        $filePath = $matches[1]
        Add-MpPreference -ExclusionPath $filePath
    }
}

#Добавляем в исключения стандартные пути 1С
$path = Join-Path -Path $env:APPDATA -ChildPath '1C'
if (Test-Path -Path $path) {
    Add-MpPreference -ExclusionPath $path
}
$path = Join-Path -Path $env:LOCALAPPDATA -ChildPath '1C'
if (Test-Path -Path $path) {
    Add-MpPreference -ExclusionPath $path
}
$path = Join-Path -Path $env:PROGRAMFILES -ChildPath '1cv8'
if (Test-Path -Path $path) {
    Add-MpPreference -ExclusionPath $path
} 
$path = Join-Path -Path ${env:PROGRAMFILES(x86)} -ChildPath '1cv8'
if (Test-Path -Path $path) {
    Add-MpPreference -ExclusionPath $path
} 

#Добавляем расширения 1С
Add-MpPreference -ExclusionExtension 1CD, DT, CF 

# Добавляем в исключения все процессы 1С и драйверов оборудования
$path = Join-Path -Path $env:PROGRAMFILES -ChildPath '1cv8'
if (Test-Path -Path $path) {
    Get-ChildItem -Path $path -Directory | Where-Object {$_.Name -match '^8\.3\.\d{2}\.\d{4}$'} | ForEach-Object {
        Add-MpPreference -ExclusionProcess ($path + "\" + $_.Name + "\bin\*")
    } 
} 
$path = Join-Path -Path ${env:PROGRAMFILES(x86)} -ChildPath '1cv8'
if (Test-Path -Path $path) {
    Get-ChildItem -Path $path -Directory | Where-Object {$_.Name -match '^8\.3\.\d{2}\.\d{4}$'} | ForEach-Object {
        Add-MpPreference -ExclusionProcess ($path + "\" + $_.Name + "\bin\*")
    } 
} 
$path = Join-Path -Path $env:APPDATA -ChildPath '1C\1cv8\ExtCompT'
if (Test-Path -Path $path) {
    Add-MpPreference -ExclusionProcess $path\*
} 
