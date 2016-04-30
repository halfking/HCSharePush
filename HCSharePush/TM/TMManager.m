//
//  TMManager.m
//  Wutong
//
//  Created by HUANGXUTAO on 15/8/11.
//  Copyright (c) 2015年 HUANGXUTAO. All rights reserved.
//

#import "TMManager.h"
#import <HCBaseSystem/UserManager.h>
#import "HCBaseSystem/CMDs_WT.h"

#import "shareConfig.h"
#import <TuSDK/TuSDK.h>
#import <GTSDK/GeTuiSdk.h>
#import <HCCallResultForWT.h>

#import "CMD_BindGTCID.h"
#import "HCShareConfig.h"

//#import "UMSocialControllerService.h"
//#import "UMSocial.h"

//#import "UMSocialSinaSSOHandler.h"

//#import "UMSocialWechatHandler.h"
//#import "UMSocialQQHandler.h"
//#import "UMSocialSinaHandler.h"
//#import "UMSocialTencentWeiboHandler.h"
//#import "UMSocialRenrenHandler.h"
//#import "UMSocialQQHandler.h"

//#import <TuSDKGeeV1/TuSDKGeeV1.h>
//#import "TuSDKFramework.h"

#define NotifyActionKey "NotifyAction"
NSString* const NotificationCategoryIdent  = @"ACTIONABLE";
NSString* const NotificationActionOneIdent = @"ACTION_ONE";
NSString* const NotificationActionTwoIdent = @"ACTION_TWO";


@interface TMManager ()<GeTuiSdkDelegate>
{
    //    ShareCompleted currentShareCompleted_;
    NSString * pushToken_;
    NSString * GTClientID_;
    SdkStatus GTStatus_;
    
    BOOL isRunning_;//是否处理激活状态
}


@end


@implementation TMManager

//@synthesize payloadId = _payloadId;


static TMManager * intance_ = nil;
+(id)Instance
{
    if(intance_==nil)
    {
        @synchronized(self)
        {
            if (intance_==nil)
            {
                intance_ = [[TMManager alloc]init];
                [intance_ initConfig];
            }
        }
    }
    return intance_;
}
+(TMManager *)shareObject
{
    return (TMManager *)[self Instance];
}
- (BOOL)initConfig
{
    isRunning_ = NO;
    return YES;
}
- (NSString *) GTClientID
{
    return GTClientID_;
}
- (void)didUserLogin:(NSNotification *)notification
{
    if(!notification || !notification.object) return;
    HCCallResultForWT * result = notification.object;
    //    NSDictionary * dic = notification.userInfo;
    
    if(result.Code==0)
    {
        
        UserInformation * ui = (UserInformation *)result.Data;
        if(ui.UserID>0)
        {
            //绑定uid， cid
            NSString * userID = [NSString stringWithFormat:@"%ld",ui.UserID];
            NSString * clientID = [self GTClientID];
            if (clientID!=nil) {
                [[TMManager shareObject]bindUID:userID andCID:clientID];
            }
        }
    }
}
- (void)startSDK
{
    HCShareConfig * config = [HCShareConfig config];
    //    [[TMManager shareObject] ]
    //    NSError *err = nil;
    
    //[1-1]:通过 AppId、 appKey 、appSecret 启动SDK
    [GeTuiSdk startSdkWithAppId:config.GT_AppID
                         appKey:config.GT_AppKey
                      appSecret:config.GT_AppSecret
                       delegate:self ];
    //                          error:&err];
    
    //[1-2]:设置是否后台运行开关
    [GeTuiSdk runBackgroundEnable:YES];
    
    //    //[1-3]:设置电子围栏功能，开启LBS定位服务 和 是否允许SDK 弹出用户定位请求
    //    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
    
    //    if (err) {
    //        NSLog(@"start getui failure:%@",[err localizedDescription]);
    //    }
    //绑定cid uid。
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CMD_0014" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUserLogin:)
                                                 name:@"CMD_0014" object:nil];
    isRunning_ = YES;
}
- (void)stopSDK
{
    if(isRunning_)
        [GeTuiSdk setPushModeForOff:YES];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CMD_0014" object:nil];
    isRunning_ = NO;
}
- (void)resumeSDK
{
    if(isRunning_) return;
    [GeTuiSdk setPushModeForOff:NO];
    [GeTuiSdk resume];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CMD_0014" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUserLogin:)
                                                 name:@"CMD_0014" object:nil];
    isRunning_ = YES;
}
- (void)enterBackground
{
    if(isRunning_)
    {
        [GeTuiSdk setPushModeForOff:YES];
        //        [GeTuiSdk enterBackground];
    }
    isRunning_ = NO;
}
- (void)registerDeviceToken:(NSString *)token
{
    if(token)
    {
        PP_RELEASE(pushToken_);
        pushToken_ = PP_RETAIN(token);
    }
    if(!pushToken_) pushToken_ = PP_RETAIN(@"");
    [GeTuiSdk registerDeviceToken:pushToken_];
}

