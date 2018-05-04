//
//  RxHttpErrDefs.h
//  guard
//
//  Created by 黎书胜 on 2017/11/2.
//  Copyright © 2017年 黎书胜. All rights reserved.
//

#ifndef RxHttpErrDefs_h
#define RxHttpErrDefs_h
#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, RxHttpErrEnum){
    RXHTTPERR_WEAK_RELEASED = 1,
    RXHTTPERR_NSERROR      = 2,
    RXHTTPERR_NO_EXEC      = 3,
    RXHTTPERR_NO_REQUEST   = 4,
};

@interface RxHttpException:NSException
-(instancetype)initWithCode:(int)code;
-(instancetype)initWithCode:(int)code error:(NSError*) error;
@property (readonly,nonatomic)int code;
@property (readonly,strong,nonatomic)NSError* nserror;
@end

#endif /* RxHttpErrDefs_h */
