//
//  RxHttpGetBuilder.m
//  guard
//
//  Created by 黎书胜 on 2017/11/1.
//  Copyright © 2017年 黎书胜. All rights reserved.
//

#import "RxHttpBuilder.h"
@implementation RxHttpGetBuilder
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
    NSMutableURLRequest *request =[[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:url parameters:param error:nil];
    return request;
}
@end
