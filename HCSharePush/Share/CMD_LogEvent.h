//
//  CMD_LogEvent.h
//  maiba
//
//  Created by HUANGXUTAO on 16/3/24.
//  Copyright © 2016年 seenvoice.com. All rights reserved.
//

#import "CMDOP_WT.h"
@interface CMD_LogEvent : CMDOP_WT
@property (nonatomic, PP_STRONG) NSString * OpType;
@property (nonatomic, PP_STRONG) NSDictionary * Parameters;
@end
