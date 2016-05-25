//
//  UMShareObject.m
//  SuixingSteward
//
//  Created by huang zh on 14-9-22.
//  Copyright (c) 2014年 Suixing. All rights reserved.
//

#import "UMShareObject.h"
#import <HCBaseSystem/UserManager.h>
#import "HCBaseSystem/CMDs_WT.h"

#import "WxApi.h"
#import <CoreLocation/CoreLocation.h>
#import <hccoren/Reachability.h>
#import <hccoren/HWindowStack.h>
#import <UMengAnalytics-NO-IDFA/UMMobClick/MobClick.h>
#import <SMS_SDK/SMSSDK.h>
//#import <SMS_SDK/SMSSDK+AddressBookMethods.h>
#import <MOBFoundation/MOBFoundation.h>


#import "CMD_LogEvent.h"
#import "CMD_LogEvent.h"

#import <UMengSocial/UMSocial.h>
#import <UMengSocial/UMSocialQQHandler.h>
#import <UMengSocial/UMSocialSinaSSOHandler.h>
#import <UMengSocial/UMSocialWechatHandler.h>
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


@interface UMShareObject ()<UIActionSheetDelegate,UMSocialUIDelegate,UMSocialDataDelegate,WXApiDelegate>
{
    ShareCompleted currentShareCompleted_;
}

@end

@implementation UMShareObject

static UMShareObject * intance_ = nil;
+(id)Instance:(BOOL)isDebug
{
    if(intance_==nil)
    {
        @synchronized(self)
        {
            if (intance_==nil)
            {
                intance_ = [[UMShareObject alloc]init];
                [intance_ initConfig:isDebug];
            }
        }
    }
    return intance_;
}
+(UMShareObject *)shareObject:(BOOL)isDebug
{
    return (UMShareObject *)[self Instance:isDebug];
}
- (BOOL)initConfig:(BOOL)isDebug
{
    //打开调试log的开关
    [UMSocialData openLog:YES];
    HCShareConfig * config = [HCShareConfig config:nil isDebug:isDebug];
    //    如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    //    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:config.UmengAppkey];
    UMAnalyticsConfig * umc = [UMAnalyticsConfig new];
    umc.appKey = config.UmengAppkey;
    umc.ePolicy = BATCH;
    
    [MobClick startWithConfigure:umc];
    //    [MobClick startWithAppkey:config.UmengAppkey reportPolicy:BATCH   channelId:nil]; //default appstore
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    //    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline]];
    
    [UMSocialQQHandler setQQWithAppId:config.QQ_APPID appKey:config.QQ_APPSECKET url:config.SHAREURLROOT];
    [UMSocialWechatHandler setWXAppId:config.WCHAT_APPID appSecret:config.WCHAT_APPSECKET url:config.SHAREURLROOT];
    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:config.SINA_REDIRECTURL];
    
    
    [SMSSDK registerApp:config.SMS_APPID withSecret:config.SMS_APPSCECRET];
    
    [WXApi registerApp:config.WCHAT_APPID];
    
    //    [[MOBFDataService sharedInstance] setCacheData:[[alertView textFieldAtIndex:0] text] forKey:@"appKey" domain:nil];
    //    [[MOBFDataService sharedInstance] setCacheData:[[alertView textFieldAtIndex:1] text] forKey:@"appSecret" domain:nil];
    
    /** 设置是否开启background模式, 默认YES. */
    //    + (void)setBackgroundTaskEnabled:(BOOL)value;
#ifndef __OPTIMIZE__
    [MobClick setLogEnabled:YES];
