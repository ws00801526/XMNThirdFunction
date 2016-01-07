//
//  XMNThirdFunction+QQ.m
//  XMNThirdExample
//
//  Created by XMFraker on 16/1/6.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNThirdFunction+QQ.h"
#import "XMNThirdFunction+Supports.h"

#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>

NSString *const kXMNQQPlatform = @"qq";


@interface XMNQQManager : XMNBaseManager <TencentSessionDelegate,QQApiInterfaceDelegate>

@property (nonatomic, strong, readonly) TencentOAuth *tencentOAuth;


@end

@implementation XMNQQManager

#pragma mark - TencentLoginDelegate

- (void)tencentDidLogin {
    NSDictionary *authInfo = @{kXMNAuthTokenKey:self.tencentOAuth.accessToken,kXMNAuthUserIDKey:self.tencentOAuth.openId};
    [XMNThirdFunction saveAuthInfo:authInfo forPlatform:kXMNQQPlatform];
    self.authCompletionBlock ? self.authCompletionBlock(authInfo, nil) : nil;
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    self.authCompletionBlock ? self.authCompletionBlock(nil, [NSError errorWithDomain:kXMNQQPlatform code:-1 userInfo:@{kXMNErrorMessageKey:cancelled ? @"用户取消登录授权" : @"用户登录授权失败"}]) : nil;
}

- (void)tencentDidNotNetWork {
    self.authCompletionBlock ? self.authCompletionBlock(nil, [NSError errorWithDomain:kXMNQQPlatform code:-1 userInfo:@{kXMNErrorMessageKey:@"用户登录授权失败"}]) : nil;
}

- (void)getUserInfoResponse:(APIResponse *)response {
    if (response.retCode == 0) {
        self.authCompletionBlock ? self.authCompletionBlock(response.jsonResponse, nil) : nil;
    }else {
        self.authCompletionBlock ? self.authCompletionBlock(response.jsonResponse, [NSError errorWithDomain:kXMNQQPlatform code:response.retCode userInfo:@{kXMNErrorMessageKey:response.errorMsg ? : @""}]) : nil;
    }
}
/**
 处理来至QQ的请求
 */
- (void)onReq:(QQBaseReq *)req {
    NSLog(@"req");
}

/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        if ([resp.result integerValue] == 0) {
            self.shareCompletionBlock ? self.shareCompletionBlock (self.shareContent , nil) : nil;
        }else {
            self.shareCompletionBlock ? self.shareCompletionBlock (self.shareContent , [NSError errorWithDomain:kXMNQQPlatform code:[resp.result integerValue] userInfo:@{kXMNErrorMessageKey:resp.errorDescription}]) : nil;
        }
    }
}

/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response {
    NSLog(@"online");
}
#pragma mark - Methods

- (void)connectTencentWithAppID:(NSString *)appID redirectURI:(NSString *)redirectURI {
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:appID andDelegate:self];
}

@end

@implementation XMNThirdFunction (QQ)

/**
 *  配置QQ开放平台信息
 *
 *  @param appID      QQ互联开放平台appID
 *  @param redirectURI app对应的回调地址
 */
+ (void)connectQQWithAppID:( NSString * _Nonnull)appID redirectURI:( NSString * _Nullable)redirectURI {
    [[XMNQQManager sharedInstance] connectTencentWithAppID:appID redirectURI:redirectURI];
    [self setPlatformConfiguration:@{kXMNThirdAPPIDKey:appID,kXMNThirdCallbackKey:redirectURI ? : @"www.qq.com"} forPlatform:kXMNQQPlatform];
}

/**
 *  判断QQ是否安装
 *
 *  @return 已安装 YES   未安装NO
 */
+ (BOOL)isQQInstalled {
    return [QQApiInterface isQQInstalled];
}


/**
 *  分享到QQ
 *
 *  @param shareContent    分享的内容
 *  @param type            分享的类型
 *  @param completionBlock 分享完成回调
 */
+ (void)shareToQQWithShareContent:(XMNShareContent *_Nonnull)shareContent type:(XMNShareQQType)type completionBlock:(void (^_Nonnull)(XMNShareContent *_Nonnull shareContent, NSError *_Nullable error))completionBlock {
    
    [XMNQQManager sharedInstance].shareCompletionBlock = completionBlock;
    [XMNQQManager sharedInstance].shareContent = shareContent;
    SendMessageToQQReq *baseReq = [self _gengeraeQQShareReqWithShareContent:shareContent];
    if (baseReq) {
        if (!([baseReq.message isKindOfClass:[QQApiTextObject class]] && [baseReq.message isKindOfClass:[QQApiImageObject class]])) {
            [baseReq.message setCflag:type];
        }
        QQApiSendResultCode resultCode;
        if (type == XMNShareQQTypeQZone) {
            resultCode = [QQApiInterface SendReqToQZone:baseReq];
        }else {
            resultCode = [QQApiInterface sendReq:baseReq];
        }
        
    }
}

