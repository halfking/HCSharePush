//
//  HCShareConfig.h
//  HCSharePush
//
//  Created by HUANGXUTAO on 16/5/1.
//  Copyright © 2016年 seenvoice.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <hccoren/base.h>

@interface HCShareConfig : NSObject
@property (nonatomic,PP_STRONG) NSString * GT_AppID;
@property (nonatomic,PP_STRONG) NSString * GT_AppKey;
@property (nonatomic,PP_STRONG) NSString * GT_AppSecret;
@property (nonatomic,PP_STRONG) NSString * GT_MasterSecret;

@property (nonatomic,PP_STRONG) NSString * ShareUrlRoot;
@property (nonatomic,PP_STRONG) NSString * ShareUrl;
@property (nonatomic,PP_STRONG) NSString * ShareUrl_User;
@property (nonatomic,PP_STRONG) NSString * UmengAppkey;
@property (nonatomic,PP_STRONG) NSString * UmengUrl;

@property (nonatomic,PP_STRONG) NSString * Sina_AppKey;
@property (nonatomic,PP_STRONG) NSString * Sina_AppSecurt;
@property (nonatomic,PP_STRONG) NSString * Sina_RedirectUrl;
@property (nonatomic,PP_STRONG) NSString * Tencent_APPKey;
@property (nonatomic,PP_STRONG) NSString * Tencent_APPScecret;
@property (nonatomic,PP_STRONG) NSString * WChat_AppID;
@property (nonatomic,PP_STRONG) NSString * WChat_AppScecret;
@property (nonatomic,PP_STRONG) NSString * QQ_AppID;
@property (nonatomic,PP_STRONG) NSString * QQ_AppScecret;

@property (nonatomic,PP_STRONG) NSString * SMS_AppID;
@property (nonatomic,PP_STRONG) NSString * SMS_AppScecret;

@property (nonatomic,PP_STRONG) NSString * TU_AppKey;
+ (HCShareConfig *) config;
+ (HCShareConfig *) config:(NSString *)configFile isDebug:(BOOL)isDebug;
- (id)initWithFile:(NSString *)configFile isDebug:(BOOL)isDebug;
@end
