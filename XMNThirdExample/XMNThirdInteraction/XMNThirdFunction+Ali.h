//
//  XMNThirdFunction+Ali.h
//  XMNThirdExample
//
//  Created by XMFraker on 16/1/7.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNThirdFunction.h"

@interface XMNThirdFunction (Ali)

/**
 *  配置QQ开放平台信息
 *
 *  @param appID      QQ互联开放平台appID 不可为空
 */
+ (void)connectAliWithAppID:(NSString * _Nonnull)appID;

/**
 *  判断支付宝是否安装,并且支持分享功能
 *
 *  @return 已安装 YES   未安装NO
 */
+ (BOOL)isAliInstalled;

/**
 *  分享到支付宝
 *
 *  @param shareContent    分享的内容
 *  @param completionBlock 分享完成回调
 */
+ (void)shareToALIWithShareContent:(XMNShareContent *_Nonnull)shareContent completionBlock:(void (^_Nonnull)(XMNShareContent *_Nonnull shareContent, NSError *_Nullable error))completionBlock;

@end
