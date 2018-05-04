//
//  RxHttp.m
//  guard
//
//  Created by 黎书胜 on 2017/11/1.
//  Copyright © 2017年 黎书胜. All rights reserved.
//

#import "RxHttp.h"


@implementation RxHttpException
-(instancetype)initWithCode:(int)code{
    NSString* reson=[NSString stringWithFormat:@"exception with code:%d",code];
    self = [super initWithName:@"RxHttpException" reason:reson userInfo:nil];
    self->_code = code;
    return self;
}
-(instancetype)initWithCode:(int)code error:(NSError*) error{
    self = [super initWithName:@"RxHttpException" reason:error.localizedDescription userInfo:error.userInfo];
    self->_code = code;
    self->_nserror = error;
    return self;
}
@end
@implementation JsonResponseObjectFactory
-(id)create:(Class)clazz response:(id)responseObject{
    return (id)[clazz mj_objectWithKeyValues:responseObject];
}
@end

@implementation RxHttp
@dynamic rx_addRequestHeader;
@dynamic rx_addResponseContentType;
@dynamic rx_setResponseContentType;
@dynamic rx_setResponseFacotry;
@dynamic rx_setOutTime;
@dynamic rx_interceptRequest;
@dynamic rx_interceptResponse;
-(instancetype) initWithBaseUrl:(NSString*)baseUrl{
    self = [super init];
    self->_baseUrl= baseUrl;
    self.requestHeaders = [NSMutableDictionary new];
    self.acceptResponseContentTypes = [NSMutableArray new];
    
    self.outtime = MAX_OUT_TIME;
    self.resCreator = [JsonResponseObjectFactory new];
    self.rx_setRequestContentType(CONTENT_TYPE_JSON);
    return self;
}
@dynamic rx_getBuilder;
-(RxHttpGetBuilder*) rx_getBuilder{
    RxHttpGetBuilder *builder= [[RxHttpGetBuilder alloc] initWithRxHttp:self];
    return builder;
}
@dynamic rx_putBuilder;
-(RxHttpPutBuilder*) rx_putBuilder{
    RxHttpPutBuilder *builder= [[RxHttpPutBuilder alloc] initWithRxHttp:self];
    return builder;
}
@dynamic rx_postBuilder;
-(RxHttpPostBuilder*) rx_postBuilder{
    RxHttpPostBuilder* builder = [[RxHttpPostBuilder alloc] initWithRxHttp:self];
    return builder;
}
@dynamic rx_deleteBuilder;
-(RxHttpDeleteBuilder*)rx_deleteBuilder{
    RxHttpDeleteBuilder* builder = [[RxHttpDeleteBuilder alloc] initWithRxHttp:self];
    return builder;
}
@dynamic rx_setRequestContentType;
-(RxHttp* (^)(NSString*)) rx_setRequestContentType{
    return ^(NSString* contenttype){
       self.requestHeaders[HEADER_KEY_ContentType] = contenttype;
        return self;
    };
}
@dynamic rx_setCommonComposeTrans;
-(RxHttp* (^)(RxComposeTrans trans))rx_setCommonComposeTrans{
    return ^(RxComposeTrans trans){
        self.commonCompose = trans;
        return self;
    };
}

-(RxOC*) commonGetQuery:(NSString*)url params:(id)para resClazz:(Class)clazz{
    return [self rx_getBuilder].rx_setUrl(url)
            .rx_setParams(para)//参数，使用dict或者object,如果传入一个NSObject对象，那么，将自动使用mj_extension转换为dict形式
            .rx_setResponseClass(clazz)//设置返回对象的类类型
            .rx_exec();
}
-(RxOC*) commonPostQuery:(NSString*)url params:(id)para resClazz:(Class)clazz{
    return [self rx_postBuilder].rx_setUrl(url)
            .rx_setParams(para)//参数，使用dict或者object,如果传入一个NSObject对象，那么，将自动使用mj_extension转换为dict形式
            .rx_setResponseClass(clazz)//设置返回对象的类类型
            .rx_exec();
}
-(RxOC*) commonMultiPartQuery:(NSString*)url params:(id)para resClazz:(Class)clazz assemble:(RxHttpMultiPartAssemble)assemble{
    return [self rx_postBuilder].rx_setUrl(url)
            .rx_setParams(para)
            .rx_setOutTime(15)
            .rx_setResponseClass(clazz)
            .rx_setRequestContentType(CONTENT_TYPE_MULTI_FORM)
            .rx_setMultiPartAssemble(assemble)
            .rx_exec();
}
-(RxOC*) commonMultiPartQuery:(NSString*)url params:(id)para
                     resClazz:(Class)clazz assemble:(RxHttpMultiPartAssemble)assemble boundary:(NSString*)boundary{
    return [self rx_postBuilder].rx_setUrl(url)
            .rx_setParams(para)
            .rx_setOutTime(15)
            .rx_setResponseClass(clazz)
            .rx_setRequestContentType(CONTENT_TYPE_MULTI_FORM)
            .rx_setMultiPartAssemble(assemble)
            .rx_setMultiPartBoundary(boundary)
            .rx_exec();
}
-(RxOC*) commonPutQuery:(NSString*)url params:(id)para resClazz:(Class)clazz{
    return [self rx_putBuilder].rx_setUrl(url)
            .rx_setParams(para)//参数，使用dict或者object,如果传入一个NSObject对象，那么，将自动使用mj_extension转换为dict形式
            .rx_setResponseClass(clazz)//设置返回对象的类类型
            .rx_exec();
}
-(RxOC*) commonDeleteQuery:(NSString*)url params:(id)para resClazz:(Class)clazz{
    return [self rx_deleteBuilder].rx_setUrl(url)
            .rx_setParams(para)//参数，使用dict或者object,如果传入一个NSObject对象，那么，将自动使用mj_extension转换为dict形式
            .rx_setResponseClass(clazz)//设置返回对象的类类型
            .rx_exec();
}

@end
