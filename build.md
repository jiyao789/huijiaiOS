open -a simulator
xcrun simctl install booted /路径/xxx.app

rm -rf ~/Library/Developer/Xcode/DerivedData/*


构建:
- ./build.sh              - Build for real device (default)
- ./build.sh simulator    - Build for Intel simulator (x86_64)
- ./build.sh device       - Build for real device

### 下载到模拟器
xcrun simctl install booted /Users/jjy/Documents/iOS_huijia3.0/build/Debug-iphonesimulator/StandardApplication.app

方法1：实时查看所有API请求和响应（推荐）

  # 在终端运行此命令，然后操作app
  xcrun simctl spawn booted log stream --level default --predicate 'eventMessage CONTAINS "=====" OR eventMessage CONTAINS "tok"' --style compact --color auto

  这会显示：
  - 请求URL和参数（包含sign）
  - 响应数据
  - token信息

  方法2：使用Console.app（图形界面）

  1. 打开 /Applications/Utilities/Console.app
  2. 在左侧选择当前运行的模拟器
  3. 在搜索框输入：process:StandardApplication
  4. 在消息过滤器中输入：===== 来只看API日志

  方法3：查看更详细的日志

  # 查看所有NSLog输出
  xcrun simctl spawn booted log stream --process StandardApplication --style compact

  🔄 重新安装修复后的app

  # 1. 重新安装
  xcrun simctl install booted /Users/jjy/Documents/iOS_huijia3.0/build/Debug-iphonesimulator/StandardApplication.app

  # 2. 启动app并查看日志（在另一个终端窗口）
  xcrun simctl spawn booted log stream --level default --predicate 'eventMessage CONTAINS "=====" OR eventMessage CONTAINS "tok"' --style compact

iOS App 的可执行文件位置

  构建完成后,iOS app 的可执行文件位于:

  ~/Library/Developer/Xcode/DerivedData/StandardApplication-<hash>/Build/Pro
  ducts/Debug-iphonesimulator/StandardApplication.app/

  其中 <hash> 是一个随机生成的字符串(类似 ajawercivjtbktabvpcvaogjhomn)。

  完整的App Bundle结构:

  StandardApplication.app/
  ├── StandardApplication        # 这是主可执行文件(Mach-O 二进制文件)
  ├── Info.plist                 # App配置信息
  ├── Frameworks/                # 嵌入的框架
  ├── *.nib                      # 界面文件
  ├── Assets.car                 # 资源文件
  └── ...其他资源文件

  如何找到和使用:

  1. 查找 .app 文件:
  find ~/Library/Developer/Xcode/DerivedData -name "StandardApplication.app"
   -type d

  2. 检查可执行文件:
  # 替换 <path> 为上面找到的路径
  ls -lh <path>/StandardApplication.app/StandardApplication

  3. 在模拟器中运行:
  可执行文件不能直接运行,需要通过 Xcode 或 simctl 在模拟器中运行:
  xcrun simctl boot "iPhone 16"  # 启动模拟器
  xcrun simctl install booted <path>/StandardApplication.app  # 安装app
  xcrun simctl launch booted com.your.bundle.identifier  # 运行app


解决方案总结

  之前的错误 Build input file cannot be found: 
  StandardApplication.debug.dylib 是由于 Xcode 构建缓存损坏导致的。

  执行的修复步骤:

  1. 清理 DerivedData - 删除了 Xcode 的派生数据缓存
  2. 执行 Clean Build - 清理了项目的构建产物
  3. 重新构建项目 - 成功重新构建项目

  构建结果:

  构建现在成功完成,虽然有一些警告(主要是关于某些 CocoaPods
  依赖项的部署目标版本过低),但这些都是非阻塞性警告,不影响项目的正常运行。

  如果将来再次遇到类似问题,可以运行以下命令快速修复:

  # 清理 DerivedData
  rm -rf ~/Library/Developer/Xcode/DerivedData/StandardApplication-*

  # 清理项目
  xcodebuild clean -workspace StandardApplication.xcworkspace -scheme
  StandardApplication

  # 重新构建
  xcodebuild -workspace StandardApplication.xcworkspace -scheme
  StandardApplication -sdk iphonesimulator build