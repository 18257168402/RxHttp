//
//  HttpResponseUtil.h
//  guard
//
//  Created by 黎书胜 on 2017/11/1.
//  Copyright © 2017年 黎书胜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpResponseUtil : NSObject
+(NSString*) responseToString:(id)responseObject;
+(NSDictionary*) responseToDictionary:(id)responseObject;
@end
