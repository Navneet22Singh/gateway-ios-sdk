Pod::Spec.new do |s|
  s.name         = "MGPSDK"
  s.version      = "0.1"
  s.summary      = "chsadhasdas"
  s.description  = <<-DESC
    Your description here.
  DESC
  s.homepage     = "https://github.com/Mastercard/gateway-merchant-swift"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Mastercard Payment Gateway Services" => "" }
  s.social_media_url   = ""
  s.ios.deployment_target = "11.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/Navneet22Singh/gateway-ios-sdk.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
end
