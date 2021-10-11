@ECHO OFF

echo "======================================"
echo "===  Parcel Manifest Setup Script  ==="
echo "======================================"
echo.
 
echo "Step 1: Downloading R version 4.1.1. Please wait..."
echo "===================================================="
echo. 

powershell -Command "$ProgressPreference = 'silentlyContinue';"^
 "Invoke-WebRequest https://cran.r-project.org/bin/windows/base/R-4.1.1-win.exe -Outfile $HOME/Downloads/R-4.1.1-win.exe;"^
 "$ProgressPreference = 'Continue';" 

echo. 
echo "R 4.1.1 Downloaded!"
echo. 

echo "Step 2: Installing R."
echo "======================="
powershell -Command "Start-Process $HOME/Downloads/R-4.1.1-win.exe -NoNewWindow -Wait;"
echo .
echo "R installed!"
echo. 

echo "Step 3: Downloading Source Code..."
echo "=================================="
powershell -Command "$ProgressPreference = 'silentlyContinue';"^
 "Invoke-WebRequest https://github.com/JoshuaQChurch/ParcelManifest-R/archive/refs/heads/main.zip -Outfile $HOME/Documents/ParcelManifest.zip;"^
 "$ProgressPreference = 'Continue';" 

powershell -Command "Expand-Archive -Path $HOME/Documents/ParcelManifest.zip -DestinationPath $HOME/Documents/ -Force;"
powershell -Command "Remove-Item -Path $HOME\Documents\ParcelManifest.zip -Force;"
powershell -Command "Remove-Item -Path $HOME\Documents\ParcelManifest-R -Force -Recurse;"
powershell -Command "Rename-Item -Path $HOME\Documents\ParcelManifest-R-main -NewName ParcelManifest-R -Force;"

echo.
echo "Source code downloaded into 'Documents' folder."
echo. 

echo "Step 4: Building Parcel Manifest tool."
echo "NOTE: This step takes a while (~20 minutes). Please wait..."
echo "=========================================================="

powershell -Command "& 'C:\Program Files\R\R-4.1.1\bin\Rscript.exe' $HOME/Documents/ParcelManifest-R/build/electron_build.R"

echo.
echo "Parcel Manifest Installed!"
echo. 

echo "Step 5: Creating Desktop shortcut..."
echo "====================================="

powershell -Command "$SourceFileLocation = '$HOME\Documents\ParcelManifest-R\build\output\ParcelManifest\dist\win-unpacked\ParcelManifest.exe';"^
    "$ShortcutLocation = '$HOME\Desktop\ParcelManifest.lnk';"^
    "$WScriptShell = New-Object -ComObject WScript.Shell;"^
    "$Shortcut = $WScriptShell.CreateShortcut($ShortcutLocation);"^
    "$Shortcut.TargetPath = $SourceFileLocation;"^
    "$Shortcut.Save();"

echo.
echo "Complete!"
echo. 

echo "You can now close this window."

pause