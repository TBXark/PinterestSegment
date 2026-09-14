Pod::Spec.new do |s|
  s.name         = "PinterestSegment"
  s.version      = "2.0.0"
  s.summary      = "PinterestSegment is a animation segment"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage     = "https://github.com/TBXark/PinterestSegment"
  s.author       = { "TBXark" => "https://github.com/TBXark" }
  s.platform     = :ios, "13.0"
  s.swift_version = "5.0"
  s.source       = { :git => "https://github.com/TBXark/PinterestSegment.git", :tag => s.version }
  s.source_files  = "Sources/PinterestSegment/**/*.swift"
  s.requires_arc = true
end