#endif
    return YES;
    
}
#pragma mark - Umeng events
- (void)beginLogPageView:(NSString *)pageName
{
    [MobClick beginLogPageView:pageName];
}
- (void)endLogPageView:(NSString *)pageName
{
    [MobClick endLogPageView:pageName];
}
- (void)event:(NSString *)eventId
{
    [MobClick event:eventId];
}
- (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes
{
    if([Reachability networkAvailable])
    {
        [MobClick event:eventId attributes:attributes];
    }
}
- (void)event:(NSString *)eventId type:(NSString *)type attributes:(NSDictionary *)attributes
{
    if([Reachability networkAvailable])
    {
        [MobClick event:[NSString stringWithFormat:@"%@_%@",eventId,type] attributes:attributes];
        
        CMD_CREATEN(cmd, LogEvent);
        cmd.OpType = type;
        cmd.Parameters = attributes;
        [cmd sendCMD];
    }
}
#pragma mark - wx delegate

-(void) onReq:(BaseReq*)req
{
    //    if([req isKindOfClass:[GetMessageFromWXReq class]])
    //    {
    //        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
    //        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
    //        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
    //
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //        alert.tag = 1000;
    //        [alert show];
    //        [alert release];
    //    }
    //    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    //    {
    //        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
    //        WXMediaMessage *msg = temp.message;
    //
    //        //显示微信传过来的内容
    //        WXAppExtendObject *obj = msg.mediaObject;
    //
    //        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
    //        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
    //
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //        [alert show];
    //        [alert release];
    //    }
    //    else if([req isKindOfClass:[LaunchFromWXReq class]])
    //    {
    //        //从微信启动App
    //        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
    //        NSString *strMsg = @"这是从微信启动的消息";
    //
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //        [alert show];
    //        [alert release];
    //    }
}

-(void) onResp:(BaseResp*)resp
{
#ifndef __OPTIMIZE_
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSLog(@"发送媒体消息结果");
        
        NSLog(@"errcode:%d", resp.errCode);
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];
        //        [alert release];
    }
