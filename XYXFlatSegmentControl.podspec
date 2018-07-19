Pod::Spec.new do |s|

  s.name         = "XYXFlatSegmentControl"
  s.version      = "1.2.4"
  s.summary      = "便捷实用的SegmentControl."
  s.swift_version = "4.0"

  s.description  = <<-DESC
  可设定下划线的segmentControl，可以添加到navigationBar上，也可适配到普通UIView上。可以便捷的设定是否带下划线，下划线厚度，按钮颜色和字体大小。可通过Gap便捷的对SegmentControl布局进行调整，还能指定初始化时被选择的segment.
                   DESC

  s.homepage     = "https://github.com/uMina/XYXFlatSegmentControl"
  s.screenshots  = "https://github.com/uMina/XYXFlatSegmentControl/blob/master/bbb.gif?raw=true"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Teresa" => "yxx.umina@gmail.com" }
  s.social_media_url   = "https://umina.github.io/"
  
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/uMina/XYXFlatSegmentControl.git", :tag => "#{s.version}" }
  s.source_files  = "XYXFlatSegmentControl/*.swift"
  
  s.requires_arc = true
  `echo "4.0" > .swift-version`

end
