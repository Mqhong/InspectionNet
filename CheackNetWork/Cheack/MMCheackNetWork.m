//
//  MMCheackNetWork.m
//  yinjitong
//
//  Created by mm on 16/8/8.
//  Copyright © 2016年 zhoujia. All rights reserved.
//

#import "MMCheackNetWork.h"
#import "Reachability.h"


@interface MMCheackNetWork()
@property (nonatomic,strong) Reachability *netConnect;
@property (nonatomic,strong) NSURLConnection *connection;
@property (nonatomic,strong) NSURLSession *session;
@end

@implementation MMCheackNetWork

+(BOOL)hasNet{
    MMCheackNetWork *MM = [[MMCheackNetWork alloc]init];
    [MM updateInterfaceWithReachability];
    bool flag = YES;//懒，返回参数并没有什么卵用
    return flag;
}

-(void)addObserverWithCheckNet{
    NSString *urlStr = @"www.baidu.com";
    self.netConnect = [Reachability reachabilityWithHostName:urlStr];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [self.netConnect startNotifier];
}

-(void)reachabilityChanged:(NSNotification *)note{
    //设置了缓冲区，在1秒内多次触发这个函数 将会只执行最后一次
    //取消的函数 必须要和 传入的函数 带的值一样
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateInterfaceWithReachability) object:nil];
    [self performSelector:@selector(updateInterfaceWithReachability) withObject:nil afterDelay:1];
}

-(void)updateInterfaceWithReachability{
//    NSLog(@"重新检查一遍网络");
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    //第二步， 创建请求（requset）
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2];//缓存策略：基础策略，超时设置：10秒
    //第三步  连接服务器
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
#pragma clang diagnostic pop
}


-(void)dealloc{
    [self.netConnect stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error//出现错误
{
    NSLog(@"已失去网络连接");
    NSLog(@"连接出错，判定为没有网");
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"收到网址的回应，判定为有网");
}

@end
