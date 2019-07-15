#
# Be sure to run `pod lib lint RxUtils.podspec` to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RxUtils'
  s.version          = '1.3.0'
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

  s.ios.deployment_target = '9.0'

  s.source_files = 'RxUtils/Classes/**/*'
  
  # s.resource_bundles = {
  #   'RxUtils' => ['RxUtils/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'Foundation', 'UIKit'
  s.dependency 'RxSwift', '~> 5'
  s.dependency 'RxCocoa', '~> 5'
  s.dependency 'RxOptional', '~> 4'
end
