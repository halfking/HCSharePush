//
//  TMManager.h
//  Wutong
//
//  Created by HUANGXUTAO on 15/8/11.
//  Copyright (c) 2015年 HUANGXUTAO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <hccoren/base.h>
/*

userinfo =     {
    aps =         {
        alert = "\U63a8\U9001\U6d4b\U8bd5";
        badge = 1;
        "content_available" = 1;
        sound = default;
    };
    payload =         {
        param =             {
            QAID = 4967;
            objectid = 283;
            objecttype = 40;
            userid = 173;
        };
        pushtype = 2;
    };
};
*/
//typedef void (^LoginCompleted)(HCLoginType loginType);
//typedef void (^ShareCompleted)(BOOL success,NSString * msg);

@interface TMManager : NSObject



//@property (retain, nonatomic) NSString *payloadId;
+(id)Instance;
+(TMManager *)shareObject;
- (BOOL)initConfig;

- (void)startTuSDK;

- (void)startSDK;
- (void)stopSDK;
- (void)resumeSDK;
- (void)enterBackground;
- (void)registerDeviceToken:(NSString *)token;

- (void)setDeviceToken:(NSString *)aToken;
- (BOOL)setTags:(NSArray *)aTags error:(NSError **)error;
- (void)bindAlias:(NSString *)aAlias ;
- (void)unbindAlias:(NSString *)aAlias;
- (NSString *)sendMessage:(NSData *)body error:(NSError **)error ;


- (BOOL)didReceiveRemoteMessage:(NSDictionary *)userInfo;
- (void)registerRemoteNotification;
- (void)bindUID:(NSString *)uid andCID:(NSString *)cid;//返回成功失败的状态。NO代表绑定不成功。YES绑定成功。

//@property (nonatomic,strong)NSString * GTClientID_;
- (NSString *) GTClientID;

@end