#pragma mark - TuSDK
- (void)startTuSDK
{
    HCShareConfig * config = [HCShareConfig config];
    [TuSDK initSdkWithAppKey:config.TU_AppKey];
}

#pragma - mark parse data
- (BOOL)didReceiveRemoteMessage:(NSDictionary *)payloadDic
{
    if([UIApplication sharedApplication].applicationState!=UIApplicationStateActive) return NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_NEWMESSAGE object:self userInfo:payloadDic];
    
    int type = [[payloadDic objectForKey:@"type"] intValue];
    switch (type) {
        case 101:
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_ANNOUNCEMENT object:self userInfo:payloadDic];
            break;
        case 102:
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SYSNOTI object:self userInfo:payloadDic];
            break;
        case 103:
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_PREVIEWMSG object:self userInfo:payloadDic];
            break;
        case 201:
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_COMMENT object:self userInfo:payloadDic];
            break;
        case 301:
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_MUSICIANSONG object:self userInfo:payloadDic];
            break;
        case 302:
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_USERSONG object:self userInfo:payloadDic];
            break;
        case 303:
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_NEWPARTY object:self userInfo:payloadDic];
            break;
        case 401:
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_NEWLIKE object:self userInfo:payloadDic];
            break;
        case 402:
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_BEENSHARED object:self userInfo:payloadDic];
            break;
        case 501:
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CHATWITHUSER object:self userInfo:payloadDic];
            break;
        case 502:
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CHATINPARTY object:self userInfo:payloadDic];
            break;
        case 503:
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CHATWITHCS object:self userInfo:payloadDic];
            break;
        default:
            break;
    }
    //    NSDictionary *pushdata = [userInfo objectForKey:@"userinfo"];
    //    NSDictionary *payloadMsg = [pushdata objectForKey:@"payload"];;
    //    /*
    //     {
    //         userinfo:{
    //            aps:{
    //                content-available:1,
    //                alert:"",
    //                badge:1
    //                },
    //            payload:{
    //                pushtype:1,
    //                param:{....}
    //            }
    //         }
    //     }
    //     */
    //    NSLog(@"得到的payload为：%@",payloadMsg);
    //    NSLog(@"userinfo:%@",userInfo);
    //    NSDictionary *aps = [pushdata objectForKey:@"aps"];
    //    //NSDictionary *alert = [aps objectForKey:@"alert"];
    //
    //    NSNumber *contentAvailable = aps == nil ? nil : [aps objectForKeyedSubscript:@"content-available"];
    //
    //    if (payloadMsg && contentAvailable) {//???
    //        //        NSString *record = [NSString stringWithFormat:@"[APN]%@, %@, [content-available: %@]", [NSDate date], payloadMsg, contentAvailable];
    //    }
    //
    //    //显示收到的alert的文本消息。
    //    {
    //        NSLog(@" 收到推送消息 ： %@",[[pushdata objectForKey:@"aps"] objectForKey:@"alert"]);
    //        //使用个推后，还需要做处理吗？参考个推Demo。
    //    }
    //    //收到通知时发出的声音
    //    {
    //        //使用个推后还需要做处理吗？
    //
    //    }
    //
    //    //处理图标上的红色数字。
    //    {
    //        id v = [[pushdata objectForKey:@"aps"] objectForKey:@"badge"];
    //        int count   = 0;
    //        if(v) count = [v intValue];
    //
    //        //设置Icon上的数字。
    //        [UIApplication sharedApplication].applicationIconBadgeNumber = count;
    //
    //    }
    
    //获得推送类型。按照不同的类型，发布不同的通知出去。参数可以放在object里面。
    //    {
    //        PushMessageType pushType = (PushMessageType)[[payloadMsg objectForKey:@"pushtype"]intValue];//推送类型
    //
    //        NSLog(@"%@",[payloadMsg JSONRepresentationEx]);
    //
    //        //        PushMessageType testid = (PushMessageType)[[payloadMsg objectForKey:@"pushtype"]intValue];
    //
    //
    //        NSDictionary * param = (NSDictionary *)[payloadMsg objectForKey:@"param"];//带的参数。
    //        switch (pushType) {
    //            case OpenDirectBroadcast:
    //            {
    //                [[NSNotificationCenter defaultCenter]postNotificationName:OPEN_DIRECT_BROADCAST
    //                                                                   object:param
    //                                                                 userInfo:nil];
    //                break;
    //            }
    //            case CloseDirectBroadcast:{
    //                [[NSNotificationCenter defaultCenter]postNotificationName:CLOSE_DIRECT_BROADCAST
    //                                                                   object:param
    //                                                                 userInfo:nil];
    //
    //                break;
    //            }
    //            case BeginWatchingMTV:{
    //                [[NSNotificationCenter defaultCenter]postNotificationName:BEGIN_WATCHING_MTV
    //                                                                   object:param
    //                                                                 userInfo:nil];
    //                break;
    //            }
    //            case StopWatching:{
    //                [[NSNotificationCenter defaultCenter]postNotificationName:STOP_WATCHING
    //                                                                   object:param
    //                                                                 userInfo:nil];
    //                break;
    //            }
    //            case AddConcern:{
    //                [[NSNotificationCenter defaultCenter]postNotificationName:ADD_CONCERN
    //                                                                   object:param
    //                                                                 userInfo:nil];
    //                break;
    //            }
    //            case RemoveConcern:{
    //                [[NSNotificationCenter defaultCenter] postNotificationName:REMOVE_CONCERN
    //                                                                    object:param
    //                                                                  userInfo:nil];
    //                break;
    //            }
    //            case NewComments:{
    //                [[NSNotificationCenter defaultCenter] postNotificationName:NEW_COMMENTS
    //                                                                    object:param
    //                                                                  userInfo:nil];
    //                break;
    //            }
    //
    //            default:
    //                break;
    //        }
    //    }
    
    
    //    [[SystemConfiguration sharedSystemConfiguration] getUserSummaryFromServer];
    //    [SystemConfiguration beepOrShaking:0 data:nil];
    //    if([[userInfo objectForKey:@"aps"] objectForKey:@"alert"]!=NULL)
    //    {
    //        [PageBase showNotification:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
    //    }
    //    for (id key in userInfo) {
    //        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    //}
    return YES;
}
//是否要分开处理APNS推送的消息和Getui推送的消息？
-(BOOL) didRecievePayload:(NSDictionary*)payloadDic{
    
    NSLog(@"did receive payload:%@",payloadDic);
    return YES;
}
#pragma mark - do tags

