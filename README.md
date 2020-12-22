# Disclaimer
Scripts for configuring and building adhell3 apk without requiring any additional installation.
# Available commands
- `adhell3 setup`<br/>
Download and configure all necessary things for compiling an apk. This step is required but only needs to be done once.

- `adhell3 clean setup`<br/>
Re-download everything again before configuring all necessary things for compiling an apk.

- `adhell3 build`<br/>
Only rebuild the apk without getting the latest source from gitlab. Useful if you made local source changes such as coloring adhell3.

- `adhell3 clean build`<br/>
Build the apk by getting the latest source from gitlab (Knox libs and app.properties need to be already copied in the same folder where the script is located). This is the command you will use whenever you need to compile the latest adhell3 build.

- `adhell3 build install`<br/>
Only rebuild and install the apk without getting the latest source from gitlab. Useful if you made local source changes such as coloring adhell3. You have to plug your phone to computer before run this command.

- `adhell3 clean build install`<br/>
Build the apk by getting the latest source from gitlab (Knox libs and app.properties need to be already copied in the same folder where the script is located). This is the command you will use whenever you need to compile and install the latest adhell3 build. You have to plug your phone to computer before run this command.

# Usage
## Knox SDK
- Download latest Knox SDK from https://partner.samsungknox.com/dashboard/download (only available for KPP partners)
- Extract `knoxsdk.jar` respectively from zip file

## app.properties
- Create `app.properties` file with a text editor (such as notepad.exe for Windows)
- Put `package.name=your.package.name` in the first line of the file and replace `your.package.name` with your desired package name
- Make sure that file is in the same folder as your script.
- See also [README on adhell3 repository](https://gitlab.com/fusionjack/adhell3#customization) for additional possible options

## Windows x64
- Download the script `adhell3.cmd` locally to your computer in a new empty folder (e.g. `C:\Adhell3`)
- Open a windows console (Press Windows symbol + R and type `cmd`)
- Go to the folder where you download the script (Use command `cd [path to folder]` e.g. `cd C:\Adhell3`)
- Copy `knoxsdk.jar` to that folder
- Copy `app.properties` to that folder
- Type these in the windows console:
  - `adhell3 setup`
  - `adhell3 clean build`
- The apk is in the same folder as the script named `adhell3_xxx.apk`
- If you have an error: `'7za' is not recognized as an internal or external command, operable program or batch file.`, please download 7za.exe manually from https://github.com/develar/7zip-bin/raw/master/win/x64/7za.exe and put it in the same folder as the script.

## Linux x64
- Download the script `adhell3.sh` locally to your machine in a new empty folder
- Open a terminal console
- Go to the folder where you download the script (Use command `cd [path to folder]` eg `cd ~/Adhell3`)
- Copy `knoxsdk.jar` to that folder
- Copy `app.properties` to that folder
- Type these in the terminal console:
  - `chmod +x adhell3.sh`
  - `bash adhell3.sh setup`
  - `bash adhell3.sh clean build`
- The apk is in the same folder as the script named `adhell3_xxx.apk`

# Credits
- cURL: https://curl.haxx.se/windows/ (Windows)
- 7za: https://github.com/develar/7zip-bin/ (Windows)
- Android SDK: https://developer.android.com/studio/
- AdoptOpenJDK: https://github.com/AdoptOpenJDK/openjdk8-binaries