#endif
}
#pragma mark - share
- (BOOL)shareListVC:(UIViewController *)controller loginType:(HCLoginType)loginType url:(NSString *)url shareTitle:(NSString *)title shareContent:(NSString *)content shareImg:(id)image  imgUrlString:(NSString *)imageUrlString completed:(ShareCompleted)success
{
    HCShareConfig * config = [HCShareConfig config];
    currentShareCompleted_ = success;
    if([url hasPrefix:@"http://"]||[url hasPrefix:@"https://"])
    {
        NSLog(@"share url:%@",url);
    }
    else //此时，URL可能是Key
    {
        url = [NSString stringWithFormat:config.SHAREURL,url,(int)loginType,(long)0,(long)0];
    }
    
    //    //[UMSocialConfig setFinishToastIsHidden:NO ];  关闭返回信息》》》分享成功
    //    [UMSocialConfig setFinishToastIsHidden:NO position:UMSocialiToastPositionCenter]; // 不显示分享返回信息
    //    //图片是URL时   @"http://www.baidu.com/img/bdlogo.gif"
    //    if ([image isKindOfClass:[NSString class]]) {
    //        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:image];
    //    }
    //    else
    //    {
    //    }
    
    DeviceConfig * deviceConfig = [DeviceConfig config];
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(deviceConfig.AccuraceLat,deviceConfig.AccuraceLng);
    
    CLLocation * location = nil;
    if(CLLocationCoordinate2DIsValid(loc))
    {
        location =  [[CLLocation alloc]initWithLatitude:deviceConfig.AccuraceLat longitude:deviceConfig.AccuraceLng];
    }
    
    if(loginType == HCLoginTypeWeixin)
    {
        //设置微信AppId，设置分享url，默认使用友盟的网址
        [UMSocialWechatHandler setWXAppId:config.WCHAT_APPID appSecret:config.WCHAT_APPSECKET url:url];
        {
            //        [UMSocialData defaultData].extConfig.title = @"朋友圈分享内容";  //只显示分享标题
            //        //设置微信好友或者朋友圈的分享url,下面是微信好友，微信朋友圈对应wechatTimelineData
            //        [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
        }
        [UMSocialData defaultData].extConfig.wechatSessionData.title=title;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession]
                                                            content:content
                                                              image:image
                                                           location:location
                                                        urlResource:nil
                                                presentedController:controller
                                                         completion:^(UMSocialResponseEntity *response){
                                                             [self didFinishGetUMSocialDataInViewController:response];
                                                         }];
        
    }
    else if(loginType == HCLoginTypeSession)
    {
        [UMSocialWechatHandler setWXAppId:config.WCHAT_APPID appSecret:config.WCHAT_APPSECKET url:url];
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;//朋友圈
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline]
                                                            content:content
                                                              image:image
                                                           location:location
                                                        urlResource:nil
                                                presentedController:controller
                                                         completion:^(UMSocialResponseEntity *response){
                                                             [self didFinishGetUMSocialDataInViewController:response];
                                                         }];
    }
    else if(loginType == HCLoginTypeSinaWeibo)
    {
        
        //    NSString *callBackStr = @"http://sns.whalecloud.com/sina2/callback";
        //    //打开新浪微博的SSO开关
        //    [UMSocialSinaHandler openSSOWithRedirectURL:nil];
        //
        //    //打开腾讯微博SSO开关，设置回调地址
        //    [UMSocialTencentWeiboHandler openSSOWithRedirectUrl:callBackStr];
        //
        //    //打开人人网SSO开关
        //    [UMSocialRenrenHandler openSSO];
        
        [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:config.SINA_REDIRECTURL];
        NSString *text = [NSString stringWithFormat:@"%@\n%@",title,content];
        [[UMSocialControllerService defaultControllerService] setShareText:text shareImage:image socialUIDelegate:self]; //设置分享内容和回调对象
        
        //        if(imageUrlString)
        //        {
        //            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeVideo url:url];
        //        }
        //        else
        //        {
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeVideo url:url];
        //        }
        //        if(image)
        //        {
        //            [UMSocialData defaultData].extConfig.sinaData.shareImage = image;
        //        }
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(controller,[UMSocialControllerService defaultControllerService],YES);
    }
    else if(loginType == HCLoginTypeQQ)
    {
        //设置分享到QQ空间的应用Id，和分享url 链接
        [UMSocialQQHandler setQQWithAppId:config.QQ_APPID appKey:config.QQ_APPSECKET url:url];
        
        if ([content isEqualToString:@""]) {
            content = [content stringByAppendingString:@" "];
        }
        //设置支持没有客户端情况下使用SSO授权
        [UMSocialQQHandler setSupportWebView:YES];
        [UMSocialData defaultData].extConfig.qqData.title = title;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ]
                                                            content:content
                                                              image:image
                                                           location:location
                                                        urlResource:nil
                                                presentedController:controller
                                                         completion:^(UMSocialResponseEntity *response){
                                                             [self didFinishGetUMSocialDataInViewController:response];
                                                         }];
    }
    else if (loginType == HCLoginTypeQZone)
    {
        //通过QQ空间分享。
        //设置分享到QQ空间的应用Id，和分享url 链接
        [UMSocialQQHandler setQQWithAppId:config.QQ_APPID appKey:config.QQ_APPSECKET url:url];
        
        //设置支持没有客户端情况下使用SSO授权
        [UMSocialQQHandler setSupportWebView:YES];
        //        [UMSocialQQHandler setSupportQzoneSSO:YES];
        [UMSocialData defaultData].extConfig.qzoneData.title = title;
        
        if ([content isEqualToString:@""]) {
            content = [content stringByAppendingString:@" "];
        }
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone]
                                                            content:content
                                                              image:image
                                                           location:location
                                                        urlResource:nil
                                                presentedController:controller
                                                         completion:^(UMSocialResponseEntity *response){
                                                             [self didFinishGetUMSocialDataInViewController:response];
                                                         }];
        
    }
    //    else if(loginType == HCLoginTypeLinker)
    //    {
    //
    //    }
    return YES;
}

