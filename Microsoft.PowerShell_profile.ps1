# function prompt {
#   $p = Split-Path -leaf -path (Get-Location)
#   "$p> "
# }
$Env:NO_PROXY = "localhost,127.0.0.1,::1"
# chcp 65001
function which {
  param ($name)
  (Get-Command $name).source
}
function ip {
  ipconfig | Select-String 'IPv4'
}
function cnpm {
  npm --registry=https://registry.npmmirror.com `
    --cache=$HOME/.npm/.cache/cnpm `
    --disturl=https://npmmirror.com/dist `
    --userconfig=$HOME/.cnpmrc $args
}
  
Set-PSReadlineOption -EditMode Vi
Import-Module 'D:\src\vcpkg\scripts\posh-vcpkg'

Set-Alias -Name grep -Value Select-String

$Env:MY_INSTALL_DIR = "D:/.local"
$Env:Path = "$Env:MY_INSTALL_DIR/bin;$Env:PATH"


# from stackoverflow
function ms19 {
  Push-Location "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools"
  cmd /c "VsDevCmd.bat&set" |
  ForEach-Object {
    if ($_ -match "=") {
      $v = $_.split("="); Set-Item -Force -Path "ENV:\$($v[0])" -Value "$($v[1])"
    }
  }
  Pop-Location
  Write-Host "Visual Studio 2019 Command Prompt variables set." -ForegroundColor Green
}

function ms22 {
  $dir1 = "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build"
  $dir2 = "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build"
  if (Test-Path $dir1) {
    Push-Location $dir1
  }
  if (Test-Path $dir2) {
    Push-Location $dir2
  }
  cmd /c "vcvars64.bat & set" |
  ForEach-Object {
    if ($_ -match "=") {
      $v = $_.split("=", 2); Set-Item -Force -Path "ENV:\$($v[0])" -Value "$($v[1])"
    }
  }
  Pop-Location
  Write-Host "Visual Studio 2022 amd64 Command Prompt variables set." -ForegroundColor Green
}

function ms22_32 {
  Push-Location "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build"
  cmd /c "vcvars32.bat & set" |
  ForEach-Object {
    if ($_ -match "=") {
      $v = $_.split("=", 2); Set-Item -Force -Path "ENV:\$($v[0])" -Value "$($v[1])"
    }
  }
  Pop-Location
  Write-Host "Visual Studio 2022 x86 Command Prompt variables set." -ForegroundColor Green
}

function cmake_vcpkg {
  $Env:CMAKE_TOOLCHAIN_FILE = "D:/src/vcpkg/scripts/buildsystems/vcpkg.cmake"
}

function tool {
  Write-Host '-DCMAKE_TOOLCHAIN_FILE="D:/src/vcpkg/scripts/buildsystems/vcpkg.cmake"'
}

function tool_json {
  Write-Host `
    "`"cmake.configureEnvironment`": {`r`n"`
    "    `"CMAKE_TOOLCHAIN_FILE`": `"D:/src/vcpkg/scripts/buildsystems/vcpkg.cmake`"`r`n" `
    "}"
}

function build-cmake-vcpkg {
  Remove-Item -Path build -Recurse
  cmake -B build -G "Ninja" -DCMAKE_TOOLCHAIN_FILE="D:/src/vcpkg/scripts/buildsystems/vcpkg.cmake"
  cmake --build build
}

function testvideo {  
  Write-Host "ffplay rtsp://admin:ALTRQJ@192.168.1.100:554/Streaming/Channels/101"
}

function record {
  ffmpeg -i rtsp://admin:hk123456@192.168.104.72:554/Streaming/Channels/101 `
    -c copy -map 0 -segment_time 00:15:00 -f segment -strftime 1 "TEST_%Y%m%d_%H%M%S.mp4"

}
Get-ChildItem "$PROFILE\..\Completions\" | ForEach-Object {
  . $_.FullName
}

function rec {
  Write-Host "ffmpeg -i rtsp://admin:hk123456@192.168.104.70:554/Streaming/Channels/101 -c copy -map 0:v:0 -map 0:a:0 -segment_time 00:15:00 -f segment -strftime 1 %Y%m%d/%H%M%S_A_123_1.mp4"
}

function list {
  Write-Host "testvideo: 海康测试摄像头RTSP地址"
  Write-Host "tool: vcpkg cmake配置"
  Write-Host "tool_json: vcpkg vscode cmake配置"
  Write-Host "build-cmake-vcpkg: cmake清理生成"
  Write-Host "rec: 录像地址"
}
