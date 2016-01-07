//
//  XMNThirdFunction+Ali.m
//  XMNThirdExample
//
//  Created by XMFraker on 16/1/7.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNThirdFunction+Ali.h"
#import "XMNThirdFunction+Supports.h"

#import "APOpenAPI.h"

NSString *const kXMNALIPlatform = @"ali";


@interface XMNALIManager : XMNBaseManager <APOpenAPIDelegate>

@end

@implementation XMNALIManager

- (void)onReq:(APBaseReq *)req {
    
}

- (void)onResp:(APBaseResp *)resp {
    if ([resp isKindOfClass:[APSendMessageToAPResp class]]) {
        if (resp.errCode == 0) {
            //TODO success
            self.shareCompletionBlock ? self.shareCompletionBlock(self.shareContent, nil) : nil;
        }else {
            self.shareCompletionBlock ? self.shareCompletionBlock(self.shareContent, [NSError errorWithDomain:kXMNALIPlatform code:resp.errCode userInfo:@{kXMNErrorMessageKey:resp.errStr}]) : nil;
        }
    }
}


@end


@implementation XMNThirdFunction (Ali)

/**
 *  配置QQ开放平台信息
 *
 *  @param appID      QQ互联开放平台appID 不可为空
 */
+ (void)connectAliWithAppID:(NSString * _Nonnull)appID {
    [APOpenAPI registerApp:appID withDescription:@"支付宝分享"];
    [self setPlatformConfiguration:@{kXMNThirdAPPIDKey:appID} forPlatform:kXMNALIPlatform];
}

/**
 *  判断支付宝是否安装,并且支持分享功能
 *
 *  @return 已安装 YES   未安装NO
 */
+ (BOOL)isAliInstalled {
    return [APOpenAPI isAPAppSupportOpenApi];
}

/**
 *  分享到支付宝
 *
 *  @param shareContent    分享的内容
 *  @param completionBlock 分享完成回调
 */
+ (void)shareToALIWithShareContent:(XMNShareContent *_Nonnull)shareContent completionBlock:(void (^_Nonnull)(XMNShareContent *_Nonnull shareContent, NSError *_Nullable error))completionBlock {
    
    APSendMessageToAPReq *baseReq = [self _generateReqWithShareContent:shareContent];
    if (!baseReq.message.mediaObject) {
        completionBlock(shareContent,[NSError errorWithDomain:kXMNALIPlatform code:-1 userInfo:@{kXMNErrorMessageKey:@"不支持分享此类型到支付宝"}]);
    }else {
        [XMNALIManager sharedInstance].shareContent = shareContent;
        [XMNALIManager sharedInstance].shareCompletionBlock = completionBlock;
        baseReq.openID = [self platformConfigurationForPlatform:kXMNALIPlatform][kXMNThirdAPPIDKey];
        [APOpenAPI sendReq:baseReq];
    }
    
}

+ (BOOL)ali_handleOpenURL:(NSURL *)openURL {
    return [APOpenAPI handleOpenURL:openURL delegate:[XMNALIManager sharedInstance]];
}


+ (APSendMessageToAPReq *)_generateReqWithShareContent:(XMNShareContent *)shareContent {
    APSendMessageToAPReq *baseReq = [[APSendMessageToAPReq alloc] init];
    //  创建消息载体 APMediaMessage 对象
    APMediaMessage *message = [[APMediaMessage alloc] init];
    switch (shareContent.contentType) {
        case XMNShareContentTypeText:
        {
            //  创建文本类型的消息对象
            APShareTextObject *textObj = [[APShareTextObject alloc] init];
            textObj.text = shareContent.desc ? : shareContent.title;
            message.mediaObject = textObj;
        }
            break;
        case XMNShareContentTypeImage:
        {
            //  创建图片类型的消息对象
            APShareImageObject *imgObj = [[APShareImageObject alloc] init];
            imgObj.imageData = [self dataWithImage:shareContent.image];
            imgObj.imageUrl = shareContent.imageUrl;
            message.mediaObject = imgObj;
        }
            break;
        case XMNShareContentTypeNews:
        {
            message.title = shareContent.title;
            message.desc = shareContent.desc ? : shareContent.title;
            message.thumbData = shareContent.thumbnail ? [self dataWithImage:shareContent.thumbnail] : [self dataWithImage:shareContent.image scale:CGSizeMake(100, 100)];
            APShareWebObject *webObj = [[APShareWebObject alloc] init];
            webObj.wepageUrl = shareContent.link;
            message.mediaObject = webObj;
        }
            break;
        default:
            
            break;
    }
    baseReq.message = message;
    return baseReq;
}

@end
