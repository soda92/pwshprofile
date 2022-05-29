
$Env:NO_PROXY = "localhost,127.0.0.1,::1"
function prompt {
    
    #Assign Windows Title Text
    $host.ui.RawUI.WindowTitle = "Current Folder: $pwd"

    #Configure current user, current folder and date outputs     
    $CmdPromptCurrentFolder = Split-Path -Path $pwd -Leaf        
    $CmdPromptUser = [Security.Principal.WindowsIdentity]::GetCurrent();
    $Date = Get-Date -Format 'dddd hh:mm:ss tt'

    # Test for Admin / Elevated
    $IsAdmin = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

    #Calculate execution time of last cmd and convert to milliseconds, seconds or minutes
    $LastCommand = Get-History -Count 1
    if ($lastCommand) { $RunTime = ($lastCommand.EndExecutionTime - $lastCommand.StartExecutionTime).TotalSeconds }

    if ($RunTime -ge 60) {
        $ts = [timespan]::fromseconds($RunTime)
        $min, $sec = ($ts.ToString("mm\:ss")).Split(":")
        $ElapsedTime = -join ($min, " min ", $sec, " sec")
    }
    else {
        $ElapsedTime = [math]::Round(($RunTime), 2)
        $ElapsedTime = -join (($ElapsedTime.ToString()), " sec")
    }

    #Decorate the CMD Prompt
    Write-Host ""
    Write-host ($(if ($IsAdmin) { 'Elevated ' } else { '' })) -BackgroundColor DarkRed -ForegroundColor White -NoNewline        
    Write-Host " USER:$($CmdPromptUser.Name.split("\")[1]) " -BackgroundColor DarkBlue -ForegroundColor White -NoNewline        
    If ($CmdPromptCurrentFolder -like "*:*")
    { Write-Host " $CmdPromptCurrentFolder "  -ForegroundColor White -BackgroundColor DarkGray -NoNewline }
    else { Write-Host ".\$CmdPromptCurrentFolder\ "  -ForegroundColor White -BackgroundColor DarkGray -NoNewline }

    Write-Host " $date " -ForegroundColor White
    Write-Host "[$elapsedTime] " -NoNewline -ForegroundColor Green
    return "> "

}

function which {
    param ($name)
    (Get-Command $name).source
}
function tool_json {
    Write-Host `
        "`"cmake.configureEnvironment`": {`r`n"`
        "    `"CMAKE_TOOLCHAIN_FILE`": `"D:/src/vcpkg/scripts/buildsystems/vcpkg.cmake`"`r`n" `
        "}"
}

function testvideo {
    Write-Host "ffplay rtsp://admin:ALTRQJ@192.168.1.100:554/Streaming/Channels/101"
}

function tail {
    coreutils tail $args
}

function rm {
    coreutils rm $args
}

function record {
    ffmpeg -i rtsp://admin:hk123456@192.168.104.72:554/Streaming/Channels/101 `
        -c copy -map 0 -segment_time 00:15:00 -f segment -strftime 1 "TEST_%Y%m%d_%H%M%S.mp4"

}
function rec {
    Write-Host "ffmpeg -i rtsp://admin:hk123456@192.168.104.70:554/Streaming/Channels/101 -c copy -map 0:v:0 -map 0:a:0 -segment_time 00:15:00 -f segment -strftime 1 %Y%m%d/%H%M%S_A_123_1.mp4"

}

Get-ChildItem "$PROFILE\..\Completions\" | ForEach-Object {
    . $_.FullName
}

function build-cmake-vcpkg {
    Remove-Item -Path build -Recurse
    cmake -B build -G "Ninja" -DCMAKE_TOOLCHAIN_FILE="D:/src/vcpkg/scripts/buildsystems/vcpkg.cmake"
    cmake --build build  
}

function cmake_vcpkg {
    $Env:CMAKE_TOOLCHAIN_FILE = "D:/src/vcpkg/scripts/buildsystems/vcpkg.cmake"
}

function cnpm {
    
    npm --registry=https://registry.npmmirror.com `
        --cache=$HOME/.npm/.cache/cnpm `
        --disturl=https://npmmirror.com/dist `
        --userconfig=$HOME/.cnpmrc $args

}

function du {
    coreutils du $args
}

function ip {
    ipconfig | Select-String 'IPv4'
}

function list {
    Write-Host "testvideo: 海康测试摄像头RTSP地址"
    Write-Host "tool: vcpkg cmake配置"
    Write-Host "tool_json: vcpkg vscode cmake配置"
    Write-Host "build-cmake-vcpkg: cmake清理生成"
    Write-Host "rec: 录像地址"
}


function ll {
    coreutils ls --color -l $args

}

Remove-Alias ls
function ls {
    coreutils ls --color $args
}

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

Set-Alias ipy -Value "ipython.exe"

Set-Alias vim -Value "nvim.exe"

Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -ShowToolTips
