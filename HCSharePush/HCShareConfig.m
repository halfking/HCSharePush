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
@synthesize SHAREURLROOT,SHAREURL,SHAREURL_USER;
@synthesize UmengAppkey,UMENGURL;
@synthesize SINA_APPKEY,SINA_APPSECKET,SINA_REDIRECTURL;
@synthesize Tencent_APPKEY,Tencent_APPSECKET,WCHAT_APPID,WCHAT_APPSECKET,QQ_APPID,QQ_APPSECKET;
@synthesize SMS_APPID,SMS_APPSCECRET;
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
        SHAREURLROOT   =             @"mbshare.seenvoice.com"; //@"http://www.maibapp.com/share"
        SHAREURL       =             @"http://mbshare.seenvoice.com/?key=%@&t=%d&sid=%ld&mid=%ld";    //分享链接
        SHAREURL_USER  =             @"http://mbshare.seenvoice.com/user?id=%ld";
        
        UmengAppkey    =             @"55e01759e0f55ad7fd000d32"; //@"5211818556240bc9ee01db2f"
        UMENGURL       =             @"http://www.umeng.com/social";
        
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
        SINA_APPKEY    =             @"1848569834";
        SINA_APPSECKET   =           @"ae49a36c3bf4965e87035a9401fd441f";
        SINA_REDIRECTURL =           @"http://sns.whalecloud.com/sina2/callback";
        //腾讯微博
        Tencent_APPKEY  =            @"801508101";
        Tencent_APPSECKET=           @"12452a82cc06164cfb8e57d15ec544e5";
        //微信
        WCHAT_APPID     =           @"wx36d7396f30d1e01a";
        WCHAT_APPSECKET =           @"2200e75142c303d2bb291d60a8184d96";
        
        //qq
        QQ_APPID    =             @"1104834406";
        QQ_APPSECKET =            @"wYvlH3WIujT8GvGG";
        
        //短信
        
        //#define SMS_APPID               @"9e78382244f8"
        //#define SMS_APPSCECRET          @"c455542580c3e38cbbc3ccbc5f3468bb"
        
        //2.0版
        SMS_APPID  =             @"d81e1735dd60";
        SMS_APPSCECRET =         @"7d063a1df398e42636a255d006f64747";
        
    }
    else
    {
        
    }
}
@end
