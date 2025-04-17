##Workout App Submission

Our submission for Computer Science CPSC-362, Section 08, Workout App Repository

##Group Information

Alan Mai <alanmai3@csu.fullerton.edu > CWID: 885522565
Kevin Quan <kquan8@csu.fullerton.edu > CWID: 861331916
Diana Maldonado <di.maldonado5504@csu.fullerton.edu > CWID: 839805504

##Instructions

Using VSCode(Code Editor) + Android Studio(Mobile App Development/Compile) + Figma(Mobile App Design) + Trello (Task tracking: clipboard)

No additional instructions.

##Student Instrunctions
 flutter clean
 rm -rf build/
 flutter run

 which flutter
 flutter doctor -v
 which dart
 echo $PATH | grep flutter
 source ~/.bashrc
 nano ~/.bashrc
 adb start-server
 adb kill-server
 adb devices
 adb connect 10.255.255.254:5555
 export ADB_SERVER_SOCKET=tcp:10.255.255.254:5037
 telnet 172.27.64.1 5037
 ping -c 4 172.27.64.1

<><><>
 4/6/2025--
 flutter pub outdated
 flutter pub upgrade --major-versions
 GTK theme installed: install the gnome-themes-extra and adwaita-icon-theme packages:
  sudo apt install gnome-themes-extra adwaita-icon-theme
 Remove or comment out these lines:

# export DISPLAY=:0

# export LIBGL_ALWAYS_INDIRECT=1

# export WAYLAND_DISPLAY=wayland-0

# export XDG_RUNTIME_DIR=/mnt/wslg/runtime-dir

 Now run:
 sudo apt install gedit -y
 gedit
  the fact that gedit opened confirms WSLg is officially working and GUI apps are now functional in your WSL2 environment.
<><><>

<><><>
Try:
  ./build/linux/x64/debug/bundle/fitnessapp
Or: This tells Flutter specifically to use the Linux target and might be more stable than auto-detecting.
  flutter run -d linux --verbose

Launch device:
  /mnt/c/Users/dmald/AppData/Local/Android/Sdk/emulator/emulator.exe -avd Pixel_7
Try launching with no terminal detachment:
  flutter run -d linux --no-resident
Or even better — launch it with logging:
  flutter run -d linux -v
But honestly? You’re fine just running the app directly with:
  ./build/linux/x64/debug/bundle/fitnessapp
And if you need to debug:
  flutter attach
<><><>

<><><>
***A note about SDK paths***
If you install Flutter in both Windows and WSL2:
  The Android SDK in WSL2 won’t automatically detect the one installed on Windows unless you manually point to it.
  If needed, in WSL2:
    export ANDROID_SDK_ROOT=/mnt/c/Users/yourname/AppData/Local/Android/Sdk
    (Or in your ~/.bashrc.)
***Linux (WSL2-Ubuntu)***
You can run Linux builds in WSL:
  flutter run -d linux
***Windows***
And Android builds on Windows:
  flutter run -d emulator-5554
<><><><>


***Power Shell***
$& "C:\Users\dmald\AppData\Local\Android\Sdk\emulator\emulator.exe" -list-avds
$emulator -list-avds
  Pixel_7
  Pixel_9_Pro_XL
To lauch it:
& "C:\Users\dmald\AppData\Local\Android\Sdk\emulator\emulator.exe" -avd Pixel_9_Pro_XL
& "C:\Users\dmald\AppData\Local\Android\Sdk\emulator\emulator.exe" -avd Pixel_7

***Power Shell***
flutter doctor
flutter devices:
    Found 4 connected devices:
  sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x64    • Android 15 (API 35) (emulator)
  Windows (desktop)            • windows       • windows-x64    • Microsoft Windows [Version 10.0.26100.3624]
  Chrome (web)                 • chrome        • web-javascript • Google Chrome 135.0.7049.41
  Edge (web)                   • edge          • web-javascript • Microsoft Edge 134.0.3124.72
flutter emulators:
  Id              Name            Manufacturer    Platform
  Pixel_7        • Pixel 7        • Google       • android
  Pixel_9_Pro_XL • Pixel 9 Pro XL • Google       • android
flutter emulators
flutter run -d emulator-5554
To run an emulator, run:
  #flutter emulators --launch <emulator id>
  #flutter emulators --launch Pixel_7
  & "C:\Users\dmald\AppData\Local\Android\Sdk\emulator\emulator.exe" -avd Pixel_7

Try:
  flutter run -d android
  flutter run -d Pixel_7
  flutter run -d emulator-5554
  & "C:\Users\dmald\AppData\Local\Android\Sdk\emulator\emulator.exe" -avd Pixel_7



***Terminal Types***

Purpose                           Terminal to Use                     Notes

🧪 Test Android app         ✅ PowerShell or CMD on Windows          Emulators & flutter run -d android work here

🧪 Test Linux desktop       ✅ WSL2 (Ubuntu)                         Run flutter run -d linux here

⚙️ Create emulators         ✅ Android Studio (GUI) or PowerShell    Use AVD Manager or CLI

🧰 Edit code                ✅ VS Code (open from Windows or WSL2)   Both work, depending on the target device
