#
#  Be sure to run `pod spec lint SocialsAuth.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "SocialsAuth"
  spec.version      = "1.0.8"
  spec.summary      = "A framework can support socials authentication"
  spec.description  = "A framework can support socials authentication"

  spec.homepage     = "https://bap.jp/en/"
  spec.license      = "MIT"
  spec.author       = { "thachnn" => "" }
  spec.platform     = :ios, "10.0"
  spec.source       = { :path => '.' }
  spec.source       = { :git => "https://github.com/NguyenNgocThach131193/SocialsAuth.git", :tag => "1.0.8" }
  spec.source_files  = "SocialsAuth"
  spec.exclude_files = "Classes/Exclude" 
  spec.framework  = "UIKit"
  spec.dependency "Firebase/Core"
  spec.dependency "Firebase/Auth"
  spec.dependency "GoogleSignIn"
  spec.dependency "FBSDKLoginKit"
  spec.dependency "LineSDKSwift"
  spec.dependency "TwitterKit"
  spec.static_framework = true
  spec.swift_version = "5.0.0" 
end
