Pod::Spec.new do |s|
  s.name         = "DebugPanel"
  s.version      = "0.0.1"
  s.summary      = "切换线上线下环境的调试面板"
  s.description  = <<-DESC
                   切换线上线下环境的调试面板
                   DESC

  s.homepage     = "https://github.com/yangmiemie1116/PSNetWork.git"
  s.license      = "MIT"
  s.author             = { "杨志强" => "yangzhiqiang116@gmail.com" }
  s.social_media_url   = "http://www.jianshu.com/u/bd06a732c598"
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/yangmiemie1116/DebugPanel.git", :tag => "#{s.version}" }
  s.source_files  = "DebugPanel/*.{h,m}"
  s.requires_arc = true

end
