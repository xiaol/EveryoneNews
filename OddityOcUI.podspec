Pod::Spec.new do |s|
  s.name = 'OddityOcUI'
  s.summary          = "奇点资讯 UI 展示信息 [- OddityUI -]"
  s.homepage         = "https://github.com/AimobierCocoaPods/OddityUI/"
  s.author           = { "WenZheng Jing" => "200739491@qq.com" }
  s.ios.deployment_target = '8.0'
  s.version = '0.2.9'
  s.source = { :git => 'https://github.com/AimobierCocoaPods/OddityUI.git', :tag => s.version }
  s.license = 'MIT'
  s.source_files = 'Classes/**/*.{h,m}'

  # s.prefix_header_contents = "#import \"PrefixHeader.pch\""

  s.resource_bundles = { "OdditBundle" => "Classes/**/**/*.{xcassets,xcdatamodeld}" }

  # s.frameworks = 'UserNotifications', 'AdSupport', 'JavaScriptCore', 'ImageIO', 'CoreData', 'Security', 'CoreTelephony', 'QuartzCore', 'SystemConfiguration', 'UIKit', 'Foundation', 'CoreTelephony', 'CoreGraphics', 'CoreFoundation', 'CFNetwork'
  # s.libraries = 'libc++', 'libz', 'libxml2', 'libiconv', 'libicucore', 'libz.1.2.5', 'libsqlite3'

  s.libraries = 'xml2'
  s.prefix_header_file = 'Classes/PrefixHeader.pch'

  s.dependency 'Masonry', '~> 0.6.3'
  s.dependency 'AFNetworking', '~> 3.0'
  s.dependency 'SDWebImage', '~>3.7'
  s.dependency 'MBProgressHUD', '~> 1.0.0'
  s.dependency 'DTCoreText'
  s.dependency 'DTRichTextEditor'

  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }

end
