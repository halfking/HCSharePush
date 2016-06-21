//
//  HCShareConfig.m
//  HCSharePush
//
//  Created by HUANGXUTAO on 16/5/1.
//  Copyright © 2016年 seenvoice.com. All rights reserved.
//

#import "HCShareConfig.h"

@implementation HCShareConfig
@synthesize GT_AppID,GT_AppKey,GT_AppSecret,GT_MasterSecret;
@synthesize ShareUrlRoot,ShareUrl,ShareUrl_User;
@synthesize UmengAppkey,UmengUrl;
@synthesize Sina_AppKey,Sina_AppSecurt,Sina_RedirectUrl;
@synthesize Tencent_APPKey,Tencent_APPScecret,WChat_AppID,WChat_AppScecret,QQ_AppID,QQ_AppScecret;
@synthesize SMS_AppID,SMS_AppScecret;
@synthesize TU_AppKey;

static HCShareConfig *intance_ = nil;

+(HCShareConfig *)config
{
    if(intance_) return intance_;
#ifndef __OPTIMIZE__
    return [self config:nil isDebug:YES];
#else
    return [self config:nil isDebug:NO];
#endif
}
+(HCShareConfig *)config:(NSString *)configFile isDebug:(BOOL)isDebug
{
    static dispatch_once_t pred = 0;
    //    static HCShareConfig *intanceVDC_ = nil;
    dispatch_once(&pred,^
                  {
                      intance_ = [[HCShareConfig alloc] initWithFile:(NSString *)configFile isDebug:isDebug];
                  });
    return intance_;
}
- (id)initWithFile:(NSString *)configFile isDebug:(BOOL)isDebug
{
    if(self = [super init])
    {
        [self readDataFromFile:configFile isDebug:isDebug];
    }
    return self;
}
#pragma mark - set values
- (void)readDataFromFile:(NSString *)configFile isDebug:(BOOL)isDebug
{
    if(!configFile)
    {
        //分享
        ShareUrlRoot   =             @"mbshare.seenvoice.com"; //@"http://www.maibapp.com/share"
        ShareUrl       =             @"http://mbshare.seenvoice.com/?key=%@&t=%d&sid=%ld&mid=%ld";    //分享链接
        ShareUrl_User  =             @"http://mbshare.seenvoice.com/user?id=%ld";
        
        UmengAppkey    =             @"55e01759e0f55ad7fd000d32"; //@"5211818556240bc9ee01db2f"
        UmengUrl       =             @"http://www.umeng.com/social";
        
        if(isDebug)
        {
            GT_AppID  =              @"MQO8miiWr38bHafSCJ1FI9";
            GT_AppKey  =              @"aNiUCQZGeM8VnaOylGmKb7";
            GT_AppSecret  =          @"dYGSjWzImRAQI6w8Xe9iw";
            GT_MasterSecret  =       @"UieBBM6Isz8znf3nrHN5C5";
            
            TU_AppKey    =           @"d1c70916dfa93d25-02-m7elo1"; // 测试版的key
            
        }
        else
        {
            GT_AppID     =           @"TY0nFypgIW66PXxyDyIye1";
            GT_AppKey    =           @"esms2TuFvN9uEOZMD6zJF5";
            GT_AppSecret =           @"chOuU7BFtd64l8LdHUXzPA";
            GT_MasterSecret =        @"inf9JWlLwU65solT5nD498";
            TU_AppKey    =           @"390e6ab0040eae65-02-m7elo1"; // 正式版的key
        }
        
        //新浪微博
        Sina_AppKey    =             @"1848569834";
        Sina_AppSecurt   =           @"ae49a36c3bf4965e87035a9401fd441f";
        Sina_RedirectUrl =           @"http://sns.whalecloud.com/sina2/callback";
        //腾讯微博
        Tencent_APPKey  =            @"801508101";
        Tencent_APPScecret=           @"12452a82cc06164cfb8e57d15ec544e5";
        //微信
        WChat_AppID     =           @"wx36d7396f30d1e01a";
        WChat_AppScecret =           @"2200e75142c303d2bb291d60a8184d96";
        
        //qq
        QQ_AppID    =             @"1104834406";
        QQ_AppScecret =            @"wYvlH3WIujT8GvGG";
        
        //短信
        
        //#define SMS_APPID               @"9e78382244f8"
        //#define SMS_APPSCECRET          @"c455542580c3e38cbbc3ccbc5f3468bb"
        
        //2.0版
        SMS_AppID  =             @"d81e1735dd60";
        SMS_AppScecret =         @"7d063a1df398e42636a255d006f64747";
        
    }
    else
    {
        
    }
}
@end
