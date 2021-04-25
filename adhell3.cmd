@echo off
cd %cd%
cls
IF EXIST "%PROGRAMFILES(X86)%" (
  SET curl_os=win64
  SET zip_os=x64
  SET jdk_os=x64
) ELSE (
  SET curl_os=win32
  SET zip_os=ia32
  SET jdk_os=x86-32
)
echo Detected %jdk_os% bit system

SET curl_version=7.74.0_1
SET curl_file=curl-%curl_version%-%curl_os%-mingw.zip
SET curl_url=https://curl.se/windows/dl-%curl_version%/%curl_file%
SET curl_folder=curl-%curl_version%-%curl_os%-mingw
SET curl_bin=%curl_folder%\bin\curl.exe
SET curl_param=-k

SET zip_file=7za.exe
SET zip_os_file=7za_%zip_os%.exe
SET zip_url=https://github.com/develar/7zip-bin/raw/master/win/%zip_os%/%zip_file%

SET jdk8_version=8u275b01
SET jdk8_folder=jdk8u275-b01
SET jdk8_file=OpenJDK8U-jdk_%jdk_os%_windows_hotspot_%jdk8_version%.zip
SET jdk8_wildcard_file=OpenJDK8U-jdk_%jdk_os%_windows_hotspot_*.zip
SET jdk8_url=https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/%jdk8_folder%/%jdk8_file%

SET android_sdk_version=6858069
SET android_sdk_file=commandlinetools-win-%android_sdk_version%_latest.zip
SET android_sdk_wildcard_file=commandlinetools-win-*.zip
SET android_sdk_url=https://dl.google.com/android/repository/%android_sdk_file%
SET android_sdk_folder=android-sdk
SET tools_folder=cmdline-tools

SET adhell3_file=adhell3-master.zip
SET adhell3_url=https://gitlab.com/fusionjack/adhell3/-/archive/master/%adhell3_file%
SET adhell3_folder=adhell3-master
SET app_folder=app
SET libs_folder=app\libs

SET knoxsdk_jar_file=knoxsdk.jar
SET app_properties_file=app.properties

SET param1=%1
SET param2=%2
SET param3=%3

IF /i [%param1%] == [clean] IF /i [%param2%] == [setup] GOTO clean_setup_adhell3
IF /i [%param1%] == [clean] IF /i [%param2%] == [build] GOTO clean_build_adhell3
IF /i [%param1%] == [setup] GOTO setup_adhell3
IF /i [%param1%] == [build] GOTO build_adhell3
GOTO error
goto:eof

:clean_setup_adhell3
IF EXIST %jdk8_folder% (
  echo Deleting %jdk8_folder% ...
  del /f /s /q %jdk8_folder% 1>nul
  rmdir /s /q %jdk8_folder%
)

IF EXIST %android_sdk_folder% (
  echo Deleting %android_sdk_folder% ...
  del /f /s /q %android_sdk_folder% 1>nul
  rmdir /s /q %android_sdk_folder%
)

IF EXIST %tools_folder% (
  echo Deleting %tools_folder% ...
  del /f /s /q %tools_folder% 1>nul
  rmdir /s /q %tools_folder%
)

rem del %curl_file%
rem del %zip_os_file%

IF EXIST "%jdk8_wildcard_file%" (
  echo Deleting %jdk8_wildcard_file% ...
  del %jdk8_wildcard_file%
)

IF EXIST "%android_sdk_wildcard_file%" (
  echo Deleting %android_sdk_wildcard_file% ...
  del %android_sdk_wildcard_file%
)
goto setup_adhell3

:setup_adhell3
IF NOT EXIST "%zip_os_file%" (
  IF /i [%zip_os%] == [x64] (
    echo Downloading %zip_file% ...
    bitsadmin /transfer "7za" /download /priority foreground %zip_url% "%cd%\%zip_os_file%" || goto :error
  ) ELSE (
    echo Please download, rename %zip_file% to %zip_os_file% and copy it to script folder from:
    echo %zip_url%
    goto:eof
  )
) ELSE (
  echo Found %zip_os_file%
)

IF NOT EXIST "%curl_file%" (
  IF /i [%curl_os%] == [win64] (
    echo Downloading %curl_file% ...
    bitsadmin /transfer "cURL" /download /priority foreground %curl_url% "%cd%\%curl_file%" || goto :error
  ) ELSE (
    echo Please download, copy %curl_file% to script folder and unzip it from:
    echo %curl_url%
    goto:eof
  )
) ELSE (
  echo Found %curl_file%
)

