//
// Created by 黎书胜 on 2017/12/22.
// Copyright (c) 2017 黎书胜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "RxHttpDefs.h"
typedef void (^RxHttpRequestIntercept)(NSMutableURLRequest*);
typedef void (^RxHttpResponseIntercept)(NSURLResponse * response, id   responseObject, NSError *  error);

@protocol IResponseObjectFactory;
@class RxHttp;
@interface RxHttpBuilder : NSObject

@property (readonly, nonatomic) RxHttpBuilder* (^rx_addRequestHeader)(NSString* key,NSString* value);
@property (readonly, nonatomic) RxHttpBuilder* (^rx_addResponseContentType)(NSString* type) ;
@property (readonly, nonatomic) RxHttpBuilder* (^rx_setResponseContentType)(NSArray* types);
@property (readonly, nonatomic) RxHttpBuilder* (^rx_setResponseFacotry)(id<IResponseObjectFactory> factory) ;
@property (readonly, nonatomic) RxHttpBuilder* (^rx_setOutTime)(NSTimeInterval outtime);
@property (readonly, nonatomic) RxHttpBuilder* (^rx_interceptRequest)(RxHttpRequestIntercept intercept);
@property (readonly, nonatomic) RxHttpBuilder* (^rx_interceptResponse)(RxHttpResponseIntercept intercept);

@property (strong, nonatomic) RxHttpRequestIntercept reqIntercept;
@property (strong, nonatomic) RxHttpResponseIntercept resIntercept;
@property (assign,nonatomic) NSTimeInterval outtime;
@property (strong,nonatomic) NSMutableDictionary* requestHeaders;
@property (strong,nonatomic) NSMutableArray* acceptResponseContentTypes;
@property (strong,nonatomic) id<IResponseObjectFactory> resCreator;
@end

@interface RxOpBuilder:RxHttpBuilder
-(instancetype)initWithRxHttp:(RxHttp*)rxHttp;

@property (readonly, nonatomic) RxOpBuilder* (^rx_setUrl)(NSString* url);
@property (readonly, nonatomic) RxOpBuilder* (^rx_setParams)(id params);
@property (readonly, nonatomic) RxOpBuilder* (^rx_setResponseClass)(Class clazz);
@property (readonly, nonatomic) RxOpBuilder* (^rx_setResPicker)(FuncPickResponseToRxOnNext clazz);
@property (readonly, nonatomic) RxOpBuilder* (^rx_cancelCommonTrans)();
@property (strong,nonatomic) RxOC* (^rx_exec)(void);

@property (strong,nonatomic) RxHttp* rxHttp;
@property (strong,nonatomic) NSString* tourl;
@property (assign, nonatomic) BOOL isNeedCancelCommonTrans;
@property (strong,nonatomic) id params;
@property (strong,nonatomic) Class resClass;
@property (strong,nonatomic) FuncPickResponseToRxOnNext resPicker;

-(NSDictionary*)buildUpParams;
//AFNetWorking要讲参数转换为dictionary,request会在使用这个参数的时候转换为相应格式
//GET DELETE附加到url后面
//POST PUT会根据Content-Type: 转换后加到http body上。
-(NSString*)buildUpUrl;


//如果method是GET、HEAD、DELETE，那parameter将会被用来构建一个基于url编码的查询字符串（query url）
//，并且这个字符串会直接加到request的url后面。对于其他的Method，比如POST/PUT，它们会根
//        据parameterEncoding属性进行编码，而后加到request的http body上。
//@param method request的HTTP methodt，比如 `GET`, `POST`, `PUT`, or `DELETE`. 该参数不能为空
//@param URLString 用来创建request的URL
//@param parameters 既可以对method为GET的request设置一个查询字符串(query string)，也可以设置到request的HTTP body上
//@param error 构建request时发生的错误
//
//@return  一个NSMutableURLRequest的对象
-(NSMutableURLRequest *)buildUpRequest:(NSString*)url params:(id)param;//子类实现

-(void)ajustRequestHeaders;

-(void)dealResponseObject:(id)responseObject error:(NSError*)err emitter:(id<IRxEmitter>)emitter;
@end

@interface RxHttpGetBuilder:RxOpBuilder
@property (readonly, nonatomic) RxHttpGetBuilder* (^rx_addRequestHeader)(NSString* key,NSString* value);
@property (readonly, nonatomic) RxHttpGetBuilder* (^rx_addResponseContentType)(NSString* type) ;
@property (readonly, nonatomic) RxHttpGetBuilder* (^rx_setResponseContentType)(NSArray* types);
@property (readonly, nonatomic) RxHttpGetBuilder* (^rx_setResponseFacotry)(id<IResponseObjectFactory> factory) ;
@property (readonly, nonatomic) RxHttpGetBuilder* (^rx_setOutTime)(NSTimeInterval outtime);
@property (readonly, nonatomic) RxHttpGetBuilder* (^rx_interceptRequest)(RxHttpRequestIntercept intercept);
@property (readonly, nonatomic) RxHttpGetBuilder* (^rx_interceptResponse)(RxHttpResponseIntercept intercept);

@property (readonly, nonatomic) RxHttpGetBuilder* (^rx_setUrl)(NSString* url);
@property (readonly, nonatomic) RxHttpGetBuilder* (^rx_setParams)(id params);
@property (readonly, nonatomic) RxHttpGetBuilder* (^rx_setResponseClass)(Class clazz);
@property (readonly, nonatomic) RxHttpGetBuilder* (^rx_setResPicker)(FuncPickResponseToRxOnNext clazz);
@end

