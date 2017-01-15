Pod::Spec.new do |s|
  s.name = 'OddityOcUI'
  s.summary          = "奇点资讯 UI 展示信息 [- OddityUI -]"
  s.homepage         = "https://github.com/AimobierCocoaPods/OddityUI/"
  s.author           = { "WenZheng Jing" => "200739491@qq.com" }
  s.ios.deployment_target = '7.0'
  s.version = '0.2.9'
  s.source = { :git => 'https://github.com/AimobierCocoaPods/OddityUI.git', :tag => s.version }
  s.license = 'MIT'

  s.source_files = 'Classes/**/*.{h,m}'
  # s.public_header_files = 'Classes/Public/**/*.h'
  # s.private_header_files = 'Classes/private/**/*.h'
  s.resource_bundles = { "OdditBundle" => "Classes/**/**/*.{xcassets,xcdatamodeld}" }

  s.libraries = 'xml2'
  s.prefix_header_file = 'Classes/PrefixHeader.pch'

  s.dependency 'Masonry', '~> 0.6.3'
  s.dependency 'AFNetworking', '~> 3.0'
  s.dependency 'SDWebImage', '~>3.7'
  s.dependency 'MBProgressHUD', '~> 1.0.0'
  s.dependency 'DTRichTextEditor'
  s.dependency 'MJRefresh'
  s.dependency 'TTTAttributedLabel'
  s.dependency 'MJExtension'

  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }

end
