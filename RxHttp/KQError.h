//
// Created by 黎书胜 on 2017/12/21.
// Copyright (c) 2017 legendshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KQErrorDefs.h"



@interface KQError : NSException
+(instancetype)makeErr:(KQErrIDS)errId code:(int)code;
+(instancetype)makeErr:(KQErrIDS)errId code:(int)code msg:(NSString*)msg;
+(instancetype)makeErr:(id)from;


@property (nonatomic, assign) KQErrIDS ID;//用以区分错误类型
@property (nonatomic, assign) NSInteger code;//错误id
@property (strong, nonatomic) NSString* msg;//描述信息
@property (strong, nonatomic) NSString* domain;//NSError的domain
@end