#
# Be sure to run `pod lib lint OKTableViewLiaison.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OKTableViewLiaison'
  s.version          = '1.0.0'
  s.license          = 'MIT'
  s.summary          = 'Framework to help you better manage UITableViews.'
  s.description      = 'OKTableViewLiaison abstracts and simplifies UITableView construction and management.'
  s.homepage         = 'https://github.com/okcupid/OKTableViewLiaison'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dylan Shine' => 'dylan@okcupid.com' }
  s.source           = { :git => 'https://github.com/okcupid/OKTableViewLiaison.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'OKTableViewLiaison/Classes/**/*'
  s.swift_version = '4.1'

end
