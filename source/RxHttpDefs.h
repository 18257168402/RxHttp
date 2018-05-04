//
//  RxHttpDefs.h
//  guard
//
//  Created by 黎书胜 on 2017/11/1.
//  Copyright © 2017年 黎书胜. All rights reserved.
//

#ifndef RxHttpDefs_h
#define RxHttpDefs_h

#import <MJExtension/MJExtension.h>
#import "RxHttpErrDefs.h"
#import <RxOC/RxOCCommonDefs.h>
#import <RxOC/RxOC.h>
//#define RX_WEAK_DECL __weak typeof(self) weakself = self;
#define RX_WEAK_DECL typeof(self) weakself = self;

#define MAX_OUT_TIME 10

//Content-Type header很重要，他决定了post put方式的body参数的组织方式，
//Accept header则决定了接收数据的格式

#define CONTENT_TYPE_JSON       @"application/json" //默认方式 json
#define CONTENT_TYPE_FORM       @"application/x-www-form-urlencoded"//表单形式
#define CONTENT_TYPE_MULTI_FORM @"multipart/form-data" //需要在表单中进行文件上传时，就需要使用该格式
#define CONTENT_TYPE_APP_XML    @"application/xml"
#define CONTENT_TYPE_APP_PDF    @"application/pdf"
#define CONTENT_TYPE_APP_WORD   @"application/msword"
#define CONTENT_TYPE_APP_STREAM @"application/octet-stream"

#define CONTENT_TYPE_XML        @"text/xml"
#define CONTENT_TYPE_TEXT       @"text/plain"
#define CONTENT_TYPE_TEXT_JSON  @"text/json"
#define CONTENT_TYPE_TEXT_HTML  @"text/html" //html格式
#define CONTENT_TYPE_TEXT_js    @"text/javascript"
#define HEADER_KEY_ContentType  @"Content-Type"



@protocol IResponseObjectFactory
-(id)create:(Class)clazz response:(id)responseObject;
@end


//如果response数据有问题，是否需要通过onError返回，而不是onNext,如果要通过onError返回，那么需要提供onError的参数NSException否则返回nil
typedef NSException* (^FuncPickResponseToRxOnNext)(id responseObject,id resClassObj);


@interface JsonResponseObjectFactory:NSObject<IResponseObjectFactory>

@end


//@class RxHttpPostBuilder;
//@class RxHttpGetBuilder;
//@class RxHttpPutBuilder;
//@class RxHttp;
//
//typedef   RxHttp* (^FuncHttpAddHeader)(NSString* key,NSString* value);
//typedef   RxHttp* (^FuncHttpAddResponseAcceptContentType)(NSString* type);
//typedef   RxHttp* (^FuncHttpSetResponseAcceptContentType)(NSArray* types);
//typedef   RxHttp* (^FuncHttpSetResponseTransFactory)(id<IResponseObjectFactory> factory);
//typedef   RxHttp* (^FuncHttpTimeoutSet)(NSTimeInterval outtime);
//
//typedef   RxHttp* (^FuncHttpContentTypeSet)(NSString* contentType);
//typedef   RxOC* (^FuncHttpExec)(void);
//
//
//typedef  RxHttpGetBuilder* (^FuncHttpGetAddHeader)(NSString* key,NSString* value);
//typedef  RxHttpGetBuilder* (^FuncHttpGetAddResponseAcceptContentType)(NSString* type);
//typedef  RxHttpGetBuilder* (^FuncHttpGetSetResponseAcceptContentType)(NSArray* types);
//typedef  RxHttpGetBuilder* (^FuncHttpGetSetResponseTransFactory)(id<IResponseObjectFactory> factory);
//typedef  RxHttpGetBuilder* (^FuncHttpGetTimeoutSet)(NSTimeInterval outtime);
//
//typedef RxHttpGetBuilder* (^FuncHttpGetUrl)(NSString* url);
//typedef RxHttpGetBuilder* (^FuncHttpGetSetParam)(id params);
//typedef RxHttpGetBuilder* (^FuncHttpGetSetResponseClass)(Class clazz);
//typedef RxHttpGetBuilder* (^FuncHttpGetPickResultForRx)(FuncPickResponseToRxOnNext picker);
//
//typedef  RxHttpPostBuilder* (^FuncHttpPostAddHeader)(NSString* key,NSString* value);
//typedef  RxHttpPostBuilder* (^FuncHttpPostAddResponseAcceptContentType)(NSString* type);
//typedef  RxHttpPostBuilder* (^FuncHttpPostSetResponseAcceptContentType)(NSArray* types);
//typedef  RxHttpPostBuilder* (^FuncHttpPostSetResponseTransFactory)(id<IResponseObjectFactory> factory);
//typedef  RxHttpPostBuilder* (^FuncHttpPostTimeoutSet)(NSTimeInterval outtime);
//
//typedef RxHttpPostBuilder* (^FuncHttpPostContentTypeSet)(NSString* contentType);
//
//typedef RxHttpPostBuilder* (^FuncHttpPostUrl)(NSString* url);
//typedef RxHttpPostBuilder* (^FuncHttpPostSetParam)(id params);
//typedef RxHttpPostBuilder* (^FuncHttpPostSetResponseClass)(Class clazz);
//typedef RxHttpPostBuilder* (^FuncHttpPostPickResultForRx)(FuncPickResponseToRxOnNext picker);
//
//typedef  RxHttpPutBuilder* (^FuncHttpPutAddHeader)(NSString* key,NSString* value);
//typedef  RxHttpPutBuilder* (^FuncHttpPutAddResponseAcceptContentType)(NSString* type);
//typedef  RxHttpPutBuilder* (^FuncHttpPutSetResponseAcceptContentType)(NSArray* types);
//typedef  RxHttpPutBuilder* (^FuncHttpPutSetResponseTransFactory)(id<IResponseObjectFactory> factory);
//typedef  RxHttpPutBuilder* (^FuncHttpPutTimeoutSet)(NSTimeInterval outtime);
//typedef RxHttpPutBuilder* (^FuncHttpPutContentTypeSet)(NSString* contentType);
//typedef RxHttpPutBuilder* (^FuncHttpPutUrl)(NSString* url);
//typedef RxHttpPutBuilder* (^FuncHttpPutSetParam)(id params);
//typedef RxHttpPutBuilder* (^FuncHttpPutSetResponseClass)(Class clazz);
//typedef RxHttpPutBuilder* (^FuncHttpPutPickResultForRx)(FuncPickResponseToRxOnNext picker);

#endif /* RxHttpDefs_h */
