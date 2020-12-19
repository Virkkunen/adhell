#!/bin/sh

set -e
clear
param1=$1
param2=$2
param3=$3

platform=$(uname)

if [ "$platform" == "Darwin" ]; then
   echo "Detected Mac OS platform"
   jdk_platform=mac
   android_platform=darwin
   file_extension=tar.gz
elif [ "$platform" == "Linux" ]; then
   echo "Detected Linux platform"
   jdk_platform=linux
   android_platform=linux
   file_extension=tar.gz
elif [ "$platform" == "MINGW64_NT-10.0" ]; then
   echo "Detected Windows platform"
   jdk_platform=windows
   android_platform=windows
   file_extension=zip
else
   echo "Detected unkown platform ($platform), force using Linux platform"
   jdk_platform=linux
   android_platform=linux
fi


jdk8_version=8u275b01
jdk8_folder=jdk8u275-b01
jdk8_wildcard_file=OpenJDK8U-jdk_x64_*.$file_extension
jdk8_file=OpenJDK8U-jdk_x64_${jdk_platform}_hotspot_${jdk8_version}.$file_extension
jdk8_url=https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/$jdk8_folder/$jdk8_file

android_sdk_version=6858069
android_sdk_folder=android-sdk
android_sdk_wildcard_file=commandlinetools-*.zip
android_sdk_file=commandlinetools-$android_platform-${android_sdk_version}_latest.zip
android_sdk_url=https://dl.google.com/android/repository/$android_sdk_file

tools_folder=cmdline-tools

adhell3_file=adhell3-master.zip
adhell3_url=https://gitlab.com/fusionjack/adhell3/-/archive/master/$adhell3_file
adhell3_folder=adhell3-master
app_folder=app
libs_folder=app/libs

knoxsdk_jar_file=knoxsdk.jar
app_properties_file=app.properties

if [ "$1" == "setup" ] || ([ "$1" == "clean" ] && [ "$2" == "setup" ]); then
   if [ "$1" == "clean" ]; then
      if [ -d $jdk8_folder ]; then
         echo "Deleting $jdk8_folder ..."
         rm -rf $jdk8_folder
      fi

      if [ -d $android_sdk_folder ]; then
         echo "Deleting $android_sdk_folder ..."
         rm -rf $android_sdk_folder
	  fi

      if [ -d $tools_folder ]; then
         echo "Deleting $tools_folder ..."
         rm -rf $tools_folder
	  fi

      if [ -f $jdk8_wildcard_file ]; then
         echo "Deleting $jdk8_wildcard_file ..."
         rm $jdk8_wildcard_file
	  fi

      if [ -f $android_sdk_wildcard_file ]; then
         echo "Deleting $android_sdk_wildcard_file ..."
         rm $android_sdk_wildcard_file
	  fi
   fi

   if [ ! -f $jdk8_wildcard_file ]; then
      echo "Downloading $jdk8_file ..."
      curl -LO $jdk8_url
   else
      echo "Found $jdk8_file"
   fi

   if [ ! -d $jdk8_folder ]; then
      echo "Extracting $jdk8_file ..."
      if [ "$jdk_platform" == "windows" ]; then
        unzip $jdk8_file
      else
        tar xvf $jdk8_file
      fi
   fi

   if [ ! -f $android_sdk_wildcard_file ]; then
      echo "Downloading $android_sdk_file ..."
      curl -O $android_sdk_url
   else
      echo "Found $android_sdk_file"
   fi

   if [ ! -d $tools_folder ]; then
      echo "Extracting $android_sdk_file ..."
      unzip $android_sdk_file
   fi

   if [ ! -d $android_sdk_folder ]; then
      echo "Configuring Android SDK ..."
      mkdir $android_sdk_folder
      if [ "$jdk_platform" == "mac" ]; then
        export JAVA_HOME=$PWD/$jdk8_folder/Contents/Home/
      else
        export JAVA_HOME=$PWD/$jdk8_folder
      fi
      if [ "$android_platform" == "windows" ]; then
        echo "y" | $tools_folder/bin/sdkmanager.bat "platform-tools" --sdk_root="$PWD/$android_sdk_folder"
      else
        echo "y" | ./$tools_folder/bin/sdkmanager "platform-tools" --sdk_root="$PWD/$android_sdk_folder"
      fi
   fi

elif [ "$1" == "build" ] || ([ "$1" == "clean" ] && [ "$2" == "build" ]); then
   if [ "$1" == "clean" ]; then    
      if [ -f $adhell3_file ]; then
         echo "Deleting $adhell3_file ..."
         rm $adhell3_file
      fi

      if [ -d $adhell3_folder ]; then
         echo "Deleting $adhell3_folder folder ..."
         rm -rf $adhell3_folder
      fi

      echo "Getting latest adhell3 source code from gitlab ..."
      curl -O $adhell3_url
      echo "Extracting $adhell3_file ..."
      unzip $adhell3_file
   fi

   if [ ! -d $jdk8_folder ]; then
      echo "Missing $jdk8_folder folder, please run 'bash adhell3.sh setup'"
      exit 1
   fi

   if [ ! -d $android_sdk_folder ]; then
      echo "Missing $android_sdk_folder folder, please run 'bash adhell3.sh setup'"
      exit 1
   fi

   if [ ! -f $knoxsdk_jar_file ]; then
      echo "Missing $knoxsdk_jar_file file, please get it from Samsung KPP and put it in the same folder where this script is located"
      exit 1
   fi

   if [ ! -f $app_properties_file ]; then
      echo "Missing $app_properties_file file, please create it, set your application id and put it in the same folder where this script is located"
      exit 1
   fi

   if [ "$jdk_platform" == "mac" ]; then
      export JAVA_HOME=$PWD/$jdk8_folder/Contents/Home/
   else
      export JAVA_HOME=$PWD/$jdk8_folder
   fi
   export ANDROID_HOME=$PWD/$android_sdk_folder

   if [ ! -d $adhell3_folder ]; then
     echo "Getting latest adhell3 source code from gitlab ..."
     curl -O $adhell3_url
     echo "Extracting $adhell3_file ..."
     unzip $adhell3_file
   fi

   cd $adhell3_folder
   cp ../$app_properties_file $app_folder/$app_properties_file
   
   if [ ! -d $libs_folder ]; then
      mkdir $libs_folder
   fi

   cp ../$knoxsdk_jar_file $libs_folder/$knoxsdk_jar_file

   chmod +x gradlew
   if ([ "$2" == "install" ] || [ "$3" == "install" ]); then
     echo "Building and installing apk ..."
     ./gradlew clean installDebug --no-daemon
   else
     echo "Building apk ..."
     ./gradlew clean assembleDebug --no-daemon
     cp -f $app_folder/build/outputs/apk/debug/app-debug.apk  ../adhell3_`cat $app_folder/build.properties | grep "number=" | cut -d= -f2`.apk
   fi

   echo
   cat $app_folder/build.properties 

else
   echo "Unknown parameter '$1'"
fi
