#!/bin/bash

### Script to update frameworks ###

# Colors Constants
red_color='\033[0;31m'
green_color='\033[0;32m'
blue_color='\033[0;34m'
no_color='\033[0m'

# Font Constants
bold_text=$(tput bold)
normal_text=$(tput sgr0)

# Xcodeproj is required
hash xcodeproj 2>/dev/null || { printf >&2 "\n${red_color}Xcodeproj is required. Run 'sudo gem install xcodeproj'${no_color}\n\n"; exit 1; }

# Any subsequent(*) commands which fail will cause the shell script to exit immediately
set -e

# Assume scripts are placed in /Scripts/Carthage dir
base_dir=$(dirname "$0")
cd "$base_dir"
cd ..
cd ..

# Try one level up if didn't find Cartfile.
if [ ! -f "Cartfile" ]; then
    cd ..

    if [ ! -f "Cartfile" ]; then
        printf >&2 "\n${red_color}Unable to locate 'Cartfile'${no_color}\n\n"
        exit 1
    fi

    scripts_dir="${PWD##*/}/Scripts/Carthage/"

else
    scripts_dir="Scripts/Carthage/"
fi

framework_name=$1

if [ -z $framework_name ]; then
    # Listing available frameworks
    echo ""
    echo "Frameworks list:"

    # Blue color
    printf '\033[0;34m'

    # Frameworks list
    grep -o -E "^git.*|^binary.*" Cartfile | sed -E "s/(github \"|git \"|binary \")//" | sed -e "s/\".*//" | sed -e "s/^.*\///" -e "s/\".*//" -e "s/.json//" | sort -f

    # No color
    printf '\033[0m'
    echo ""

    # Asking which one to update
    read -p "Which framework to update? You can enter several separating with space. Press enter to update all: " framework_name
fi

# https://github.com/mapbox/mapbox-navigation-ios/blob/master/scripts/wcarthage.sh
echo "Applying Xcode 12 workaround..."

rm -rf ${TMPDIR}TemporaryItems/*carthage*

xcconfig=$(mktemp /tmp/static.xcconfig.XXXXXX)
trap 'rm -f "${xcconfig}"' INT TERM HUP EXIT

# For Xcode 12 make sure EXCLUDED_ARCHS is set to arm architectures otherwise
# the build will fail on lipo due to duplicate architectures.
echo 'EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200 = arm64 arm64e armv7 armv7s armv6 armv8' >> $xcconfig
echo 'EXCLUDED_ARCHS = $(inherited) $(EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_$(EFFECTIVE_PLATFORM_SUFFIX)__NATIVE_ARCH_64_BIT_$(NATIVE_ARCH_64_BIT)__XCODE_$(XCODE_VERSION_MAJOR))' >> $xcconfig

export XCODE_XCCONFIG_FILE="${xcconfig}"
echo "Workaround applied. xcconfig here: ${XCODE_XCCONFIG_FILE}"

# Update framework(s)
echo "Synchronizing Carthage dependencies..."
carthage update ${framework_name} --platform iOS --cache-builds --use-ssh
echo ""

# Update md5 check sum
cartSum=`{ cat Cartfile.resolved; xcrun swift -version; } | md5`
echo $cartSum > Carthage/cartSum.txt
