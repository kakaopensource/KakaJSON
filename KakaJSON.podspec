Pod::Spec.new do |s|
  s.name        = "KakaJSON"
  s.version     = "1.1.2"
  s.summary     = "Fast conversion between JSON and model in Swift"
  s.homepage    = "https://github.com/kakaopensource/KakaJSON"
  s.license     = { :type => "MIT" }
  s.authors     = { "MJ Lee" => "richermj123go@vip.qq.com" }

  s.requires_arc = true
  s.swift_version = "5.0"

  s.osx.deployment_target = "10.9"
  s.ios.deployment_target = "8.0"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.source   = { :git => "https://github.com/kakaopensource/KakaJSON.git", :tag => s.version }
  s.source_files = "Sources/KakaJSON/**/*.swift"
end