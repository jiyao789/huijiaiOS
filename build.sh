#!/bin/bash

# ╭━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╮
# ┃                     赛 博 佛 祖 保 佑 代 码                      ┃
# ╰━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯
cat << 'EOF'

                   _ooOoo_
                  o8888888o
                  88" . "88
                  (| -_- |)
                  O\  =  /O
               ____/`---'\____
             .'  \\|     |//  `.
            /  \\|||  :  |||//  \
           /  _||||| -:- |||||-  \
           |   | \\\  -  /// |   |
           | \_|  ''\---/''  |   |
           \  .-\__  `-`  ___/-. /
         ___`. .'  /--.--\  `. . __
      ."" '<  `.___\_<|>_/___.'  >'"".
     | | :  `- \`.;`\ _ /`;.`/ - ` : | |
     \  \ `-.   \_ __\ /__ _/   .-` /  /
======`-.____`-.___\_____/___.-`____.-'======
                   `=---='
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
            佛祖保佑       永无BUG
EOF

# Build script for StandardApplication
# This script addresses known build issues with the project
#
# Usage:
#   ./build.sh              - Build for real device (default)
#   ./build.sh simulator    - Build for Intel simulator (x86_64)
#   ./build.sh device       - Build for real device

TARGET="${1:-device}"
BUILD_LOG="/tmp/xcodebuild_$$.log"

echo ""
echo "🙏 启动佛光编译模式... 佛祖正在为代码注入无BUG结界 🙏"
echo ""

# Clean build
echo "🧹 清理构建产物 (扫除业障)..."
rm -rf ~/Library/Developer/Xcode/DerivedData/StandardApplication-*
xcodebuild clean -workspace StandardApplication.xcworkspace -scheme StandardApplication -configuration Debug >/dev/null 2>&1

# Common build settings
# ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES=NO - This is an Objective-C project, no Swift libs needed
# ENABLE_DEBUG_DYLIB=NO - Disable debug dylib generation which was causing build errors

if [ "$TARGET" == "simulator" ]; then
    echo "📱 构建 Intel 模拟器版本 (x86_64)..."
    echo "💡 佛祖提示：Apple Silicon Mac 将通过 Rosetta 运行"
    xcodebuild -workspace StandardApplication.xcworkspace \
               -scheme StandardApplication \
               -configuration Debug \
               -sdk iphonesimulator \
               build \
               ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES=NO \
               ENABLE_DEBUG_DYLIB=NO \
               ARCHS=x86_64 \
               VALID_ARCHS=x86_64 \
               ONLY_ACTIVE_ARCH=YES \
               2>&1 | tee "$BUILD_LOG"
    # 判断是否真正构建成功（以 Xcode 日志为准）
    if grep -q "\*\* BUILD SUCCEEDED \*\*" "$BUILD_LOG"; then
        BUILD_SUCCEEDED=1
    else
        BUILD_SUCCEEDED=0
    fi


    BUILD_EXIT_CODE=${PIPESTATUS[0]}
    PRODUCT_PATH="Debug-iphonesimulator"
else
    echo "📱 构建真机版本..."
    echo "💡 佛祖提示：开发构建已禁用代码签名"
    xcodebuild -workspace StandardApplication.xcworkspace \
               -scheme StandardApplication \
               -configuration Debug \
               -sdk iphoneos \
               build \
               ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES=NO \
               ENABLE_DEBUG_DYLIB=NO \
               CODE_SIGN_IDENTITY="" \
               CODE_SIGNING_REQUIRED=NO \
               CODE_SIGNING_ALLOWED=NO \
               2>&1 | tee "$BUILD_LOG"
    # 判断是否真正构建成功（以 Xcode 日志为准）
    if grep -q "\*\* BUILD SUCCEEDED \*\*" "$BUILD_LOG"; then
        BUILD_SUCCEEDED=1
    else
        BUILD_SUCCEEDED=0
    fi

    BUILD_EXIT_CODE=${PIPESTATUS[0]}
    PRODUCT_PATH="Debug-iphoneos"
fi

# Find executable
EXECUTABLE=$(find ~/Library/Developer/Xcode/DerivedData/StandardApplication-*/Build/Products/$PRODUCT_PATH/StandardApplication.app/StandardApplication -type f 2>/dev/null | head -1)

if [ "$BUILD_SUCCEEDED" -eq 1 ]; then
    echo ""
    cat << 'SUCCESS'
✅✅✅ 佛光普照！构建圆满成功！✅✅✅
SUCCESS

    if [ -n "$EXECUTABLE" ]; then
        echo "📦 可执行文件路径："
        echo "$EXECUTABLE"
    else
        echo "📦 构建成功（未定位到可执行文件路径）可以尝试执行："
        echo "xcrun simctl install booted /Users/jjy/Documents/iOS_huijia3.0/build/Debug-iphonesimulator/StandardApplication.app"
    fi

    rm -f "$BUILD_LOG"
    exit 0
else
    echo ""
    cat << 'FAILURE'
❌❌❌ 构建失败 ❌❌❌
FAILURE

    echo ""
    echo "📋 构建错误详情："
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    if [ -f "$BUILD_LOG" ]; then
        grep -A 3 "error:" "$BUILD_LOG" | head -50
        grep -i "BUILD FAILED" "$BUILD_LOG" | head -5
    fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📄 完整日志: $BUILD_LOG"
    exit 1
fi
