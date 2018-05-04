//
//  HttpSessionBuilder.h
//  guard
//
//  Created by 黎书胜 on 2017/11/1.
//  Copyright © 2017年 黎书胜. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking/AFNetworking.h>
typedef NS_ENUM(NSUInteger, POST_TYPE) {
    POST_FORM = 1,
    POST_JSON,
    POST_MULTI_FORM,
    POST_XML
};

@interface HttpSessionBuilder : NSObject
-(instancetype)init;
-(AFHTTPSessionManager*)buildSession;

@property(assign,nonatomic) NSInteger timeoutInterval;
@property(assign,nonatomic) POST_TYPE postType;
@end
