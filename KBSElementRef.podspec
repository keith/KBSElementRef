Pod::Spec.new do |s|
  s.name         = 'KBSElementRef'
  s.version      = '0.1.0'
  s.summary      = 'An ObjC wrapper for AXUIElementRef'
  s.homepage     = 'https://github.com/Keithbsmiley/KBSElementRef'
  s.license      = 'MIT'
  s.author       = { 'Keith Smiley' => 'keithbsmiley@gmail.com' }
  s.platform     = :osx, '10.8'
  s.source       = { :git => 'https://github.com/Keithbsmiley/KBSElementRef.git', :tag => s.version.to_s }
  s.source_files = '*.{h,m}'
  s.requires_arc = true
end
