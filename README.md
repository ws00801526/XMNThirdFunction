# XMNThirdFunction

集成第三方分享,支付等功能


###使用方法
一 : pod使用方法

1.`pod XMNThirdFunction`

2.如果需要使用单独模块

```
pod XMNThirdFunction/WeChat
pod XMNThirdFunction/QQ
pod XMNThirdFunction/Weibo

```

二:直接使用

1.下载demo,将XMNThirdInteraction文件夹拖入自己工程中
2.添加以下类库ImageIO,SystemConfiguration,CoreTelephony,Security,libz,libsqlite3.0,libc++
3.由于微博SDK不支持armv7s所以项目需要删除armv7s
4.如果不需要某个模块 直接删除APPSDK对应目录 以及对应模块的category即可

###接入注意事项

####!!!必须调用对用的connect方法注册对应平台
####根据使用的模块添加对应的添加白名单
```
	<key>LSApplicationQueriesSchemes</key>
	<array>
		
	    <!-- 微信 URL Scheme 白名单-->
		<string>wechat</string>
		<string>weixin</string>
		
		<!-- 微博 URL Scheme 白名单-->
		<string>sinaweibohd</string>
		<string>sinaweibo</string>
		<string>sinaweibosso</string>
		<string>weibosdk</string>
		<string>weibosdk2.5</string>
        
        <!-- QQ、Qzone URL Scheme 白名单-->
        <string>mqqapi</string>
        <string>mqq</string>
        <string>mqqOpensdkSSoLogin</string>
        <string>mqqconnect</string>
        <string>mqqopensdkdataline</string>
        <string>mqqopensdkgrouptribeshare</string>
        <string>mqqopensdkfriend</string>
        <string>mqqopensdkapi</string>
        <string>mqqopensdkapiV2</string>
        <string>mqqopensdkapiV3</string>
        <string>mqzoneopensdk</string>
        <string>wtloginmqq</string>
        <string>wtloginmqq2</string>
        <string>mqqwpa</string>
        <string>mqzone</string>
        <string>mqzonev2</string>
        <string>mqzoneshare</string>
        <string>wtloginqzone</string>
        <string>mqzonewx</string>
        <string>mqzoneopensdkapiV2</string>
        <string>mqzoneopensdkapi19</string>
        <string>mqzoneopensdkapi</string>
        <string>mqzoneopensdk</string>
        
       <!-- 支付宝 URL Scheme 白名单-->
		<string>alipay</string>
		<string>alipayshare</string>
	</array>

```

####根据使用的平台添加URLScheme

1.微信
微信URLScheme格式 `wx+appid`

2.微博
微博URLScheme格式 `wb+appid`

3.QQ URLScheme格式  `tencent+appid`和`QQ+十六进制appid`

4.支付宝URLScheme格式  `ap+appid` 额外注意URLScheme的identifier必须是`alipayshare`


####其他内容参考Demo中使用方法
