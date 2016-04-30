//
//  shareConfig.h
//  HCSharePush
//
//  Created by HUANGXUTAO on 16/5/1.
//  Copyright © 2016年 seenvoice.com. All rights reserved.
//

#ifndef shareConfig_h
#define shareConfig_h


#pragma mark ---------推送------------
//推送
//测试是 ＃ifndef

//#ifndef __OPTIMIZE__
//#define GT_AppID                @"MQO8miiWr38bHafSCJ1FI9"
//#define GT_AppKey               @"aNiUCQZGeM8VnaOylGmKb7"
//#define GT_AppSecret            @"dYGSjWzImRAQI6w8Xe9iw"
//#define GT_MasterSecret         @"UieBBM6Isz8znf3nrHN5C5"
//#else
//#define GT_AppID                @"TY0nFypgIW66PXxyDyIye1"
//#define GT_AppKey               @"esms2TuFvN9uEOZMD6zJF5"
//#define GT_AppSecret            @"chOuU7BFtd64l8LdHUXzPA"
//#define GT_MasterSecret         @"inf9JWlLwU65solT5nD498"
//#endif

//消息及通讯
//环信
#define HX_AppID                @"seenvoice#seen"
#define HX_ClientID             @"YXA6lNh38D8xEeWgFQci37rDCQ"
#define HX_Secret               @"YXA6MyIZYxK3KG5LJwipeFsG66lN6X0"

//推送消息类型
//用宏定义避免出错
#define NOTI_NEWMESSAGE     @"_newmessage"
#define NOTI_CLEARMESSAGE   @"_clearmessage"
#define NOTI_REFRESHMESSAGE @"_refreshmessage"

#define NOTI_ANNOUNCEMENT   @"_announcement"
#define NOTI_SYSNOTI        @"_sysnoti"
#define NOTI_PREVIEWMSG     @"_previewmsg"
#define NOTI_COMMENT        @"_comment"
#define NOTI_MUSICIANSONG   @"_musiciansong"
#define NOTI_USERSONG       @"_usersong"
#define NOTI_NEWPARTY       @"_newparty"
#define NOTI_NEWLIKE        @"_newlike"
#define NOTI_BEENSHARED     @"_beenshared"
#define NOTI_CHATWITHUSER   @"_chatwithuser"
#define NOTI_CHATINPARTY    @"_chatinparty"
#define NOTI_CHATWITHCS     @"_chatwithcustomservice"

//
//#pragma mark ----------share -----------
////分享
//#define SHAREURLROOT                @"mbshare.seenvoice.com" //@"http://www.maibapp.com/share"
//#define SHAREURL                    @"http://mbshare.seenvoice.com/?key=%@&t=%d&sid=%ld&mid=%ld"    //分享链接
//#define SHAREURL_USER               @"http://mbshare.seenvoice.com/user?id=%ld"
//
//#define UmengAppkey                 @"55e01759e0f55ad7fd000d32" //@"5211818556240bc9ee01db2f"
//#define UMENGURL                    @"http://www.umeng.com/social"
////新浪微博
//#define SINA_APPKEY                 @"1848569834"
//#define SINA_APPSECKET              @"ae49a36c3bf4965e87035a9401fd441f"
//#define SINA_REDIRECTURL            @"http://sns.whalecloud.com/sina2/callback"
////腾讯微博
//#define Tencent_APPKEY              @"801508101"
//#define Tencent_APPSECKET           @"12452a82cc06164cfb8e57d15ec544e5"
////微信
//#define WCHAT_APPID                @"wx36d7396f30d1e01a"
//#define WCHAT_APPSECKET            @"2200e75142c303d2bb291d60a8184d96"
//
////qq
//#define QQ_APPID                 @"1104834406"
//#define QQ_APPSECKET             @"wYvlH3WIujT8GvGG"
//
////短信
//
////#define SMS_APPID               @"9e78382244f8"
////#define SMS_APPSCECRET          @"c455542580c3e38cbbc3ccbc5f3468bb"
//
////2.0版
//#define SMS_APPID               @"d81e1735dd60"
//#define SMS_APPSCECRET          @"7d063a1df398e42636a255d006f64747"
//
//
//
////TuSDK
//#ifndef __OPTIMIZE__
//#define TU_AppKey               @"d1c70916dfa93d25-02-m7elo1" // 测试版的key
//#else
//#define TU_AppKey               @"390e6ab0040eae65-02-m7elo1" // 正式版的key
////#define TU_AppKey               @"d1c70916dfa93d25-02-m7elo1" // 测试版的key
//#endif

#endif /* shareConfig_h */
