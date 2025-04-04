#
# Be sure to run `pod lib lint RxUtils.podspec` to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RxUtils'
  s.version          = '5.0.1'
  s.summary          = 'RxSwift utils'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A helpful collection of RxSwift utils.
                       DESC

  s.homepage         = 'https://github.com/APUtils/RxUtils'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anton Plebanovich' => 'anton.plebanovich@gmail.com' }
  s.source           = { :git => 'https://github.com/APUtils/RxUtils.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_versions = ['5']
  
  # 1.12.0: Ensure developers won't hit CocoaPods/CocoaPods#11402 with the resource
  # bundle for the privacy manifest.
  # 1.13.0: visionOS is recognized as a platform.
  s.cocoapods_version = '>= 1.13.0'
  
  s.source_files = 'RxUtils/Classes/**/*'
  s.resource_bundle = {"RxUtils.privacy"=>"RxUtils/Privacy/RxUtils/PrivacyInfo.xcprivacy"}
  s.frameworks = 'Foundation', 'UIKit'
  
  s.dependency 'APExtensions/Dispatch', '>= 15.0'
  s.dependency 'APExtensions/Occupiable', '>= 15.0'
  s.dependency 'APExtensions/OptionalType', '>= 15.0'
  s.dependency 'RoutableLogger', '>= 12.0'
  s.dependency 'RxCocoa', '>= 6.0'
  s.dependency 'RxGesture', '>= 4.0'
  s.dependency 'RxSwift', '>= 6.0'
  s.dependency 'RxSwiftExt', '>= 6.0'
end
