
platform :ios, ‘12.0’
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
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
            config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
            config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
	    config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
        end
    end
end
