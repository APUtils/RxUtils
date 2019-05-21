#!/bin/bash

set -e

base_dir=$(dirname "$0")
cd "$base_dir"

echo ""

set -o pipefail && xcodebuild -workspace "Pods Project/RxUtils.xcworkspace" -scheme "RxUtils-Example" -configuration "Release" -sdk iphonesimulator | xcpretty

echo ""

xcodebuild -project "Carthage Project/RxUtils.xcodeproj" -target "Example" -sdk iphonesimulator | xcpretty

echo ""
echo "SUCCESS!"
echo ""