- (void)setDeviceToken:(NSString *)aToken
{
    
    [GeTuiSdk registerDeviceToken:aToken];
}

- (BOOL)setTags:(NSArray *)aTags error:(NSError **)error
{
    return [GeTuiSdk setTags:aTags];
}

- (NSString *)sendMessage:(NSData *)body error:(NSError **)error {
    
    return [GeTuiSdk sendMessage:body error:error];
}

- (void)bindAlias:(NSString *)aAlias {
    [GeTuiSdk bindAlias:aAlias];
}

- (void)unbindAlias:(NSString *)aAlias {
    
    [GeTuiSdk unbindAlias:aAlias];
}
#pragma mark - GexinSdkDelegate
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    PP_RELEASE(GTClientID_);
    GTClientID_ = PP_RETAIN(clientId);
    if (pushToken_) {
        [GeTuiSdk registerDeviceToken:pushToken_];
        NSLog(@"+++++++++++++++ClientID = %@+++++++++++++++",clientId);
        NSLog(@"+++++++++++++++DeviceToken = %@+++++++++++++++",pushToken_);
        
    }
    //FIXME
    //绑定uid，cid。记录cid。怎么取得用户ID
    NSString * userID = nil;
    if ([[UserManager sharedUserManager]userID]>0) {
        userID = [NSString stringWithFormat:@"%ld",[[UserManager sharedUserManager] userID]];
        NSLog(@"UserID: %@,CID:%@",userID,clientId);
        [self bindUID:userID andCID:clientId];
        NSLog(@"成功绑定");
    }
}
//FIXME.绑定cid，uid。
//绑定uid cid

