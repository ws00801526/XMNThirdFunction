Pod::Spec.new do |s|
  s.name         = 'XMNThirdFunction'
  s.version      = '1.0.5'
  s.summary      = '封装第三方SDK 集成分享功能'
  s.description  = <<-DESC
                   移动分享集成,
                   目前支持微信,微博,QQ
                   DESC
  s.homepage     = 'https://github.com/ws00801526'
  s.license      = 'MIT'
  s.author       = { 'XMFraker' => '3057600441@qq.com' }
  s.source       = { :git => 'https://github.com/ws00801526/XMNThirdFunction.git', :tag => s.version }
  s.requires_arc = true
  s.platform     = :ios, "8.0"
  s.default_subspec = 'Core','WeChat','Weibo','QQ'

  s.subspec 'Core' do |core|
    core.source_files = "XMNThirdExample/XMNThirdInteraction/XMNThirdFunction.{h,m}","XMNThirdExample/XMNThirdInteraction/XMNThirdFunction+Supports.{h,m}"
    core.frameworks = 'SystemConfiguration','ImageIO','CoreTelephony','QuartzCore','Security'
    core.libraies = 'sqlite3', 'z'
  end

  s.subspec 'WeChat' do |wx|
    wx.ios.libraries = 'c++'
    wx.public_header_files = 'XMNThirdExample/XMNThirdInteraction/APPSDK/WeChat/*.h','XMNThirdExample/XMNThirdInteraction/XMNThirdFunction+WeChat.h'
    wx.source_files = 'XMNThirdExample/XMNThirdInteraction/XMNThirdFunction+WeChat.{h,m}','XMNThirdExample/XMNThirdInteraction/APPSDK/WeChat/*.h'
    wx.vendored_libraries = 'XMNThirdExample/XMNThirdInteraction/APPSDK/WeChat/*.a'
    wx.dependency 'XMNThirdFunction/Core'
  end

  s.subspec 'Weibo' do |wb|
    wb.source_files = 'XMNThirdExample/XMNThirdInteraction/XMNThirdFunction+Weibo.{h,m}','XMNThirdExample/XMNThirdInteraction/APPSDK/Weibo/*.h'
    wb.public_header_files = 'XMNThirdExample/XMNThirdInteraction/APPSDK/Weibo/*.h','XMNThirdExample/XMNThirdInteraction/XMNThirdFunction+Weibo.h'
    wb.vendored_libraries = 'XMNThirdExample/XMNThirdInteraction/APPSDK/Weibo/libWeiboSDK.a'
    wb.frameworks   = 'CoreText', 'CoreGraphics' 
    wb.dependency 'XMNThirdFunction/Core'
    wb.resource = 'XMNThirdExample/XMNThirdInteraction/APPSDK/Weibo/*.bundle'
  end

  s.subspec 'QQ' do |qq|
    qq.source_files = 'XMNThirdExample/XMNThirdInteraction/XMNThirdFunction+QQ.{h,m}'
    qq.public_header_files = 'XMNThirdExample/XMNThirdInteraction/XMNThirdFunction+QQ.h','XMNThirdExample/XMNThirdInteraction/APPSDK/QQ/TencentOpenAPI.framework/Headers/*.h'
    qq.ios.vendored_frameworks = 'XMNThirdExample/XMNThirdInteraction/APPSDK/QQ/TencentOpenAPI.framework'
    qq.dependency 'XMNThirdFunction/Core'
    qq.ios.libraries = 'iconv','stdc++'
    qq.resource = 'XMNThirdExample/XMNThirdInteraction/APPSDK/QQ/*.bundle'
  end

end
