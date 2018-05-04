//
// Created by 黎书胜 on 2017/12/21.
// Copyright (c) 2017 legendshop. All rights reserved.
//

#import "RxHttpErrDefs.h"
#import "KQError.h"

#define EXCEPTION_NAME @"KQError"
@implementation KQError {

}
+(instancetype)makeErr:(KQErrIDS)errId code:(int)code{

    return [self makeErr:errId code:code msg:@""];
}
+(instancetype)makeErr:(KQErrIDS)errId code:(int)code msg:(NSString*)msg{
    KQError* err = [[KQError alloc] initWithName:EXCEPTION_NAME reason:msg userInfo:nil];
    err.ID = errId;
    err.code = code;
    err.msg = msg;
    return err;
}
+(instancetype)MakeErrWithNSError:(NSError*)from{
    NSString* exceptionName = [NSString stringWithFormat:@"%@",from.domain];//domain就是域，用于区分不同模块的错误域
    KQError* err = [[KQError alloc] initWithName:exceptionName reason:from.localizedDescription userInfo:nil];
    err.ID = ERRID_NSERROR;
    err.code = (int)from.code ;
    err.msg = from.localizedDescription;
    err.domain = from.domain;
    return err;
}
+(instancetype)MakeErrWithException:(NSException*)from{
    KQError* err = [[KQError alloc] initWithName:from.name reason:from.reason userInfo:from.userInfo];
    err.ID = ERRID_UNKNOW;
    err.code = -1;
    err.msg = from.reason;
    return err;
}

+(instancetype)makeErr:(id)from{
    if([from isKindOfClass:[KQError class]]){
        return from;
    }
    if([from isKindOfClass:[NSError class]]){
        NSError* error = (NSError*)from;
        return [self MakeErrWithNSError:error];
    }else if([from isKindOfClass:[RxHttpException class]]){
        RxHttpException* e  =(RxHttpException*)from;
        if(e.code == RXHTTPERR_NSERROR){
            return [self MakeErrWithNSError:e.nserror];
        }else{
            return [self MakeErrWithException:e];
        }
    }else if([from isKindOfClass:[NSException class]]){//这个要放在最后判断
        return [self MakeErrWithException:from];
    }
    return [KQError makeErr:ERRID_UNKNOW code:-1];
}
-(NSString*)description{
    return [NSString stringWithFormat:@"KQError id:%d code:%d msg:%@ domain:%@",self.ID,self.code,self.msg,self.domain];
}
@end