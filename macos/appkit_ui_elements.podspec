#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint appkit_ui_elements.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'appkit_ui_elements'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/sephiroth74/appkit_ui_elements'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Alessandro Crugnola' => 'alessandro.crugnola@gmail.com' }

  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
