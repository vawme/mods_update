#Requires -Version 4

Start-Transcript "mods_update.log"

# �ȑO���炠�����o�b�N�A�b�v�����Ă���
# ���p���̃f�B���N�g�����o�b�N�A�b�v�Ƃ��ă��l�[��������
function Create-BackUp([string]$path){
    $sourcePath = Convert-Path $path
    if(!(Test-Path $sourcePath)){
        echo "INFO: $sourcePath is not exist."
        return
    }

    $parentDir = Split-Path $sourcePath -Parent
    $destinationName = (Split-Path $sourcePath -Leaf) + ".bak"
    $destinationPath = Join-Path $parentDir $destinationName

    if(Test-Path $destinationPath){
        rm $destinationPath -Recurse -Force
    }

    Rename-Item $sourcePath $destinationName -ErrorAction Stop
}

# PS5��Expand-Archive�����ɗ����Ȃ������̂�
# System.IO.Compression.ZipFile������ZIP�𓀂�����
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Extract-Zip([string]$zipFilePath, [string]$destinationPath = "."){

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipFilePath, $destinationPath)
}



$InfoUrl = "http://reanisz.site44.com/minecraft/dragonscraft"
$lastInfo = wget "${InfoUrl}/info.json" | ConvertFrom-Json

$Version = $lastInfo.version
$ModsPath = "mods_v${VERSION}.zip"
$ConfigPath = "config_v$VERSION.zip"


if(!(Test-Path $ModsPath)){
    wget $lastInfo.mods_url.client -OutFile $ModsPath
}else{
    echo "INFO: $ModsPath is already exists."
}

if(!(Test-Path $ConfigPath)){
    wget $lastInfo.config_url -OutFile $ConfigPath
}else{
    echo "INFO: $ConfigPath is already exists."
}

Create-BackUp "mods"
Create-BackUp "config"


Extract-Zip $ModsPath
Extract-Zip $ConfigPath

$lastInfo | ConvertTo-Json | Out-File "info_v$VERSION.json" -Encoding utf8

