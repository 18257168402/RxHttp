//
//  HttpSessionBuilder.m
//  guard
//
//  Created by 黎书胜 on 2017/11/1.
//  Copyright © 2017年 黎书胜. All rights reserved.
//

#import "HttpSessionBuilder.h"

@implementation HttpSessionBuilder

-(instancetype)init{
    self= [super init];
    
    return self;
}
-(AFHTTPSessionManager*)buildSession{
    AFHTTPSessionManager* session = [AFHTTPSessionManager manager];
   
    session.requestSerializer = [AFHTTPRequestSerializer serializer];//上传普通格式
    //session.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    session.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    //session.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
    
    session.requestSerializer.timeoutInterval = self.timeoutInterval;//设置超时时间
    
     // 个人建议还是自己解析的比较好
    return session;
}
@end
