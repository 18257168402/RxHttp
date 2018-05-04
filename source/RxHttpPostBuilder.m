//
//  RxHttpPostBuilder.m
//  guard
//
//  Created by 黎书胜 on 2017/11/1.
//  Copyright © 2017年 黎书胜. All rights reserved.
//

#import "RxHttpBuilder.h"
#import "RxHttp.h"
@implementation RxHttpPostBuilder
@dynamic rx_addRequestHeader;
@dynamic rx_addResponseContentType;
@dynamic rx_setResponseContentType;
@dynamic rx_setResponseFacotry;
@dynamic rx_setOutTime;
@dynamic rx_interceptRequest;
@dynamic rx_interceptResponse;
@dynamic rx_setUrl;
@dynamic rx_setParams;
@dynamic rx_setResponseClass;
@dynamic rx_setResPicker;
@dynamic rx_setMultiPartAssemble;
@dynamic rx_setMultiPartBoundary;

-(RxHttpPostBuilder* (^)(NSString*))rx_setMultiPartBoundary{
    return ^(NSString* boundary){
        //self.boundary = boundary;
        return self;
    };
}
-(RxHttpPostBuilder* (^)(RxHttpMultiPartAssemble))rx_setMultiPartAssemble{
    return ^(RxHttpMultiPartAssemble assemble){
        self.multiPartAssemble = assemble;
        return self;
    };
}
-(RxHttpPostBuilder* (^)(NSString* contentType)) rx_setRequestContentType{
    return ^(NSString* contenttype){
        self.requestHeaders[HEADER_KEY_ContentType] = contenttype;
        return self;
    };
}
-(void)ajustRequestHeaders{
//    NSString* requestContent = self.requestHeaders[HEADER_KEY_ContentType];
//    if([requestContent rangeOfString:CONTENT_TYPE_MULTI_FORM].location != NSNotFound){
//        if(![NSString isEmpty:self.boundary]){
//            self.requestHeaders[HEADER_KEY_ContentType] = [NSString stringWithFormat:@"%@;boundary=%@",requestContent,self.boundary];
//        }
//    }
}
-(instancetype)init{
    self = [super init];
    //self.boundary= @"Boundary+ABCDEF-RXHTTP";
    return self;
}
-(NSMutableURLRequest *)buildUpRequest:(NSString*)url params:(id)param{
    NSString* requestContent = self.requestHeaders[HEADER_KEY_ContentType];
    NSMutableURLRequest *request =nil;
    //EasyLog(@"buildUpRequest:%@",requestContent);
    if([requestContent rangeOfString:CONTENT_TYPE_JSON].location != NSNotFound){
        request =[[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:param error:nil];
    }else if([requestContent rangeOfString:CONTENT_TYPE_FORM].location != NSNotFound){
        request =[[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:param error:nil];
    }else if([requestContent rangeOfString:CONTENT_TYPE_MULTI_FORM].location != NSNotFound){

        /**
         * 如果要进行自定义boundary的话比较麻烦，但是也并不是不能做到
         * 可以看multipartFormRequestWithMethod的实现函数里面
         * AFStreamingMultipartFormData里面有个boundary属性，默认会生成一个随机的boundary
         * 这个boundary在我们给AFStreamingMultipartFormData调用各种append数据的时候使用
         * 因此，要做到改变boundary属性，首先param传入nil，然后在constructingBodyWithBlock回调的时候
         * 使用KVC的方式吧AFStreamingMultipartFormData的boundary改变，然后手动吧这些参数加进去
         * 同时，也要把Accept-Content这个header里面的boundary属性改变，就可以了
         */
        request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                             URLString:url
                                                                            parameters:param
                                                             constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
                                                                [self appendDataToFormData:formData params:param];
                                                             } error:nil];
    }
    return request;
}
-(void)appendDataToFormData:(id <AFMultipartFormData>)formData params:(id)param{
    if(self.multiPartAssemble){
        self.multiPartAssemble(formData,param);
    }
}
@end
