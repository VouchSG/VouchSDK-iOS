# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'VouchSDK-iOS' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for VouchSDK
  pod 'Alamofire'
  pod 'FSQCollectionViewAlignedLayout'
  pod 'GrowingTextView', '0.7.1'
  pod 'IQKeyboardManager'
  pod 'SDWebImage'
  pod 'Socket.IO-Client-Swift', '~> 15.1.0'
  pod 'SwiftAudio'
  pod 'SwiftyJSON'
  pod 'UIColor_Hex_Swift'
  
end

# Workaround for Cocoapods issue #7606
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
        config.build_settings['SWIFT_VERSION'] = '5.0'
    end
end