/**
 *  登录QQ平台 支持SSO登录
 *
 *  @param completionBlock 登录完成回调
 */
+ (void)authQQWithCompletionBlock:(void(^)(id responseObject , NSError * error))completionBlock {
    [XMNQQManager sharedInstance].authCompletionBlock = completionBlock;
    [[XMNQQManager sharedInstance].tencentOAuth authorize:@[kOPEN_PERMISSION_GET_USER_INFO,kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,kOPEN_PERMISSION_GET_INFO,kOPEN_PERMISSION_ADD_SHARE]];
}


+ (void)requestQQUserInfoWithCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock {
    [XMNQQManager sharedInstance].authCompletionBlock = completionBlock;
    [[XMNQQManager sharedInstance].tencentOAuth getUserInfo];
}

+ (BOOL)qq_handleOpenURL:(NSURL *)openURL {
    return [TencentOAuth HandleOpenURL:openURL] || [QQApiInterface handleOpenURL:openURL delegate:[XMNQQManager sharedInstance]]|| [TencentApiInterface handleOpenURL:openURL delegate:[XMNQQManager sharedInstance]];
}

+ (SendMessageToQQReq *)_gengeraeQQShareReqWithShareContent:(XMNShareContent *)shareContent {
    
    QQApiObject *object;
    
    switch (shareContent.contentType) {
        case XMNShareContentTypeText:
        {
            object = [QQApiTextObject objectWithText:shareContent.desc];
        }
            break;
        case XMNShareContentTypeImage:
        {
            if (shareContent.images) {
                object = [QQApiImageObject objectWithData:[self dataWithImage:shareContent.image] previewImageData:shareContent.thumbnail ? [self dataWithImage:shareContent.thumbnail] : [self dataWithImage:shareContent.image scale:CGSizeMake(100, 100)] title:shareContent.title description:shareContent.desc imageDataArray:shareContent.images];
                [object setCflag:kQQAPICtrlFlagQQShareFavorites];
            }else {
                object = [QQApiImageObject objectWithData:[self dataWithImage:shareContent.image] previewImageData:shareContent.thumbnail ? [self dataWithImage:shareContent.thumbnail] : [self dataWithImage:shareContent.image scale:CGSizeMake(100, 100)] title:shareContent.title description:shareContent.desc];
            }
        }
            break;
        case XMNShareContentTypeAudio:
        {
            object = [QQApiAudioObject objectWithURL:[NSURL URLWithString:shareContent.link] title:shareContent.title description:shareContent.desc previewImageData:shareContent.thumbnail ? [self dataWithImage:shareContent.thumbnail] : [self dataWithImage:shareContent.image] targetContentType:QQApiURLTargetTypeAudio];
        }
            break;
        case XMNShareContentTypeVideo:
        {
            object = [QQApiVideoObject objectWithURL:[NSURL URLWithString:shareContent.link] title:shareContent.title description:shareContent.desc previewImageData:shareContent.thumbnail ? [self dataWithImage:shareContent.thumbnail] : [self dataWithImage:shareContent.image] targetContentType:QQApiURLTargetTypeVideo];
        }
            break;
        //仅支持数据线分享
        case XMNShareContentTypeFile:
        {
            object = [QQApiFileObject objectWithData:shareContent.file previewImageData:shareContent.thumbnail ? [self dataWithImage:shareContent.thumbnail] : [self dataWithImage:shareContent.image] title:shareContent.title description:shareContent.desc ? :shareContent.title];
            [(QQApiFileObject *)object setFileName:[NSString stringWithFormat:@"test.%@",shareContent.fileExt]];
        }
            break;
        case XMNShareContentTypeNews:
        {
            object = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareContent.link] title:shareContent.title description:shareContent.desc previewImageData:shareContent.thumbnail ? [self dataWithImage:shareContent.thumbnail] : [self dataWithImage:shareContent.image] targetContentType:QQApiURLTargetTypeVideo];
        }
            break;
        default:
            break;
    }
    if (object) {
        return [SendMessageToQQReq reqWithContent:object];
    }
    return nil;
}

@end
