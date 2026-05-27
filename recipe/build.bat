@echo on
setlocal enabledelayedexpansion

pushd "%SRC_DIR%\src\frontend\app"
if errorlevel 1 exit /b 1

pnpm install --frozen-lockfile
if errorlevel 1 exit /b 1
pnpm store prune
if errorlevel 1 exit /b 1
npm run docs:gen
if errorlevel 1 exit /b 1
npm run build
if errorlevel 1 exit /b 1

mkdir "%LIBRARAY_PREFIX%\share\hatchet"
move dist "%LIBRARY:PREFIX%\share\hatchet\static-assets"
if errorlevel 1 exit /b 1

mkdir "%PREFIX%\etc\conda\env_vars.d"
set "asset_dir=%LIBRARY:PREFIX:\=/%/share/hatchet/static-assets"
copy NUL "%PREFIX%\etc\conda\env_vars.d\hatchet-lite.json" >NUL
echo {>> "%PREFIX%\etc\conda\env_vars.d\hatchet-lite.json"
echo   ^"LITE_STATIC_ASSET_DIR^": ^"!asset_dir!^">> "%PREFIX%\etc\conda\env_vars.d\hatchet-lite.json"
echo }>> "%PREFIX%\etc\conda\env_vars.d\hatchet-lite.json"

popd
if errorlevel 1 exit /b 1

pushd "%SRC_DIR%\src\cmd\hatchet-lite"
if errorlevel 1 exit /b 1

go-licenses save . --save_path "%SRC_DIR%\library_licenses" --ignore github.com/mattn/go-localereader
if errorlevel 1 exit /b 1

go build -v -o "%LIBRARY_PREFIX%\bin\hatchet-lite.exe" -ldflags="-s -w"
if errorlevel 1 exit /b 1

popd
if errorlevel 1 exit /b 1

endlocal
