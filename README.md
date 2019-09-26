# School bus tracker v0.3


lib\app\geolocator\pages\location_stream_class.dart

send update location to server
create track variable and save update location to it.
get updated in trip, school in trip, supervisor, drivers,.... and draw it correspondly. 

get zone area from server and save it in variables
check updated location in/out zone area.
get path between school, students location.
check update location move in correct path.


draw track in lib\app\g_m_f\mapListStudents.dart
draw update location in lib\app\g_m_f\mapListStudents.dart

#Task not Complete:
create new user not finished
forgetting password.
School Schedule screen.
geolocation Testing
parent app not adaptable yet.
Driver app not adaptable yet.

#Installation:
install android sdk
install flutter 
use any editor, prefer VSCode


#To run app you must:
first only type: flutter packages get in command line. (remember use proxy server)
    C:\App\School bus tracker v0.3\flutter packages get
run Emulator.
type command: flutter run.
    C:\App\School bus tracker v0.3\flutter run

#To make release app version type:
    C:\App\School bus tracker v0.3\flutter build apk
will find apk in path: C:\App\School bus tracker v0.3\build\app\outputs\apk\release\


# To change App icons:

        flutter_icons:
        #  image_path: "assets/images/icon-128x128.png"
        image_path_android: "lib/app/assets/logo.png"
        image_path_ios: "lib/app/assets/logo.png"
        android: true # can specify file name here e.g. "ic_launcher"
        ios: true # can specify file name here e.g. "My-Launcher-Icon"
        #   adaptive_icon_background: "assets/images/christmas-background.png" # only available for Android 8.0 devices and above
        #   adaptive_icon_foreground: "assets/images/icon-foreground-432x432.png" # only available for Android 8.0 devices and above
        
run command:
	flutter pub pub run flutter_launcher_icons:main