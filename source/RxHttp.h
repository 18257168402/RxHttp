//
//  RxHttp.h
//  guard
//
//  Created by 黎书胜 on 2017/11/1.
//  Copyright © 2017年 黎书胜. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>
#import <Foundation/Foundation.h>
#import "RxOC.h"
#import "RxHttpDefs.h"
#import "RxHttpBuilder.h"
#import <MJExtension/MJExtension.h>


@interface RxHttp :RxHttpBuilder

-(instancetype) initWithBaseUrl:(NSString*)baseUrl;

@property (readonly, nonatomic) RxHttp* (^rx_addRequestHeader)(NSString* key,NSString* value);
@property (readonly, nonatomic) RxHttp* (^rx_addResponseContentType)(NSString* type) ;
@property (readonly, nonatomic) RxHttp* (^rx_setResponseContentType)(NSArray* types);
@property (readonly, nonatomic) RxHttp* (^rx_setResponseFacotry)(id<IResponseObjectFactory> factory) ;
@property (readonly, nonatomic) RxHttp* (^rx_setOutTime)(NSTimeInterval outtime);
@property (readonly, nonatomic) RxHttp* (^rx_setRequestContentType)(NSString* contentType);
@property (readonly, nonatomic) RxHttp* (^rx_setCommonComposeTrans)(RxComposeTrans trans);
@property (readonly, nonatomic) RxHttp* (^rx_interceptRequest)(RxHttpRequestIntercept intercept);
@property (readonly, nonatomic) RxHttp* (^rx_interceptResponse)(RxHttpResponseIntercept intercept);
@property (readonly,nonatomic) RxHttpGetBuilder* rx_getBuilder;
@property (readonly,nonatomic) RxHttpPutBuilder* rx_putBuilder;
@property (readonly,nonatomic) RxHttpPostBuilder* rx_postBuilder;
@property (readonly, nonatomic) RxHttpDeleteBuilder* rx_deleteBuilder;


@property (strong, nonatomic) RxComposeTrans commonCompose;
@property (readonly,nonatomic) NSString* baseUrl;

-(RxOC*) commonGetQuery:(NSString*)url params:(id)para resClazz:(Class)clazz;
-(RxOC*) commonPostQuery:(NSString*)url params:(id)para resClazz:(Class)clazz;
/**
 *multipart的文件数据要单独指定其mimeType等信息，因此这些不在params中传入，而是使用RxHttpMultiPartAssemble block组装
 */
-(RxOC*) commonMultiPartQuery:(NSString*)url params:(id)para resClazz:(Class)clazz assemble:(RxHttpMultiPartAssemble)assemble;
//-(RxOC*) commonMultiPartQuery:(NSString*)url params:(id)para
//                     resClazz:(Class)clazz assemble:(RxHttpMultiPartAssemble)assemble boundary:(NSString*)boundary;
-(RxOC*) commonPutQuery:(NSString*)url params:(id)para resClazz:(Class)clazz;
-(RxOC*) commonDeleteQuery:(NSString*)url params:(id)para resClazz:(Class)clazz;
@end
