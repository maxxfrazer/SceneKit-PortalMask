Pod::Spec.new do |s|
  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "PortalMask"
  s.version      = "1.3.2"
  s.summary      = "PortalMask window to an AR world"
  s.description  = <<-DESC
  					PortalMask create a window into any collection of SceneKit elements by occluding other things around it.
            This can be used ontop of ARReferenceImage, create a static portal into another world,
            or to have the illusion of a hole in the ground.
                   DESC
  s.homepage     = "https://github.com/maxxfrazer/SceneKit-PortalMask"
  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = "MIT"
  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author             = "Max Cobb"
  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/maxxfrazer/SceneKit-PortalMask.git", :tag => "#{s.version}" }
  s.swift_version = '5.0'
  s.ios.deployment_target = '11.0'
  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = "Sources/PortalMask/*.swift"
end
