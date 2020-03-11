Pod::Spec.new do |s|
  s.name         = 'VouchSDKiOS'
  s.version      = '0.0.14'
  s.summary      = 'Vouch SDK is an chat module'
  s.description  = 'Vouch SDK is an chat app that can be used in any project'
  s.homepage     = 'https://github.com/VouchSG/VouchSDKiOS'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { 'Vouch' => 'ajie@gits.co.id' }
  s.platform     = :ios, '10.0'
  s.source       = { :git => 'https://github.com/VouchSG/VouchSDK-iOS.git', :tag => s.version }
  s.source_files = 'VouchSDKiOS/Classes', 'VouchSDKiOS/Classes/**/*.{h,m,swift}'
  s.resource_bundles = { 'VouchSDKiOS' => ['VouchSDKiOS/Assets/**/*.{storyboard,xib,xcassets,json,imageset,png,bundle,ttf}']}

  s.dependency 'Alamofire', '~>4.9.1'
  s.dependency 'FSQCollectionViewAlignedLayout', '~>1.1.1'
  s.dependency 'GrowingTextView', '~>0.7.1'
  s.dependency 'IQKeyboardManager', '~>6.5.4'
  s.dependency 'lottie-ios', '~>3.1.5'
  s.dependency 'SDWebImage', '~>5.5.1'
  s.dependency 'Socket.IO-Client-Swift', '~>15.1.0'
  s.dependency 'SwiftAudio', '~>0.11.2'
  s.dependency 'SwiftyJSON', '~>5.0.0'
  s.dependency 'UIColor_Hex_Swift', '~>5.1.0'
  
  s.swift_version = '5.0'
end
