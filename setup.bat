@ECHO OFF

echo "======================================"
echo "===  Parcel Manifest Setup Script  ==="
echo "======================================"
echo.

echo "Step 1: Downloading R version 4.1.1."
echo "NOTE: This may take a few minutes. Please wait..."
echo "================================================="
echo. 

powershell -Command "$ProgressPreference = 'silentlyContinue';"^
 "Invoke-WebRequest http://cran.r-project.org/bin/windows/base/old/4.1.1/R-4.1.1-win.exe -Outfile $env:USERPROFILE\Downloads\R-4.1.1-win.exe;"^
 "$ProgressPreference = 'Continue';" 

echo. 
echo "R 4.1.1 Downloaded!"
echo. 

echo "Step 2: Installing R."
echo "======================"
powershell -Command "Start-Process $env:USERPROFILE\Downloads\R-4.1.1-win.exe -NoNewWindow -Wait;"
echo .
echo "R installed!"
echo. 

echo "Step 3: Downloading Source Code..."
echo "=================================="

:: Remove existing version of the Parcel Manifest code first. 
powershell -Command "Remove-Item -Path $env:USERPROFILE\Documents\ParcelManifest-R -Force -Recurse;"

:: Install most up-to-date copy of the code. 
powershell -Command "$ProgressPreference = 'silentlyContinue';"^
    "Invoke-WebRequest https://github.com/JoshuaQChurch/ParcelManifest-R/archive/refs/heads/main.zip -Outfile $env:USERPROFILE\Documents\ParcelManifest.zip;"^
    "$ProgressPreference = 'Continue';" 
powershell -Command "Expand-Archive -Path $env:USERPROFILE\Documents\ParcelManifest.zip -DestinationPath $env:USERPROFILE\Documents -Force;"
powershell -Command "Remove-Item -Path $env:USERPROFILE\Documents\ParcelManifest.zip -Force;"
powershell -Command "Remove-Item -Path $env:USERPROFILE\Documents\ParcelManifest-R -Force -Recurse;"
powershell -Command "Rename-Item -Path $env:USERPROFILE\Documents\ParcelManifest-R-main -NewName ParcelManifest-R -Force;"

echo.
echo "Source code downloaded into 'Documents' folder."
echo. 

echo "Step 4: Building Parcel Manifest tool."
echo "NOTE: This step takes a while (~20 minutes). Please wait..."
echo "=========================================================="

:: Check if admin or standard user
if exist "%userprofile%\Documents\R\R-4.1.1\bin\Rscript.exe" (
    powershell -Command "& $env:USERPROFILE\Documents\R\R-4.1.1\bin\Rscript.exe $env:USERPROFILE\Documents\ParcelManifest-R\build\electron_build.R"
) else (
    powershell -Command "& 'C:\Program Files\R\R-4.1.1\bin\Rscript.exe' $env:USERPROFILE\Documents\ParcelManifest-R\build\electron_build.R"
)
echo.
echo "Parcel Manifest Installed!"
echo. 

echo "Step 5: Creating Desktop shortcut..."
echo "====================================="

powershell -Command "Remove-Item -Path $env:USERPROFILE\Desktop\ParcelManifest.lnk -Force;"
powershell -Command "$SourceFileLocation = '$env:USERPROFILE\Documents\ParcelManifest-R\build\output\ParcelManifest\dist\win-unpacked\ParcelManifest.exe';"^
    "$ShortcutLocation = '$env:USERPROFILE\Desktop\ParcelManifest.lnk';"^
    "$WScriptShell = New-Object -ComObject WScript.Shell;"^
    "$Shortcut = $WScriptShell.CreateShortcut($ShortcutLocation);"^
    "$Shortcut.TargetPath = $SourceFileLocation;"^
    "$Shortcut.Save();"

echo.
echo "Complete!"
echo. 

echo "You can now close this window."

pause