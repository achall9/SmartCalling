#
#  Be sure to run `pod spec lint SmartCalling.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "SmartCalling"
  s.version      = "1.0.1"
  s.summary      = "SmartCalling like the Activity status bars."

  s.description  = <<-DESC
		   This library allows you to quickly and easily send emails through SmartCalling using Swift
                   DESC

  s.homepage     = "https://github.com/achall9/SmartCalling"

  s.license      = "MIT"
  
  s.platform     = :ios, "9.0"

  s.author             = { "" => "" }

  s.source       = { :git => "https://github.com/achall9/SmartCalling.git", :tag => "#{s.version}" }

  s.requires_arc = true

  s.source_files     = "Classes/*"
  s.dependency         "Alamofire", "~> 4.0"
  s.dependency         "AlamofireImage", "~> 3.1"

end
