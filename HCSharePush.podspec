#
#  Be sure to run `pod spec lint HCBaseSystem' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "HCSharePush"
  s.version      = "0.0.5"
  s.summary      = "这是一个与分享、推送的核心库。"
  s.description  = <<-DESC
这是一个特定的核心库。包含了常用的分享、命令、推送。简化了外部引用的一些问题。
                   DESC

  s.homepage     = "https://github.com/halfking/HCSharePush"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "halfking" => "kimmy.huang@gmail.com" }
  # Or just: s.author    = ""
  # s.authors            = { "" => "" }
  # s.social_media_url   = "http://twitter.com/"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
   s.platform     = :ios, "7.0"

  #  When using multiple platforms
   s.ios.deployment_target = "7.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

s.source       = { :git => "https://github.com/halfking/hcsharepush", :tag => s.version,:submodules => true  }
#s.source       = { :git => "http://github.com/halfking/hcbasesystem.git", :tag => s.version }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

# s.source_files  = "hccoren", "hccoren/**/regexkitlite.{h,m,mm}"
#  s.exclude_files = "hccoren/Exclude"

#s.public_header_files = "hccoren/**/regexkitlite.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #
  # s.framework  = "UIKit"
   s.frameworks = "UIKit", "Foundation","TencentOpenAPI"

  # s.library   = "iconv"
#  s.libraries = "icucore","sqlite3.0","stdc++"

  # s.requires_arc = false
#此处注意，外部的Lib的引用。
s.xcconfig = { "CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES" => "YES","ENABLE_BITCODE" => "YES","DEFINES_MODULE" =>  "YES"}
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

    s.dependency "HCMinizip"
    s.dependency "hccoren"
    s.dependency "HCBaseSystem"
    s.dependency "UMengAnalytics-NO-IDFA"
    s.dependency "TuSDK"
    s.dependency 'MOBFoundation_IDFA'
    s.dependency 'SMSSDK'
    s.dependency 'UMengSocial'
    s.dependency 'GTSDK', '~> 1.4.2-noidfa'
    s.dependency 'QQOpenSDK'

#s.dependency 'TencentOpenAPI'

    s.subspec 'ShareTM' do |spec|
        spec.requires_arc            = true
        spec.source_files = [
            "HCSharePush/TM/*.{h,m,mm,cpp,c}",
            "HCSharePush/Share/*.{h,m,mm,cpp,c}",
            "HCSharePush/HCShareConfig.{h,m}",
            "HCSHarePush/HCShareConfig.h",
            "HCSharePush/shareConfig.h"
        ]
        spec.public_header_files = [
            "HCSharePush/TM/*.h",
            "HCSharePush/Share/*.h",
            "HCSHarePush/HCShareConfig.h",
            "HCSharePush/shareConfig.h"
        ]
        #spec.frameworks = []
        #spec.ios.dependency 'HCBaseSystem/User'
    end
 end
