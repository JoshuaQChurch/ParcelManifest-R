# ParcelManifest-R
Your one-stop shop for automating day-to-day tasks. 

## Purpose 
Parcel Manifest (R Edition) is designed to pseudo-automate data entry tasks for the PKMS system. <br>

## Motivation
Users that work with the PKMS system perform different tasks throughout the day. A few of these tasks involve manually entering entries from an Excel-like file, hitting a few keys (e.g., "9", "F16", "Enter"), and repeating this process multiple times (sometimes thousands of times in a row). This means (1) this process can take hours to complete and (2) this process has the possibility for major human error. Ultimately, this was the perfect use case for automation.

## Benefits
This tool has streamlined these tasks (which can sometimes take ~3 hours per day) and reduced the process time down to ~30 seconds. 

*Automation = ( Time Saved + Money Saved + Less Chance for Errors )*.

## Supportability 
This tool is designed to work on a machine using Windows 10. This decision was made for (3) primary reasons: 
1. The system(s) that require this tool only utilize the Windows 10 OS.
2. The package `electricShine` currently only supports Windows-based builds.
3. The package `KeyboardSimulator` utilizes the Windows API for the macro (e.g., mouse and keyboard) commands.

## Setup
Please use the followings steps to install this software on your system.
1. Download the `setup.bat` file to your system.
2. Right click `setup.bat` and click *properties*.
3. Navigate to the *Security* segment under *General*.
4. In this segement, click the *Unblock* check mark.
5. Confirm with *Apply* and click *Ok*.
6. Double click `setup.bat` and let it run the setup process.
7. When prompted to install R, use the default settings.
8. Once everything is complete, the *ParcelManifest* icon should be on your desktop.

** You will be required to install R twice when using the `setup.bat` file. The first is installing R on your main system. The second is installing a portable version of R in the ParcelManifest-R build directory (required for the Electron build process). 

## Why Electron?
Existing software solutions for this problem exists (e.g., `RInno`) that aim to build standalone desktop applications for R-based software solutions, but they are either unsupported or, simply put, don't work. Although Electron is not perfect, it's free and allows us to package up all of the dependencies into a single distributable package.

Additionally, in order for this tool to work, there was one major requirement -- the size of the browser window had to be static and must adhere to a specific width and height dimension. Due to modern browser restrictions, I could not simply use JavaScript to adjust the user's main browser (Chrome, Firefox, etc. block this process for security reasons). The reason this requirement exists is simply the fact the the tool serves as a macro and attempts to perform the same actions that a user will take when inputting entries into the PKMS system. Therefore, this tool uses a "trick" to perform this process, where it "clicks" on the PKMS system GUI (which is outside of the Parcel Manifest program) and then takes control of the user's mouse and keyboard. In order to click outside of the program each time, the program must (1) know how many pixels in needs to travel and (2) prevent the user from modifying the browser window. Electron enabled these requirements.

## Known Issues
The `electricShine::electrify()` function  produces a distributable installer after the build process; however, 
there is an issue where the *setup.exe* installer does not install all of the Electron dependencies. Because of this, 
it leaves the tool in a broken state, where it is unable to start up. Therefore, the `setup.bat` file subverts this and sets the structure up for the user. 

## Disclaimer
*I primarily develop on Unix-based systems, so I apologize for any mistakes or bad practices using Windows.*<br>
All efforts were made to make the setup as streamlined as possible. <br>
Any suggestions for improvement would be greatly appreciated. If you have any insight, please let me know by opening up an issue. 

