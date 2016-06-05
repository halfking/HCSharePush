//
//  UMShareObject.h
//  SuixingSteward
//
//  Created by huang zh on 14-9-22.
//  Copyright (c) 2014年 Suixing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <hccoren/base.h>
#import <HCBaseSystem/PublicEnum.h>

typedef void (^LoginCompleted)(HCLoginType loginType,BOOL success);
typedef void (^ShareCompleted)(BOOL success,NSString * msg);

@class HCShareConfig;

@interface UMShareObject : NSObject

+ (id)Instance:(BOOL)isDebug;
//使用不带参数的ShareObject前，请先用带参数的函数初始化
+ (UMShareObject *)shareObject;
+ (UMShareObject *)shareObject:(BOOL)isDebug;
- (BOOL)initConfig:(BOOL)isDebug;
- (BOOL)reloadConfig;
- (BOOL)reloadConfig:(HCShareConfig *)config;
//常用网页分享
- (BOOL)shareListVC:(UIViewController *)controller
          loginType:(HCLoginType) loginType
                url:(NSString *)url
         shareTitle:(NSString *)title
       shareContent:(NSString *)content
           shareImg:(id)image
       imgUrlString:(NSString *)imageUrlString
          completed:(ShareCompleted) success ;

//直接发送视频到微信或图片，结果还是Url
- (BOOL)shareListVC:(UIViewController *)controller loginType:(HCLoginType) loginType
                url:(NSString *)url
         shareTitle:(NSString *)title
       shareContent:(NSString *)content
              video:(NSString *)videoUrl
         smallVideo:(NSString *)smallVideo
           shareImg:(UIImage *)image
          completed:(ShareCompleted) success;

//直接发送文件到微信
- (BOOL)shareListVC:(UIViewController *)controller loginType:(HCLoginType) loginType
                url:(NSString *)url
         shareTitle:(NSString *)title
       shareContent:(NSString *)content
          videoPath:(NSString *)videoPath
           shareImg:(UIImage *)image
          completed:(ShareCompleted) success;

- (void)login:(UIViewController *)controller loginType:(HCLoginType )loginType completed:(LoginCompleted)completed;
- (BOOL)isInstalled:(HCLoginType) loginType;

- (BOOL)logout;

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;


- (void)beginLogPageView:(NSString *)pageName;
- (void)endLogPageView:(NSString *)pageName;
- (void)event:(NSString *)eventId;
- (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;
- (void)event:(NSString *)eventId type:(NSString *)type attributes:(NSDictionary *)attributes;
- (BOOL)isLoginNotExpired;
- (void)closeCrashReport;
@end
