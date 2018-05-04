//
// Created by 黎书胜 on 2017/12/25.
// Copyright (c) 2017 黎书胜. All rights reserved.
//

#import "RxHttpBuilder.h"


@implementation RxHttpDeleteBuilder {

}
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
-(NSMutableURLRequest *)buildUpRequest:(NSString*)url params:(id)param{
    NSMutableURLRequest *request =[[AFHTTPRequestSerializer serializer] requestWithMethod:@"DELETE" URLString:url parameters:param error:nil];
    return request;
}
@end