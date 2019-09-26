F:\School Bus\Project\App\School bus tracker App v0.32>flutter build apk
You are building a fat APK that includes binaries for android-arm, android-arm64.
If you are deploying the app to the Play Store, it's recommended to use app bundles or split the APK to reduce the APK size.
    To generate an app bundle, run:
        flutter build appbundle --target-platform android-arm,android-arm64
        Learn more on: https://developer.android.com/guide/app-bundle
    To split the APKs per ABI, run:
        flutter build apk --target-platform android-arm,android-arm64 --split-per-abi
        Learn more on:  https://developer.android.com/studio/build/configure-apk-splits#configure-abi-split
Initializing gradle...                                              1.8s
Resolving dependencies...                                          10.6s
Running Gradle task 'assembleRelease'...


FAILURE: Build failed with an exception.



* What went wrong:

Execution failed for task ':app:lintVitalRelease'.

> Could not resolve all artifacts for configuration ':app:debugAndroidTestRuntimeClasspath'.

   > Could not find espresso-core.aar (androidx.test.espresso:espresso-core:3.1.0-alpha3).

     Searched in the following locations:

         https://dl.google.com/dl/android/maven2/androidx/test/espresso/espresso-core/3.1.0-alpha3/espresso-core-3.1.0-alpha3.aar

   > Could not find runner.aar (androidx.test:runner:1.1.0-alpha3).

     Searched in the following locations:

         https://dl.google.com/dl/android/maven2/androidx/test/runner/1.1.0-alpha3/runner-1.1.0-alpha3.aar

   > Could not find monitor.aar (androidx.test:monitor:1.1.0-alpha3).

     Searched in the following locations:

         https://dl.google.com/dl/android/maven2/androidx/test/monitor/1.1.0-alpha3/monitor-1.1.0-alpha3.aar

   > Could not find espresso-idling-resource.aar (androidx.test.espresso:espresso-idling-resource:3.1.0-alpha3).

     Searched in the following locations:

         https://dl.google.com/dl/android/maven2/androidx/test/espresso/espresso-idling-resource/3.1.0-alpha3/espresso-idling-resource-3.1.0-alpha3.aar



* Try:

Run with --stacktrace option to get the stack trace. Run with --info or --debug option to get more log output. Run with --scan to get full insights.



* Get more help at https://help.gradle.org



BUILD FAILED in 7s
Running Gradle task 'assembleRelease'...                            8.2s
*******************************************************************************************
The Gradle failure may have been because of AndroidX incompatibilities in this Flutter app.
See https://goo.gl/CP92wY for more information on the problem and how to fix it.
*******************************************************************************************
Gradle task assembleRelease failed with exit code 1


############################# Solve: #############################

android/app/build.gradle

lintOptions {
        disable 'InvalidPackage'
        checkReleaseBuilds false // add this line.
}

##################################################################