- (void) bindUID:(NSString *)uid andCID:(NSString *)cid{//将两个数据发给服务器。
    
    CMD_CREATE(cmd, BindGTCID, @"BindGTCID");
    cmd.GTuserID = uid;
    cmd.GTclientID = cid;
    
    cmd.CMDCallBack = ^(HCCallbackResult * result)
    {
        NSLog(@"绑定命令成功返回，%@",cid);
    };
    [cmd sendCMD];
    //    return YES;
}
//SDK发给IOSapp的透传消息。
- (void)GeTuiSdkDidReceivePayload:(NSString *)payloadId andTaskId:(NSString *)taskId andMessageId:(NSString *)aMsgId fromApplication:(NSString *)appId
{
    ////     [4]: 收到个推消息
    //    [_payloadId release];
    //    _payloadId = [payloadId retain];
    //    _payloadId= payloadId;
    
    NSLog(@"通过GetuiSDKDidRecievePayload取得了推送消息。");
    NSData* payload = [GeTuiSdk retrivePayloadById:payloadId];//推的是什么就全部拿过来。
    
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                              length:payload.length
                                            encoding:NSUTF8StringEncoding];
    }
    NSLog(@"Payload:%@ ",payloadMsg);
    //将payload转成NSDictionary。
    NSDictionary *payloadDic = [NSJSONSerialization JSONObjectWithData:payload options:NSJSONReadingAllowFragments error:nil];
    
    
    NSLog(@"转换后的payload：%@",payloadDic);
    //做进一步处理。
    [self didReceiveRemoteMessage:payloadDic];
    
    
    
    
    //    NSString *record = [NSString stringWithFormat:@"%d, %@, %@", ++_lastPaylodIndex, [self formateTime:[NSDate date]], payloadMsg];
    //    [_viewController logMsg:record];
    //    [_viewController updateMsgCount:_lastPaylodIndex];
    
    NSLog(@"task id : %@, messageId:%@", taskId, aMsgId);
    
    //    [payloadMsg release];
    
}
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId
{
    ////     [4]: 收到个推消息
    //    [_payloadId release];
    //    _payloadId = [payloadId retain];
    //    _payloadId= payloadId;
    
    NSLog(@"通过GetuiSDKDidRecievePayload取得了推送消息。");
    NSData* payload = payloadData;//推的是什么就全部拿过来。
    
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                              length:payload.length
                                            encoding:NSUTF8StringEncoding];
    }
    NSLog(@"Payload:%@ ",payloadMsg);
    //将payload转成NSDictionary。
    NSDictionary *payloadDic = [NSJSONSerialization JSONObjectWithData:payload options:NSJSONReadingAllowFragments error:nil];
    
    
    NSLog(@"转换后的payload：%@",payloadDic);
    //做进一步处理。
    [self didReceiveRemoteMessage:payloadDic];
    
    
    
    
    //    NSString *record = [NSString stringWithFormat:@"%d, %@, %@", ++_lastPaylodIndex, [self formateTime:[NSDate date]], payloadMsg];
    //    [_viewController logMsg:record];
    //    [_viewController updateMsgCount:_lastPaylodIndex];
    
    NSLog(@"task id : %@, messageId:%@", taskId, msgId);
    
    //    [payloadMsg release];
}
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    //    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
    NSLog(@"sendmessage:%@ result:%d", messageId, result);
    //    [_viewController logMsg:record];
}

