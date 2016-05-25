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

@property (nonatomic,PP_STRONG) NSString * SHAREURLROOT;
@property (nonatomic,PP_STRONG) NSString * SHAREURL;
@property (nonatomic,PP_STRONG) NSString * SHAREURL_USER;
@property (nonatomic,PP_STRONG) NSString * UmengAppkey;
@property (nonatomic,PP_STRONG) NSString * UMENGURL;

@property (nonatomic,PP_STRONG) NSString * SINA_APPKEY;
@property (nonatomic,PP_STRONG) NSString * SINA_APPSECKET;
@property (nonatomic,PP_STRONG) NSString * SINA_REDIRECTURL;
@property (nonatomic,PP_STRONG) NSString * Tencent_APPKEY;
@property (nonatomic,PP_STRONG) NSString * Tencent_APPSECKET;
@property (nonatomic,PP_STRONG) NSString * WCHAT_APPID;
@property (nonatomic,PP_STRONG) NSString * WCHAT_APPSECKET;
@property (nonatomic,PP_STRONG) NSString * QQ_APPID;
@property (nonatomic,PP_STRONG) NSString * QQ_APPSECKET;

@property (nonatomic,PP_STRONG) NSString * SMS_APPID;
@property (nonatomic,PP_STRONG) NSString * SMS_APPSCECRET;

@property (nonatomic,PP_STRONG) NSString * TU_AppKey;
+ (HCShareConfig *) config;
+ (HCShareConfig *) config:(NSString *)configFile isDebug:(BOOL)isDebug;
- (id)initWithFile:(NSString *)configFile isDebug:(BOOL)isDebug;
@end
