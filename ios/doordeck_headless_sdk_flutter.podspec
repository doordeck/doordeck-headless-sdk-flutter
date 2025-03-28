# [Doordeck] this is an internal podspec that is not published so we don't need to add extra info.
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint doordeck_headless_sdk_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'doordeck_headless_sdk_flutter'
  s.version          = '0.0.0'
  s.summary          = 'Doordeck SDK Headless Flutter'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.source       = { :git => "https://github.com/doordeck/doordeck-headless-sdk-react-native.git", :tag => "#{s.version}" }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '15.6'

  doordeck_sdk_version = ENV['DOORDECK_SDK_VERSION'] || '0.84'
  s.dependency "DoordeckSDK", "~> #{doordeck_sdk_version}"

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
