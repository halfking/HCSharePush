//
//  CMD_LogEvent.m
//  maiba
//
//  Created by HUANGXUTAO on 16/3/24.
//  Copyright © 2016年 seenvoice.com. All rights reserved.
//

#import "CMD_LogEvent.h"
#import <hccoren/base.h>
#import <HCBaseSystem/database_wt.h>


@implementation CMD_LogEvent
//@synthesize ObjectID,ObjectType,OPType;
@synthesize OpType,Parameters;
- (id)init
{
    if(self = [super init])
    {
        CMDID_ = 23071;
        useHttpSender_ = YES;
        isPost_ = YES;
    }
    return self;
}
- (BOOL)calcArgsAndCacheKey
{
    NSLog(@"A_9_3_0_23071_记录用户操作");
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:@"9.3.0" forKey:@"scode"];
    
    //    favType,objecttype,objectid,operate,userid
    //    [dic setObject:@"like" forKey:@"favtypestr"];
    if(!OpType) OpType = @"";
    [dic setObject:OpType forKey:@"type"];
    if(Parameters)
    {
        [dic setObject:[Parameters JSONRepresentationEx] forKey:@"attrs"];
    }
    [dic setObject:[NSNumber numberWithLong:[self userID]] forKey:@"userid"];
    [dic setObject:[CommonUtil stringFromDate:[NSDate date] andFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"userid"];
    
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
- (NSObject*)parseData:(NSDictionary *)result
{
    return nil;
}

@end
