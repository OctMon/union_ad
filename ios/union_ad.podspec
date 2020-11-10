#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint union_ad.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'union_ad'
  s.version          = '0.0.1'
  s.summary          = '字节跳动穿山甲广告插件'
  s.description      = <<-DESC
字节跳动穿山甲广告插件
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  s.dependency 'Bytedance-UnionAD', '~> 3.3.0.5'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
