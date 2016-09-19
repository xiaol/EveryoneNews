Pod::Spec.new do |s|
  s.name = 'SwaggerClient'
  s.summary          = "NSDate Extension for Swift 2.0"
  s.homepage         = "https://github.com/melvitax/AFDateHelper"
  s.author           = { "Melvin Rivera" => "melvin@allforces.com" }
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.9'
  s.version = '2.3.0'
  s.source = { :git => 'git@github.com:swagger-api/swagger-mustache.git', :tag => 'v1.0.0' }
  s.license = 'Apache License, Version 2.0'
  s.source_files = 'SwaggerClient/Classes/Swaggers/**/*.swift'
  s.dependency 'Alamofire'
end
