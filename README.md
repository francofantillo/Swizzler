# ``Swizzler``

## Overview

This is a framework used for documenting HTTP traffic.  Every time a request is made it will print it to the console, and also log it in a JSON file in the devices documents folder.

## Commands For Generating XC Framework:

Navigate to the directory of the projects and enter these commands in terminal.

xcodebuild archive \
-scheme Swizzler \
-configuration Release \
-destination 'platform=macOS,arch=x86_64,variant=Mac Catalyst' \
-archivePath './build/Swizzler.framework-catalyst.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
-scheme Swizzler \
-configuration Release \
-destination 'generic/platform=iOS Simulator' \
-archivePath './build/Swizzler.framework-iphonesimulator.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
-scheme Swizzler \
-configuration Release \
-destination 'generic/platform=iOS' \
-archivePath './build/Swizzler.framework-iphoneos.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild -create-xcframework \
-framework './build/Swizzler.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/Swizzler.framework' \
-framework './build/Swizzler.framework-iphoneos.xcarchive/Products/Library/Frameworks/Swizzler.framework' \
-framework './build/Swizzler.framework-catalyst.xcarchive/Products/Library/Frameworks/Swizzler.framework' \
-output './build/Swizzler.xcframework'

## Adding Framework To a Project:

You can generate the framework using the above commands or use the framework already generated included with this prject in the build folder.

1. Go to the general tab of you xcodeproj file.
2. Select your target
3. Drag and drop the xcframework from the build file.
4. Open your app delegate file in your project.
5. For swift:

Add the following import
```
import Swizzler
```
Add the following code to didfinishlaunching method
```
URLSessionObserver.shared.start()
```
6. For Objective-C

Add the following import:
```
#import <Swizzler/Swizzler.h>
```
Add the following code to didfinishlaunching method
```
URLSessionObserver *observer = [URLSessionObserver shared];
[observer start];
```
