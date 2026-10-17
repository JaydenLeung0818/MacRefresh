#!/bin/bash
# build.sh — compile MacRefresh into MacRefresh.app
#
# Usage:
#   ./build.sh                 # native architecture for this Mac
#   UNIVERSAL=1 ./build.sh     # universal arm64 + x86_64 binary
#
# Requires Xcode Command Line Tools (xcrun). No third-party dependencies.
set -e
cd "$(dirname "$0")"
PROJ="$(pwd)"
APP="$PROJ/MacRefresh.app"
VER="1.0.0"
BID="com.macrefresh.fixed"
DEPLOY="12.4"   # minimum macOS version

echo "== Preparing bundle =="
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key><string>MacRefresh</string>
    <key>CFBundleDisplayName</key><string>MacRefresh</string>
    <key>CFBundleIdentifier</key><string>$BID</string>
    <key>CFBundleExecutable</key><string>MacRefresh</string>
    <key>CFBundleIconFile</key><string>AppIcon</string>
    <key>CFBundleShortVersionString</key><string>$VER</string>
    <key>CFBundleVersion</key><string>1</string>
    <key>CFBundlePackageType</key><string>APPL</string>
    <key>LSMinimumSystemVersion</key><string>$DEPLOY</string>
    <key>NSHighResolutionCapable</key><true/>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2026 MacRefresh contributors. Free, open-source software.</string>
    <key>NSAppTransportSecurity</key>
    <dict><key>NSAllowsArbitraryLoads</key><true/></dict>
</dict>
</plist>
PLIST

cp "$PROJ/AppIcon.icns" "$APP/Contents/Resources/AppIcon.icns"

BIN="$APP/Contents/MacOS/MacRefresh"
SOURCES="$PROJ"/src/*.swift

if [ "${UNIVERSAL:-0}" = "1" ]; then
  echo "== Compiling universal (arm64 + x86_64) =="
  TMP="$(mktemp -d)"
  xcrun swiftc -O -swift-version 5 -target arm64-apple-macosx"$DEPLOY"  $SOURCES -o "$TMP/MacRefresh.arm64"
  xcrun swiftc -O -swift-version 5 -target x86_64-apple-macosx"$DEPLOY" $SOURCES -o "$TMP/MacRefresh.x86_64"
  lipo -create -output "$BIN" "$TMP/MacRefresh.arm64" "$TMP/MacRefresh.x86_64"
  rm -rf "$TMP"
else
  echo "== Compiling native ($(uname -m)) =="
  xcrun swiftc -O -swift-version 5 -target "$(uname -m)-apple-macosx$DEPLOY" \
    $SOURCES -o "$BIN"
fi

echo "== Ad-hoc signing =="
codesign --force --deep --sign - "$APP"

echo "== Built =="
echo "Version: $(defaults read "$APP/Contents/Info.plist" CFBundleShortVersionString)"
echo "Arch:    $(lipo -archs "$BIN" 2>/dev/null || uname -m)"
echo "App:     $APP"
