# ``Swizzler``

<!--@START_MENU_TOKEN@-->Summary<!--@END_MENU_TOKEN@-->

## Overview

<!--@START_MENU_TOKEN@-->Text<!--@END_MENU_TOKEN@-->

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

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
