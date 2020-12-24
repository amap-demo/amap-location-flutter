#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'amap_location_flutter_plugin'
  s.version          = '0.0.1'
  s.summary          = 'AMapLocation flutter plugin'
  s.description      = <<-DESC
AMapLocation flutter plugin
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.static_framework = true
  s.ios.deployment_target = '8.0'
  s.dependency 'AMapLocation','~>2.6.7'
end