- (void)GeTuiSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@">>>[GexinSdk error]:%@", [error localizedDescription]);
}

- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // [EXT]:通知SDK运行状态
    GTStatus_ = aStatus;
    //    [_viewController updateStatusView:self];
}

//SDK设置推送模式回调
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        NSLog(@">>>[SetModeOff error]: %@", [error localizedDescription]);
        return;
    }
    
    NSLog(@">>>[GexinSdkSetModeOff]: %@",isModeOff?@"开启":@"关闭");
    //    [_viewController logMsg:[NSString stringWithFormat:@">>>[GexinSdkSetModeOff]: %@",isModeOff?@"开启":@"关闭"]];
    //
    //    UIViewController *vc = _naviController.topViewController;
    //    if ([vc isKindOfClass:[DemoViewController class]]) {
    //        DemoViewController *nextController = (DemoViewController *)vc;
    //        [nextController updateModeOffButton:isModeOff];
    //    }
    
}
#pragma mark - helper

- (void)registerRemoteNotification {
    
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //IOS8 新的通知机制category注册
        UIMutableUserNotificationAction *action1;
        action1 = [[UIMutableUserNotificationAction alloc] init];
        [action1 setActivationMode:UIUserNotificationActivationModeBackground];
        [action1 setTitle:@"取消"];
        [action1 setIdentifier:NotificationActionOneIdent];
        [action1 setDestructive:NO];
        [action1 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationAction *action2;
        action2 = [[UIMutableUserNotificationAction alloc] init];
        [action2 setActivationMode:UIUserNotificationActivationModeBackground];
        [action2 setTitle:@"回复"];
        [action2 setIdentifier:NotificationActionTwoIdent];
        [action2 setDestructive:NO];
        [action2 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationCategory *actionCategory;
        actionCategory = [[UIMutableUserNotificationCategory alloc] init];
        [actionCategory setIdentifier:NotificationCategoryIdent];
        [actionCategory setActions:@[action1, action2]
                        forContext:UIUserNotificationActionContextDefault];
        
        NSSet *categories = [NSSet setWithObject:actionCategory];
        UIUserNotificationType types = (UIUserNotificationTypeAlert|
                                        UIUserNotificationTypeSound|
                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        PP_RELEASE(action1);
        PP_RELEASE(action2);
        PP_RELEASE(actionCategory);
        
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
                                                                       UIRemoteNotificationTypeSound|
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
                                                                   UIRemoteNotificationTypeSound|
                                                                   UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
    
}
//-(NSString*) formateTime:(NSDate*) date {
//    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"HH:mm:ss"];
//    NSString* dateTime = [formatter stringFromDate:date];
//    PP_RELEASE(formatter);
//
//    return dateTime;
//}

//static void uncaughtExceptionHandler(NSException *exception) {
//    NSLog(@"CRASH: %@", exception);
//    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
//}
@end