IF NOT EXIST %curl_folder% (
  echo Extracting %curl_file% ...
  %zip_os_file% x %curl_file% || goto :error
)

IF NOT EXIST "%jdk8_wildcard_file%" (
  echo Downloading %jdk8_file% ...
  %curl_bin% %curl_param% -LO %jdk8_url% || goto :error
) ELSE (
  echo Found %jdk8_file%
)

IF NOT EXIST %jdk8_folder% (
  echo Extracting %jdk8_file% ...
  %zip_os_file% x %jdk8_file% || goto :error
)

IF NOT EXIST "%android_sdk_wildcard_file%" (
  echo Downloading %android_sdk_file% ...
  %curl_bin% %curl_param% -LO %android_sdk_url% || goto :error
) ELSE (
  echo Found %android_sdk_file%
)

IF NOT EXIST %tools_folder% (
  echo Extracting %android_sdk_file% ...
  %zip_os_file% x %android_sdk_file% || goto :error
)

IF NOT EXIST %android_sdk_folder% (
  echo Configuring Android SDK ...
  mkdir %android_sdk_folder% || goto :error
  SET JAVA_HOME=%cd%\%jdk8_folder%\jre
  echo y|%tools_folder%\bin\sdkmanager "platform-tools" --sdk_root="%cd%\%android_sdk_folder%" || goto :error
)
goto:eof

:clean_build_adhell3
echo Cleaning build ...

IF EXIST "%adhell3_file%" (
  echo Deleting %adhell3_file% ...
  del %adhell3_file%
)

IF EXIST %adhell3_folder% (
  echo Deleting %adhell3_folder% folder ...
  del /f /s /q %adhell3_folder% 1>nul
  rmdir /s /q %adhell3_folder%
)

echo Getting latest adhell3 source code from gitlab ...
%curl_bin% %curl_param% -LO %adhell3_url% || goto :error

echo Extracting %adhell3_file% ...
%zip_os_file% x %adhell3_file% || goto :error
goto:build_adhell3

:build_adhell3
IF NOT EXIST %jdk8_folder% (
  echo Missing "%jdk8_folder%" folder, please run "adhell3 setup"
  exit /b
)

IF NOT EXIST %android_sdk_folder% (
  echo Missing "%android_sdk_folder%" folder, please run "adhell3 setup"
  exit /b
)

IF NOT EXIST "%knoxsdk_jar_file%" (
  echo Missing "%knoxsdk_jar_file%" file, please get it from Samsung KPP and put it in the same folder where this script is located
  exit /b
)

IF NOT EXIST "%app_properties_file%" (
  echo Missing "%app_properties_file%" file, please create it, set your application id and put it in the same folder where this script is located
  exit /b
)

IF NOT EXIST %adhell3_folder% (
  echo Getting latest adhell3 source code from gitlab ...
  %curl_bin% %curl_param% -LO %adhell3_url% || goto :error

  echo Extracting %adhell3_file% ...
  %zip_os_file% x %adhell3_file% || goto :error
)

SET JAVA_HOME=%cd%\%jdk8_folder%\jre
SET ANDROID_HOME=%cd%\%android_sdk_folder%

IF /i [%param2%] == [install] goto install
IF /i [%param3%] == [install] goto install

echo Building apk ...
cd %adhell3_folder%
copy ..\%app_properties_file% %app_folder%
IF NOT EXIST %libs_folder% (
  mkdir %libs_folder% || goto :error
)
copy ..\%knoxsdk_jar_file% %libs_folder% || goto :error
call gradlew clean assembleDebug --no-daemon || goto :error
For /F "Tokens=*" %%I in ('findstr number app\build.properties') Do set build_number=%%I
set build_number=%build_number:~13,5%
copy app\build\outputs\apk\debug\app-debug.apk ..\adhell3_%build_number%.apk || goto :error
echo.
type app\build.properties
cd ..
goto:eof

:install
echo Building and installing apk ...
cd %adhell3_folder% || goto :error
copy ..\%app_properties_file% %app_folder% || goto :error
IF NOT EXIST %libs_folder% (
  mkdir %libs_folder% || goto :error
)
copy ..\%knoxsdk_jar_file% %libs_folder% || goto :error
call gradlew clean installDebug --no-daemon || goto :error
For /F "Tokens=*" %%I in ('findstr number app\build.properties') Do set build_number=%%I
set build_number=%build_number:~13,5%
copy app\build\outputs\apk\debug\app-debug.apk ..\adhell3_%build_number%.apk || goto :error
echo.
type app\build.properties
cd ..
goto:eof

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%
