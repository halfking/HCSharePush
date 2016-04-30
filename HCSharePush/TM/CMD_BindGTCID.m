//
//  CMD_BindGTCID.m
//  Wutong
//
//  Created by 潘婷婷 on 15-8-24.
//  Copyright (c) 2015年 HUANGXUTAO. All rights reserved.
//

#import "CMD_BindGTCID.h"
#import <hccoren/base.h>
#import <HCBaseSystem/database_wt.h>
#import "HCDBHelper(WT).h"
#import "HCCallResultForWT.h"

@implementation CMD_BindGTCID

@synthesize GTclientID,GTuserID;


- (id)init
{
    if(self = [super init])
    {
        CMDID_ = 5301;
        useHttpSender_ = YES;
        isPost_ = NO;
        maxRetryTimes_ = 1;
    }
    return self;
}


- (BOOL)calcArgsAndCacheKey
{
    NSLog(@"A_2_18_0_绑定个推cid和uid");
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          [self GTclientID],@"clientid",
                          [self GTuserID],@"userid",
                          @"2",@"type",
                          @"2.18.0",@"scode",
                          nil];
    if(args_) PP_RELEASE(args_);
    args_ = PP_RETAIN([dic JSONRepresentationEx]);
    if(argsDic_) PP_RELEASE(argsDic_);
    argsDic_ = PP_RETAIN(dic);
    return YES;
}
#pragma mark - query from db
//取原来存在数据库中的数据，当需要快速响应或者网络不通时
- (NSObject *) queryDataFromDB:(NSDictionary *)params
{
    return nil;
}

#pragma mark - parse
- (HCCallbackResult *) parseResult:(NSDictionary *)result
{
    //
    //需要在子类中处理这一部分内容
    //
    HCCallResultForWT * ret = [[HCCallResultForWT alloc]initWithArgs:argsDic_?argsDic_ : [self.args JSONValueEx]
                                                            response:result];
    ret.DicNotParsed = result;
    
    
    
    return PP_AUTORELEASE(ret);
}

- (NSDictionary*)parseData:(NSDictionary *)result
{
    //    NSDictionary * userData = [result objectForKey:@"data"];
    //    if(!userData )
    //    {
    //        id userIDObject = [result objectForKey:@"userid"];
    //        if(userIDObject && [userIDObject intValue]>0)
    //        {
    //            UserInformation * user = [[UserInformation alloc]init];
    //            user.UserID = [userIDObject intValue];
    //            user.UserName = self.LoginID;
    //            return PP_AUTORELEASE(user);
    //        }
    //        else
    //        {
    //            return nil;
    //        }
    //    }
    //    else
    //    {
    //        UserInformation * user = [[UserInformation alloc]initWithDictionary:[result objectForKey:@"data"]];
    //        return PP_AUTORELEASE(user);
    //    }
    return result;
}



@end
