Push-Location C:/
if (Test-Path "vcpkg") {}
else {
    git clone https://github.com/microsoft/vcpkg
    Push-Location C:/vcpkg
    .\bootstrap-vcpkg.bat
    Pop-Location
}
Pop-Location
Push-Location C:/vcpkg
.\vcpkg.exe install protobuf grpc --triplet x64-windows
Pop-Location
