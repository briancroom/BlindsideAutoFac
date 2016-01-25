#
# Be sure to run `pod lib lint BlindsideAutoFac.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BlindsideAutoFac"
  s.version          = "0.1.0"
  s.summary          = "TODO"
  s.description      = <<-DESC
                            TODO

                            TODO
                       DESC
  s.homepage         = "https://github.com/briancroom/BlindsideAutoFac"
  s.license          = 'MIT'
  s.author           = { "Brian Croom" => "brian.s.croom@gmail.com" }
  s.social_media_url = 'https://twitter.com/aikoniv'
  s.source           = { :git => "https://github.com/briancroom/BlindsideAutoFac.git", :tag => s.version.to_s }

  s.platform     = :ios, '5.0'
  s.requires_arc = true

  s.source_files = 'BlindsideAutoFac/*.{h,m}'

  s.public_header_files = ['BlindsideAutoFac/BlindsideAutoFac.h', 'BlindsideAutoFac/BSAutoFacProvider.h', 'BlindsideAutoFac/BSProtocolBinding.h']
  s.frameworks = 'Foundation'
  s.dependency 'Blindside', '~> 1.1'
end
