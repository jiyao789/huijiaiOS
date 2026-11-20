
platform :ios, '15.0'
#use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'
#source 'https://github.com/aliyun/aliyun-specs.git'
# source 'https://cdn.cocoapods.org/'

target 'StandardApplication' do
  pod 'GKNavigationBarViewController'
  pod 'AFNetworking'
  pod 'MJRefresh'
  pod 'MJExtension'
  pod 'SDWebImage'
  pod 'SDWebImageWebPCoder'
  pod 'MBProgressHUD', '~> 1.1.0'
  pod 'IQKeyboardManager'
  pod 'Realm'
  pod 'JXCategoryView'
  pod 'Masonry'
  pod 'FreeStreamer', '~> 3.7.2'
  pod 'YBPopupMenu'

  pod 'UMCommon', '7.4.6'   #必须集成
  pod 'UMDevice', '3.4.0'   #必须集成
  pod 'UMShare/Social/ReducedWeChat', '6.10.10'
    
  pod 'AliPay_SDK'
  pod 'WechatOpenSDK-XCFramework', "~>2.0.4"
  
  pod 'ReactiveCocoa','~>2.1.8'

  pod 'AMap2DMap-NO-IDFA'
  pod 'AMapSearch-NO-IDFA'
  pod 'AMapLocation-NO-IDFA'
  
  # 默认为 AVPlayer
  pod 'SJBaseVideoPlayer/AliPlayer'
  pod 'SJVideoPlayer'
  pod 'SJUIKit'
  pod 'MatomoTracker'
  pod 'LookinServer', :configurations => ['Debug']

  pod 'Bugly'
  pod 'YYText'
  pod "Qiniu", "~> 7.4.3"
  pod 'QMUIKit'
  pod 'coobjc'
  
  pod 'FSCalendar'
  pod 'TTLock'
end

post_install do |installer|
    # 1. 统一 Pods 项目级配置为 15.0
    installer.pods_project.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end

    # 2. 统一所有 Target 配置
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
            config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'

            # 屏蔽第三方老库在 Xcode 16 下的括号/链式比较语法警告阻断
            c_flags = config.build_settings['OTHER_CFLAGS'] || ['$(inherited)']
            c_flags = [c_flags] if c_flags.is_a?(String)
            c_flags << '-Wno-error=parentheses' unless c_flags.include?('-Wno-error=parentheses')
            c_flags << '-Wno-parentheses' unless c_flags.include?('-Wno-parentheses')
            config.build_settings['OTHER_CFLAGS'] = c_flags
        end

        # 仅针对资源 Bundle Target 关闭代码签名，避免 Xcode 14+ 签名报错；绝不关闭普通 Framework/库的签名
        if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
            target.build_configurations.each do |config|
                config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
                config.build_settings['CODE_SIGNING_REQUIRED'] = 'NO'
            end
        end
    end

    # 3. 兼容多 project 架构
    if installer.respond_to?(:generated_projects)
        installer.generated_projects.each do |project|
            project.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
            end
            project.targets.each do |target|
                target.build_configurations.each do |config|
                    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
                end
            end
        end
    end

    # 4. 自动修补 YYTextLayout.m 中的链式比较 bug
    pods_root = installer.sandbox.root.to_s
    Dir.glob("#{pods_root}/**/YYTextLayout.m").each do |file|
        begin
            if File.exist?(file)
                File.chmod(0644, file)
                content = File.read(file)
                patched = content.gsub(/fabs\(([^)]+)\)\s*<\s*fabs\(([^)]+)\)\s*<\s*\((right\s*\?\s*prev\s*:\s*next)\)/, '(fabs(\1) < fabs(\2)) ? prev : next')
                if patched != content
                    File.write(file, patched)
                    puts "==> Successfully patched YYTextLayout.m chained comparison bug"
                end
            end
        rescue => e
            puts "==> Note: YYTextLayout.m patch skipped (#{e.message})"
        end
    end

    # 5. 解决 Xcode 16 禁止引入系统私有头文件 netinet6/in6.h 的问题 (SJReachability 等)
    Dir.glob("#{pods_root}/**/*.{m,mm,h}").each do |file|
        begin
            if File.exist?(file)
                content = File.read(file)
                if content.include?("<netinet6/in6.h>")
                    File.chmod(0644, file)
                    patched = content.gsub(/#import\s*<netinet6\/in6\.h>/, '// #import <netinet6/in6.h>')
                    File.write(file, patched)
                    puts "==> Successfully patched netinet6/in6.h in #{File.basename(file)}"
                end
            end
        rescue => e
            # ignore
        end
    end
end