//直接上传视频到微信或图片
- (BOOL)shareListVC:(UIViewController *)controller loginType:(HCLoginType) loginType
                url:(NSString *)url
         shareTitle:(NSString *)title
              video:(NSString *)videoUrl
         smallVideo:(NSString *)smallVideo
           shareImg:(UIImage *)image
          completed:(ShareCompleted) success
{
    HCShareConfig * config = [HCShareConfig config];
    currentShareCompleted_ = success;
    DeviceConfig * deviceConfig = [DeviceConfig config];
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(deviceConfig.AccuraceLat,deviceConfig.AccuraceLng);
    
    CLLocation * location = nil;
    if(CLLocationCoordinate2DIsValid(loc))
    {
        location =  [[CLLocation alloc]initWithLatitude:deviceConfig.AccuraceLat longitude:deviceConfig.AccuraceLng];
    }
    
    if(loginType == HCLoginTypeWeixin)
    {
        [UMSocialWechatHandler setWXAppId:config.WCHAT_APPID appSecret:config.WCHAT_APPSECKET url:url];
        
        [WXApi registerApp:config.WCHAT_APPID];
        
        WXMediaMessage * message = [WXMediaMessage message];
        message.title = title;
        message.description = title;
        if(image)
        {
            [message setThumbImage:image];
        }
        if(videoUrl)
        {
            WXVideoObject * videoObject = [WXVideoObject object];
            videoObject.videoUrl = videoUrl;
            videoObject.videoLowBandUrl = smallVideo;
            message.mediaObject = videoObject;
        }
        else
        {
            if(success)
            {
                success(NO,@"sender error");
            }
            return NO;
        }
        SendMessageToWXReq * req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;
        
        if([WXApi sendReq:req])
        {
            if(success)
            {
                success(YES,nil);
            }
        }
        else
        {
            if(success)
            {
                success(NO,@"sender error");
            }
        }
        
    }
    else if(loginType == HCLoginTypeSession)
    {
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        WXMediaMessage *message = [WXMediaMessage message];
        
        message.title = title;
        message.description = title;
        if(image)
        {
            [message setThumbImage:image];
        }
        if(videoUrl)
        {
            WXVideoObject * videoObject = [WXVideoObject object];
            videoObject.videoUrl = videoUrl;
            videoObject.videoLowBandUrl = smallVideo;
            message.mediaObject = videoObject;
        }
        else
        {
            if(success)
            {
                success(NO,@"sender error");
            }
            return NO;
        }
        
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;
        
        if([WXApi sendReq:req])
        {
            if(success)
            {
                success(YES,nil);
            }
        }
        else
        {
            if(success)
            {
                success(NO,@"sender error");
            }
        }
        
    }
    else if(loginType == HCLoginTypeQQ)
    {
        return NO;
    }
    else if (loginType == HCLoginTypeQZone)
    {
        return NO;
    }
    return YES;
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseCode == UMSResponseCodeCancel) {
        currentShareCompleted_(NO,@"");
        return;
    }
    if (response.responseCode == UMSResponseCodeSuccess)
    {
        if(currentShareCompleted_)
        {
            currentShareCompleted_(YES,@"");
        }
        //分享成功
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:MSG_PROMPT message:@"分享成功" delegate:self cancelButtonTitle:EDIT_IKNOWN otherButtonTitles:nil, nil];
        //        [alert show];
        //        PP_RELEASE(alert);
    } else {
        
        NSString * message = response.message;
        if([response.data objectForKey:@"sina"])
        {
            NSDictionary * dic = [response.data objectForKey:@"sina"];
            if([dic objectForKey:@"msg"])
            {
                message = [dic objectForKey:@"msg"];
            }
        }
        
        NSLog(@"分享失败:%@",message);
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:MSG_PROMPT
        //                                                        message:@"分享失败"//[NSString stringWithFormat:@"分享失败:%@",message]
        //                                                       delegate:self cancelButtonTitle:EDIT_IKNOWN otherButtonTitles:nil, nil];
        //        [alert show];
        //        PP_RELEASE(alert);
        if(currentShareCompleted_)
        {
            currentShareCompleted_(NO,message);
            
        }
    }
    currentShareCompleted_ = nil;
}
- (void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
{
    NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    NSLog(@"log...");
}
#pragma mark - login
- (void)login:(UIViewController *)controller loginType:(HCLoginType )loginType completed:(LoginCompleted)completed
{
    if(loginType == HCLoginTypeQQ)
    {
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
        
        snsPlatform.loginClickHandler(controller,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            //------------QQ------------------
            //          获取微博用户名、uid、token等
            //        // username is 1060, uid is D8FC99D9296322CCF50513680A626B41, token is 2BCB1D13F78CA08B4B8A0D44DD090E0B url is http://q.qlogo.cn/qqapp/1104637156/D8FC99D9296322CCF50513680A626B41/100
            //        (__36-[WelcomeViewController LoginViaQQ:]_block_invoke_2) (WelcomeViewController.m:254) SnsInformation is {
            //            "access_token" = 2BCB1D13F78CA08B4B8A0D44DD090E0B;
            //            gender = "\U7537";
            //            openid = D8FC99D9296322CCF50513680A626B41;
            //            "profile_image_url" = "http://qzapp.qlogo.cn/qzapp/1104637156/D8FC99D9296322CCF50513680A626B41/100";
            //            "screen_name" = 1060;
            //            uid = D8FC99D9296322CCF50513680A626B41;
            //            verified = 0;
            //        }
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
                
                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                
                
                [[UserManager sharedUserManager]userLogin:snsAccount.userName
                                                   userid:snsAccount.usid
                                                     icon:snsAccount.iconURL
                                             accessTocken:snsAccount.accessToken
                                                   source:HCLoginTypeQQ
                                                completed:^(BOOL finished)
                 {
                     if(completed)
                     {
                         completed(loginType,snsAccount.usid && snsAccount.usid.length>0);
                     }
                 }];
                
                //                // 获取第三方的性别之后，在我们平台修改性别之后，以谁为主
                //                [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
                //                    NSLog(@"SnsInformation is %@",response.data);
                //                    [[UserManager sharedUserManager]setUserInfo:response.data
                //                                                         source:HCLoginTypeQQ];
                //                }];
                
                //                if(completed)
                //                {
                //                    completed(loginType);
                //                }
            }});
    }
    else if(loginType == HCLoginTypeWeixin)
    {
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        
        snsPlatform.loginClickHandler(controller,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            //          获取微博用户名、uid、token等
            //
            //        username is 半径, uid is owzaDt5fedK4V4NYWFrQ-nQvE2c0, token is OezXcEiiBSKSxW0eoylIeL3k7R2d8zy6U3BSK5l-kavuDDOwJB8p9kzi4x09i2rwatUCYVQZ3P7EBOTabaYHfnuAEmooaYa_k6ae_adINgCUJoOgMJn4nC01ogwKDl0f31Xb7luaUtM9gtyGwA0ICw url is http://wx.qlogo.cn/mmopen/ajNVdqHZLLAhS3n8OH5p08jKrEKj9dIy9fiaZYO40ESRQbkc6DAiblZQSnCJvYYhjFwC7m0Cl91wqf0hoNumrvnQ/0
            //        SnsInformation is {
            //            "access_token" = "OezXcEiiBSKSxW0eoylIeL3k7R2d8zy6U3BSK5l-kavuDDOwJB8p9kzi4x09i2rwatUCYVQZ3P7EBOTabaYHfnuAEmooaYa_k6ae_adINgCUJoOgMJn4nC01ogwKDl0f31Xb7luaUtM9gtyGwA0ICw";
            //            gender = 1;
            //            location = "CN, Zhejiang, Hangzhou";
            //            openid = "owzaDt5fedK4V4NYWFrQ-nQvE2c0";
            //            "profile_image_url" = "http://wx.qlogo.cn/mmopen/ajNVdqHZLLAhS3n8OH5p08jKrEKj9dIy9fiaZYO40ESRQbkc6DAiblZQSnCJvYYhjFwC7m0Cl91wqf0hoNumrvnQ/0";
            //            "screen_name" = "\U534a\U5f84";
            //        }
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];
                
                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                
                if(snsAccount.usid && snsAccount.usid.length>0)
                {
                    
                    [[UserManager sharedUserManager]userLogin:snsAccount.userName
                                                       userid:snsAccount.usid
                                                         icon:snsAccount.iconURL
                                                 accessTocken:snsAccount.accessToken
                                                       source:HCLoginTypeWeixin
                                                    completed:^(BOOL finished)
                     {
                         if(completed)
                         {
                             completed(loginType,snsAccount.usid && snsAccount.usid.length>0);
                         }
                     }];
                    
                    
                    
                    //                    // 获取第三方的性别之后，在我们平台修改性别之后，以谁为主
                    //                    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
                    //                        NSLog(@"SnsInformation is %@",response.data);
                    //                        [[UserManager sharedUserManager]setUserInfo:response.data
                    //                                                             source:HCLoginTypeWeixin];
                    //                    }];
                }
                else
                {
                    if(completed)
                    {
                        completed(loginType,NO);
                    }
                }
                
            }}
                                      );
    }
    else if(loginType == HCLoginTypeSinaWeibo)
    {
        
        //    //test upload
        //    UDManager * manager = [UDManager sharedUDManager];
        //    NSString * key = [[[manager itemList] allKeys]objectAtIndex:0];
        //
        //    NSLog(@"stop....:%@",[manager itemList]);
        //
        //    [manager stopProgress:key];
        //
        //    return;
        //
        //    [self loginDone:1];
        //    return;
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        
        [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
        
        snsPlatform.loginClickHandler(controller,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            //          获取微博用户名、uid、token等
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                
                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                
                if(snsAccount.usid && snsAccount.usid.length>0)
                {
                    
                    
                    [[UserManager sharedUserManager]userLogin:snsAccount.userName
                                                       userid:snsAccount.usid
                                                         icon:snsAccount.iconURL
                                                 accessTocken:snsAccount.accessToken
                                                       source:HCLoginTypeSinaWeibo
                                                    completed:^(BOOL finished)
                     {
                         if(completed)
                         {
                             completed(loginType,snsAccount.usid && snsAccount.usid.length>0);
                         }
                     }];
                    // 获取第三方的性别之后，在我们平台修改性别之后，以谁为主
                    //                    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                    //                        NSLog(@"SnsInformation is %@",response.data);
                    //                        [[UserManager sharedUserManager]setUserInfo:response.data
                    //                                                             source:HCLoginTypeSinaWeibo];
                    //                    }];
                }
                else
                {
                    if(completed)
                    {
                        completed(loginType,NO);
                    }
                }
                
            }
            else
            {
                NSLog(@"error:%@",[response.error localizedDescription]);
            }
        });
    }
}

