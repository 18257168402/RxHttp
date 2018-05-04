//
//  HttpResponseUtil.m
//  guard
//
//  Created by 黎书胜 on 2017/11/1.
//  Copyright © 2017年 黎书胜. All rights reserved.
//

#import "HttpResponseUtil.h"

@implementation HttpResponseUtil
+(NSString*) responseToString:(id)responseObject{
   return  [[ NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
}
+(NSDictionary*) responseToDictionary:(id)responseObject{
    return [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
}
@end
