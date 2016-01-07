Pod::Spec.new do |s|
  s.name         = 'XMNThirdFunction'
  s.version      = '1.0.0'
  s.summary      = '封装第三方SDK 集成分享功能'
  s.description  = <<-DESC
                   移动分享集成,
                   目前支持微信,微博,QQ
                   DESC
  s.homepage     = 'https://github.com/ws00801526'
  s.license      = 'MIT'
  s.author       = { 'XMFraker' => '3057600441@qq.com' }
  s.platform     = :ios, '7.0.0'
  s.source       = { :git => 'https://github.com/ws00801526/XMNThirdFunction.git', :tag => s.version }
  s.requires_arc = true
  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'XMNThirdExample/XMNThirdInteraction/XMNThirdFunction.h','XMNThirdExample/XMNThirdInteraction/XMNThirdFunction+Supports.h'
    core.public_header_files = 'XMNThirdExample/XMNThirdInteraction/XMNThirdFunction.h','XMNThirdExample/XMNThirdInteraction/XMNThirdFunction+Supports.h'
  end

  s.subspec 'WeChat' do |wx|
    wx.ios.weak_frameworks = 'SystemConfiguration'
    wx.ios.library = 'z','sqlite3.0','c++'
    wx.source_files = 'XMNThirdExample/XMNThirdInteraction/XMNThirdFunction+WeChat.h'
    wx.public_header_files = 'XMNThirdExample/XMNThirdInteraction/XMNThirdFunction+WeChat.h'
    wx.vendored_libraries = 'XMNThirdExample/XMNThirdInteraction/APPSDK/WeChat/*.a'
    wx.dependency 'XMNThirdFunction/Core'
  end

  s.subspec 'Weibo' do |wb|
    wb.frameworks = 'SystemConfiguration','ImageIO','CoreTelephony','QuartzCore'
    wb.source_files = 'XMNThirdExample/XMNThirdInteraction/XMNThirdFunction+Weibo.h'
    wb.public_header_files = 'XMNThirdExample/XMNThirdInteraction/XMNThirdFunction+Weibo.h'
    wb.vendored_libraries = 'XMNThirdExample/XMNThirdInteraction/APPSDK/Weibo/*.a'
    wb.dependency 'XMNThirdFunction/Core'
    wb.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }  
    wb.resource = 'XMNThirdExample/XMNThirdInteraction/APPSDK/Weibo/*.bundle'
  end

  s.subspec 'QQ' do |qq|
    qq.frameworks = 'SystemConfiguration','ImageIO','CoreTelephony','QuartzCore'
    qq.source_files = 'XMNThirdExample/XMNThirdInteraction/XMNThirdFunction+QQ.h'
    qq.public_header_files = 'XMNThirdExample/XMNThirdInteraction/XMNThirdFunction+QQ.h'
    qq.ios.vendored_frameworks = 'XMNThirdExample/XMNThirdInteraction/APPSDK/QQ/TencentOpenAPI.framework'
    qq.dependency 'XMNThirdFunction/Core'
    qq.resource = 'XMNThirdExample/XMNThirdInteraction/APPSDK/QQ/*.bundle'
  end

end