- (BOOL)isInstalled:(HCLoginType)loginType
{
    if(loginType==HCLoginTypeQQ)
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            return YES;
            
        }
    }
    else if(loginType == HCLoginTypeWeixin)
    {
        if ([WXApi isWXAppInstalled]) {
            return YES;
        }
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
            return YES;
        }
    }
    else if(loginType == HCLoginTypeSinaWeibo)
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weibo://"]]) {
            return YES;
        }
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
            return YES;
        }
        
        //        else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sina://"]]) {
        //                return YES;
        //        }
    }
    //FIXME：还需要判断是否安装了QQ空间。
    else if (loginType ==HCLoginTypeQZone){
        //        if ([UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@""]){}
        if(1==2){
            return YES;
        }
    }
    return NO;
}

- (BOOL)logout
{
    if(![[UserManager sharedUserManager]isLogin]) return NO;
    
    UserInformation * user = [UserManager sharedUserManager].currentUser;
    if(user.LoginType == HCLoginTypeSinaWeibo)
    {
        [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
            NSLog(@"response is %@",response);
            [[UserManager sharedUserManager]userLogout];
        }];
    }
    else if(user.LoginType == HCLoginTypeQQ)
    {
        [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
            NSLog(@"response is %@",response);
            [[UserManager sharedUserManager]userLogout];
        }];
    }
    else if(user.LoginType==HCLoginTypeWeixin)
    {
        [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
            NSLog(@"response is %@",response);
            [[UserManager sharedUserManager]userLogout];
        }];
    }
    else
    {
        [[UserManager sharedUserManager]userLogout];
    }
    return YES;
}
#pragma mark - weibox delegate

