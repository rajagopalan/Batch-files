$sdc_url = $env:sdc_ur
$console_url = $env:console_url
$build = $env:sdc_file
$pack = $env:console_file
$major_version = $env:major_version
$sub_version = $env:sub_version
$sdms_instance = $env:category
$downloadDir = ""
$storageDir = ""
$string = "Release"

write-host $env:category
write-host $sdms_instance

if($sdms_instance -eq "Prod"){
    $downloadDir = "D:\sdc\download\prod\$major_version.$sub_version"
}

if($sdms_instance -eq "Care"){
    $downloadDir = "D:\sdc\download\care\$major_version.$sub_version"
}

if($sdms_instance -eq "SaaS"){
    $downloadDir = "D:\sdc\download\ustech\$major_version.$sub_version"
}

write-host $downloadDir

if(!(Test-Path -Path $downloadDir)){
    Invoke-Expression "mkdir $downloadDir"
}

$build_exe = "$downloadDir\$build"
$console_package = "$downloadDir\$pack"
$webclient = New-Object System.Net.WebClient


IF(!([string]::IsNullOrEmpty($sdc_url))){
    $webclient.DownloadFile($sdc_url,$build_exe)
    write-host "finished downloading sdc"
 }
IF(!([string]::IsNullOrEmpty($console_url))){
    $webclient.DownloadFile($console_url,$console_package)
    write-host "findished downloading console package"
}

$servers = $env:category

if($servers -eq "Prod"){
    $destination = "\\172.16.40.214\d$\sdc\stage\$major_version$string\$major_version.$sub_version"
}
elseif($servers -eq "Care"){
    $destination = "\\172.16.40.13\d$\sdc\stageCare\$major_version$string\$major_version.$sub_version"
}
else{
    $destination = "\\172.16.50.100\d$\sdc\stageUstech\$major_version$string\$major_version.$sub_version"
}

if(!(Test-Path -Path $destination)){
    write-host "destination not exists"
    new-item  $destination -type directory
    write-host "directory created"
}


Copy-Item $downloadDir\* -Destination $destination

write-host $destination
