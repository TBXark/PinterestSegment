Pod::Spec.new do |s|
  s.name         = "PinterestSegment"
  s.version      = "1.2.3"
  s.summary      = "PinterestSegment is a animation segment"
  s.license      = { :type => 'MIT License', :file => 'LICENSE' } 
  s.homepage     = "https://github.com/TBXark/PinterestSegment"
  s.author       = { "TBXark" => "https://github.com/TBXark" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/TBXark/PinterestSegment.git", :tag => s.version }
  s.source_files  = "PinterestSegment/PinterestSegment.swift"
  s.requires_arc = true
end