@interface RxHttpDeleteBuilder:RxOpBuilder
@property (readonly, nonatomic) RxHttpDeleteBuilder* (^rx_addRequestHeader)(NSString* key,NSString* value);
@property (readonly, nonatomic) RxHttpDeleteBuilder* (^rx_addResponseContentType)(NSString* type) ;
@property (readonly, nonatomic) RxHttpDeleteBuilder* (^rx_setResponseContentType)(NSArray* types);
@property (readonly, nonatomic) RxHttpDeleteBuilder* (^rx_setResponseFacotry)(id<IResponseObjectFactory> factory) ;
@property (readonly, nonatomic) RxHttpDeleteBuilder* (^rx_setOutTime)(NSTimeInterval outtime);
@property (readonly, nonatomic) RxHttpDeleteBuilder* (^rx_interceptRequest)(RxHttpRequestIntercept intercept);
@property (readonly, nonatomic) RxHttpDeleteBuilder* (^rx_interceptResponse)(RxHttpResponseIntercept intercept);

@property (readonly, nonatomic) RxHttpDeleteBuilder* (^rx_setUrl)(NSString* url);
@property (readonly, nonatomic) RxHttpDeleteBuilder* (^rx_setParams)(id params);
@property (readonly, nonatomic) RxHttpDeleteBuilder* (^rx_setResponseClass)(Class clazz);
@property (readonly, nonatomic) RxHttpDeleteBuilder* (^rx_setResPicker)(FuncPickResponseToRxOnNext clazz);
@end


/**
 * AFMultipartFormData 用于给multipart的body附加文件数据
 * 记住使用URL的时候要用[NSURL fileURLWithPath:req.projImg]接口
 * 还有指定正确的mimeType
 *
 * 附加额外的非文件数据使用接口
 * - (void)appendPartWithFormData:(NSData *)data
                          name:(NSString *)name;就好了,传入的param会自动用这个接口附加进去
 */
typedef void (^RxHttpMultiPartAssemble)(id <AFMultipartFormData> data,NSDictionary *params);

@interface RxHttpPostBuilder:RxOpBuilder
@property (readonly, nonatomic) RxHttpPostBuilder* (^rx_addRequestHeader)(NSString* key,NSString* value);
@property (readonly, nonatomic) RxHttpPostBuilder* (^rx_addResponseContentType)(NSString* type) ;
@property (readonly, nonatomic) RxHttpPostBuilder* (^rx_setResponseContentType)(NSArray* types);
@property (readonly, nonatomic) RxHttpPostBuilder* (^rx_setResponseFacotry)(id<IResponseObjectFactory> factory) ;
@property (readonly, nonatomic) RxHttpPostBuilder* (^rx_setOutTime)(NSTimeInterval outtime);
@property (readonly, nonatomic) RxHttpPostBuilder* (^rx_interceptRequest)(RxHttpRequestIntercept intercept);
@property (readonly, nonatomic) RxHttpPostBuilder* (^rx_interceptResponse)(RxHttpResponseIntercept intercept);

@property (readonly, nonatomic) RxHttpPostBuilder* (^rx_setUrl)(NSString* url);
@property (readonly, nonatomic) RxHttpPostBuilder* (^rx_setParams)(id params);
@property (readonly, nonatomic) RxHttpPostBuilder* (^rx_setResponseClass)(Class clazz);
@property (readonly, nonatomic) RxHttpPostBuilder* (^rx_setResPicker)(FuncPickResponseToRxOnNext clazz);
@property (readonly, nonatomic) RxHttpPostBuilder* (^rx_setRequestContentType)(NSString* contentType);

@property (readonly, nonatomic) RxHttpPostBuilder* (^rx_setMultiPartAssemble)(RxHttpMultiPartAssemble assemble);
@property (readonly, nonatomic) RxHttpPostBuilder* (^rx_setMultiPartBoundary)(NSString* boundary);

@property (strong,nonatomic) RxHttpMultiPartAssemble multiPartAssemble;
//@property (strong,nonatomic) NSString* boundary;
@end

@interface RxHttpPutBuilder:RxOpBuilder
@property (readonly, nonatomic) RxHttpPutBuilder* (^rx_addRequestHeader)(NSString* key,NSString* value);
@property (readonly, nonatomic) RxHttpPutBuilder* (^rx_addResponseContentType)(NSString* type) ;
@property (readonly, nonatomic) RxHttpPutBuilder* (^rx_setResponseContentType)(NSArray* types);
@property (readonly, nonatomic) RxHttpPutBuilder* (^rx_setResponseFacotry)(id<IResponseObjectFactory> factory) ;
@property (readonly, nonatomic) RxHttpPutBuilder* (^rx_setOutTime)(NSTimeInterval outtime);
@property (readonly, nonatomic) RxHttpPutBuilder* (^rx_interceptRequest)(RxHttpRequestIntercept intercept);
@property (readonly, nonatomic) RxHttpPutBuilder* (^rx_interceptResponse)(RxHttpResponseIntercept intercept);

@property (readonly, nonatomic) RxHttpPutBuilder* (^rx_setUrl)(NSString* url);
@property (readonly, nonatomic) RxHttpPutBuilder* (^rx_setParams)(id params);
@property (readonly, nonatomic) RxHttpPutBuilder* (^rx_setResponseClass)(Class clazz);
@property (readonly, nonatomic) RxHttpPutBuilder* (^rx_setResPicker)(FuncPickResponseToRxOnNext clazz);
@property (readonly, nonatomic) RxHttpPutBuilder* (^rx_setRequestContentType)(NSString* contentType);
@end
