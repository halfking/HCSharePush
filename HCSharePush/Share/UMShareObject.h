//
//  UMShareObject.h
//  SuixingSteward
//
//  Created by huang zh on 14-9-22.
//  Copyright (c) 2014年 Suixing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <hccoren/base.h>
#import "PublicEnum.h"

typedef void (^LoginCompleted)(HCLoginType loginType,BOOL success);
typedef void (^ShareCompleted)(BOOL success,NSString * msg);
@interface UMShareObject : NSObject
+(id)Instance;
+(UMShareObject *)shareObject;
- (BOOL)initConfig;
- (BOOL)shareListVC:(UIViewController *)controller loginType:(HCLoginType) loginType url:(NSString *)url shareTitle:(NSString *)title shareContent:(NSString *)content shareImg:(id)image imgUrlString:(NSString *)imageUrlString completed:(ShareCompleted) success ;
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
