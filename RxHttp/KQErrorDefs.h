//
// Created by 黎书胜 on 2017/12/21.
// Copyright (c) 2017 legendshop. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,KQErrIDS){
    ERRID_NSERROR = 1,
    ERRID_BIZ = 2,
    ERRID_DB = 3,
    ERRID_HTTP = 4,
    ERRID_SHOPNETWORK = 5,
    ERRID_UNKNOW,

};
typedef NS_ENUM(NSInteger,BIZ_ERRCODE) {
    BIZ_ERR_NOLOGIN = 1,//未登录
    BIZ_ERR_VERIFY_CHECKERR =2,//验证码错误
    BIZ_ERR_NOPROJ = 3,//没有项目
    BIZ_ERR_INVALID_ARG =4,//参数错误
    BIZ_ERR_GEO_ERROR,//地理编码解析错误
    BIZ_ERR_UNKNOW,
};
typedef NS_ENUM(NSInteger,HTTP_ERRCODE) {
    HTTP_ERR_JSONERR = 1,//json解析失败
};