#pragma mark - open url
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    BOOL result = NO;
    //从链接打开
    if([[url scheme]isEqualToString:@"maibappsv"])
    {
        if([[HWindowStack shareObject]isLaunched])
        {
            UIViewController<PageDelegate> * currentPage = [[HWindowStack shareObject]getLastVc];
            [[HWindowStack shareObject]openWindow:currentPage urlString:url.absoluteString
                                    shouldOpenWeb:YES
                                          animate:NO
                                        popToRoot:NO
                                        direction:nil];
        }
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIViewController<PageDelegate> * currentPage = [[HWindowStack shareObject]getLastVc];
                [[HWindowStack shareObject]openWindow:currentPage urlString:url.absoluteString
                                        shouldOpenWeb:YES
                                              animate:NO
                                            popToRoot:NO
                                            direction:nil
                 ];
            });
        }
        return YES;
    }
    else
    {
        result = [UMSocialSnsService handleOpenURL:url];
    }
    if (result == FALSE) {
        //调用其他SDK，例如新浪微博SDK等
    }
    return result;
}

//涉及微信支付
//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    NSLog(@"appdelegate 》》url.absoluteString》》%@",[url absoluteString]);
//    if([[url absoluteString] rangeOfString:@"suixing.com:"].length>0)
//    {
//        NSString * urlString = [url absoluteString];
//        NSArray * array = [urlString componentsMatchedByRegex:@"(\\d+)"];
//        NSString * hotelIDString = array.count>0?[array objectAtIndex:0]:@"-1";
//        int hotelID = 0;
//        if(hotelIDString && hotelIDString.length>0)
//        {
//            hotelID = [hotelIDString intValue];
//
//        }
//
//        UIAlertView *alertView;
//        NSString*text = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        text = [NSString stringWithFormat:@"%@-%@",text,[url host]];
//        for (int i = 1; i<array.count; i++) {
//            text = [NSString stringWithFormat:@"%@-%@",text,[array objectAtIndex:i]];
//        }
//
//        alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Text-%d",hotelID]
//                                               message:text
//                                              delegate:nil
//                                     cancelButtonTitle:@"OK"
//                                     otherButtonTitles:nil];
//        [alertView show];
//        PP_RELEASE(alertView);
//    }
//    else if ([[url absoluteString] rangeOfString:[NSString stringWithFormat:@"%@:",WCHAT_APPID]].length>0)
//    {
//        [WXApi handleOpenURL:url delegate:self]; //***
//    }
//    else if ([url.host isEqualToString:@"safepay"])
//    {//SuixingSteward://safepay/?%7B%22memo%22:%7B%22ResultStatus%22:%226001%22,%22memo%22:%22%E7%94%A8%E6%88%B7%E4%B8%AD%E9%80%94%E5%8F%96%E6%B6%88%22,%22result%22:%22%22%7D,%22requestType%22:%22safepay%22%7D
//        [[AlipaySDK defaultService]
//         processOrderWithPaymentResult:url
//         standbyCallback:^(NSDictionary *resultDic)
//         {
//             NSLog(@"result = %@", resultDic);
//             NSString *resultCode = [resultDic objectForKey:@"resultStatus"];
//             if ([resultCode isEqualToString:@"9000"]) {
//                 [self alertN:@"提示" msg:@"订单支付成功"];
//             }else if ([resultCode isEqualToString:@"8000"]) {
//                 [self alertN:@"提示" msg:@"正在处理中"];
//             }else if ([resultCode isEqualToString:@"4000"]) {
//                 [self alertN:@"提示" msg:@"订单支付失败"];
//             }else if ([resultCode isEqualToString:@"6001"]) {
//                 [self alertN:@"提示" msg:@"用户中途取消"];
//             }else if ([resultCode isEqualToString:@"6002"]) {
//                 [self alertN:@"提示" msg:@"网络连接出错"];
//             }
//
//         }];
//    }
//
//    if ([url.host isEqualToString:@"platformapi"])//支付宝钱包快登授权返回 authCode
//    {
//        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic)
//         {
//             NSLog(@"result = %@",resultDic);
//         }];
//    }
//
//
//    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
//
//    //    NSLog(@"%@",[url path]);
//    //    NSLog(@"%@",sourceApplication);
//    //    NSLog(@"%@",annotation);
//    //    return NO;
//}
- (BOOL) isLoginNotExpired
{
    //    return [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
    return NO;
}
- (void)closeCrashReport
{
    //关闭友盟错误统计
    [MobClick setCrashReportEnabled:NO];
}
@end
