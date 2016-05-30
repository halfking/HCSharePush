//
//  FirstViewController.m
//  HCSharePushTest
//
//  Created by HUANGXUTAO on 16/5/25.
//  Copyright © 2016年 seenvoice.com. All rights reserved.
//

#import "FirstViewController.h"
#import <hccoren/base.h>

#import "UMShareObject.h"
#import "HCShareConfig.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(30, 30, 50, 50)];
        [btn setTitle: @"微信消息" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor grayColor];
        [btn addTarget:self
                action:@selector(shareSession2:)
      forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(120, 30, 50, 50)];
        [btn setTitle: @"朋友圈" forState:UIControlStateNormal];
        
        btn.backgroundColor = [UIColor grayColor];
        [btn addTarget:self
                action:@selector(shareSession:)
      forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(220, 30, 50, 50)];
        [btn setTitle: @"网页朋友圈" forState:UIControlStateNormal];

        btn.backgroundColor = [UIColor grayColor];
        [btn addTarget:self
                action:@selector(shareTimeLine:)
      forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}
- (void)shareSession:(id)sender
{
    UMShareObject * shareObject = [UMShareObject shareObject:YES];
    UIImage * image = [UIImage imageNamed:@"18.pic.jpg"];
    NSString * videoUrl = @"http://media.seenvoice.com/zfvRu2z3c0_uMcdMw-HYZ-k1J2I=/FnK5BYBGQHY7aa6HgXaYdqfin0-P";
    
    
    [shareObject shareListVC:self loginType:HCLoginTypeSession url:@"http://www.seenvoice.com/" shareTitle:@"测试分享" shareContent:@"test" video:videoUrl smallVideo:videoUrl shareImg:image completed:^(BOOL success, NSString *msg) {
        NSLog(@"success:%d",success);
    }];
    
}
- (void)shareSession2:(id)sender
{
    UMShareObject * shareObject = [UMShareObject shareObject:YES];
    UIImage * image = [UIImage imageNamed:@"18.pic.jpg"];
    NSString * videoUrl = @"http://media.seenvoice.com/zfvRu2z3c0_uMcdMw-HYZ-k1J2I=/FnK5BYBGQHY7aa6HgXaYdqfin0-P";
    
    
    [shareObject shareListVC:self loginType:HCLoginTypeWeixin url:@"http://www.seenvoice.com/" shareTitle:@"测试分享" shareContent:@"test"  video:videoUrl smallVideo:videoUrl shareImg:image completed:^(BOOL success, NSString *msg) {
        NSLog(@"success:%d",success);
    }];
    
}
- (void)shareTimeLine:(id)sender
{
    UMShareObject * shareObject = [UMShareObject shareObject:YES];
    UIImage * image = [UIImage imageNamed:@"18.pic.jpg"];
    NSString * videoUrl = @"http://media.seenvoice.com/zfvRu2z3c0_uMcdMw-HYZ-k1J2I=/FnK5BYBGQHY7aa6HgXaYdqfin0-P";
    
    [shareObject shareListVC:self loginType:HCLoginTypeSession url:videoUrl  shareTitle:@"测试分享2" shareContent:@"测试分享3" shareImg:image imgUrlString:nil
                   completed:^(BOOL success, NSString *msg) {
                       NSLog(@"success:%d",success);
                   }];
    
    //    [shareObject shareListVC:self loginType:HCLoginTypeSession url:@"http://www.seenvoice.com/" shareTitle:@"测试分享" video:videoUrl smallVideo:videoUrl shareImg:image completed:^(BOOL success, NSString *msg) {
    //        NSLog(@"success:%d",success);
    //    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
