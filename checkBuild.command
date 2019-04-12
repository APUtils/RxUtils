#!/bin/bash

set -e

base_dir=$(dirname "$0")
cd "$base_dir"

echo ""

set -o pipefail && xcodebuild -workspace "Pods Project/RxUtils.xcworkspace" -scheme "RxUtils-Example" -configuration "Release" -sdk iphonesimulator12.1 | xcpretty

echo ""

xcodebuild -project "Carthage Project/RxUtils.xcodeproj" -alltargets -sdk iphonesimulator12.1 | xcpretty

echo ""
echo "SUCCESS!"
echo ""
