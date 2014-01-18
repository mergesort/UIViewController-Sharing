Pod::Spec.new do |spec|
  spec.name         = 'UIViewController+Sharing'
  spec.version      = '1.0.0'
  spec.license = { :type => 'Apache 2.0', :file => 'LICENSE' }
  spec.homepage     = 'https://github.com/mergesort/UIViewController-Sharing'
  spec.authors      =  'Joe Fabisevich' => 'github@fabisevi.ch'
  spec.summary      = 'A category on UIViewController for adding Apple's built in sharing options.'
  spec.source       =  :git => 'https://github.com/mergesort/UIViewController-Sharing.git', :tag => 'v1.0.0'
  spec.source_files = 'UIViewController+Sharing.h,m'
  spec.framework    = 'Foundation'
  spec.requires_arc = true
  spec.social_media_url = 'https://twitter.com/mergesort'
  spec.ios.deployment_target = '6.0'

  spec.dependency 'NSString+Validation', '~> 1.0'
end
