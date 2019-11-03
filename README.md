

## Create keystore file.
- Command [keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key]

## Build Android APK
- Command [flutter clean]
- Command [flutter build apk --release]
- Located [build/app/outputs/apk/release/app-release.apk]

## Build iOS IPA
- Command [flutter clean]
- Command [flutter build ios --release]
- Then go to PRODUCT -> ARCHIVE in XCODE

## Beautify Flutter Code
- Command [shift + option + f]

## Splash Screen
mipmap-xxxhdpi in the Android folder when using App Icon tends to work best for both platforms.

# How to Add Local Project to Bit Bucket
Git clone an existing repository.
git init
git remote add origin [my-repo]
git fetch
git checkout origin/master -ft
(If shit not pushing, use 'git push -f origin master')

# ERROR FIX
pod update
"NameError - uninitialized constant Concurrent::Promises, Did you mean?  Concurrent::Promise"
sudo gem update concurrent-ruby

# iOS Swift Version Error
Bridging Header must be created.
Open the project with XCode. Then choose File -> New -> File -> Swift File.
A dialog will be displayed when creating the swift file(Since this file is deleted, any name can be used.). XCode will ask you if you wish to create Bridging Header, click yes.
Make sure you have use_frameworks! in the Runner block, in ios/Podfile。
Make sure you have SWIFT_VERSION 4.2 selected in you XCode -> Build Settings
Do flutter clean
Go to your ios folder, delete Podfile.lock and Pods folder and then execute pod install --repo-update
Thank you for giving detailed report!!

#Firebase App Distribution Process
#iOS
- Archive app
- “Distribute App” in Organizer Window
- Select a Method of Distribution, “Ad Hoc”
- Ad Hoc Distribution Settings, “Next”
- Re-sign Runner, “Automatically manage signing”
- Review Runner.ipa content, “Export”
- Select Download Location
- Drag the Runner.ipa to the box inside the App Distribution box.
- “Add Testers or Groups”
- Enter email of testers, select “Next”
- Add release notes, select “Distribute to ? Testers”
- Go to email and look for innovation to test app.
