//
//  RxHttpPutBuilder.m
//  guard
//
//  Created by 黎书胜 on 2017/11/2.
//  Copyright © 2017年 黎书胜. All rights reserved.
//

#import "RxHttpBuilder.h"
#import "RxHttpDefs.h"
#import "RxHttp.h"
@implementation RxHttpPutBuilder

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


-(RxHttpPutBuilder* (^)(NSString* contentType)) rx_setRequestContentType{
    return ^(NSString* contenttype){
        self.requestHeaders[HEADER_KEY_ContentType] = contenttype;
        return self;
    };
}
-(NSMutableURLRequest *)buildUpRequest:(NSString*)url params:(id)param{
    NSMutableURLRequest *request =nil;
    NSString* requestContent = self.requestHeaders[HEADER_KEY_ContentType];
    if([requestContent isEqualToString:CONTENT_TYPE_JSON]){
        request =[[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:url parameters:param error:nil];
    }else if([requestContent isEqualToString:CONTENT_TYPE_FORM]){
        request =[[AFHTTPRequestSerializer serializer] requestWithMethod:@"PUT" URLString:url parameters:param error:nil];
    }
    return request;
}
@end
