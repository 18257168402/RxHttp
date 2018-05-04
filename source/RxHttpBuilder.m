//
// Created by 黎书胜 on 2017/12/22.
// Copyright (c) 2017 黎书胜. All rights reserved.
//

#import "RxHttpBuilder.h"
#import "RxHttp.h"


@implementation RxHttpBuilder
@dynamic rx_addRequestHeader;
@dynamic rx_addResponseContentType;
@dynamic rx_setResponseContentType;
@dynamic rx_setResponseFacotry;
@dynamic rx_setOutTime;
@dynamic rx_interceptRequest;
@dynamic rx_interceptResponse;

-(instancetype)init{
    self = [super init];
    self.requestHeaders = [NSMutableDictionary new];
    self.acceptResponseContentTypes = [NSMutableArray new];
    return self;
}
-(RxHttpBuilder* (^)(NSString*,NSString* )) rx_addRequestHeader{
    return ^(NSString* key,NSString* value){
        self.requestHeaders[key] = value;
        return self;
    };
}
-(RxHttpBuilder* (^)(NSString*)) rx_addResponseContentType{
    return ^(NSString* type){
        [self.acceptResponseContentTypes addObject:type];
        return self;
    };
}
-(RxHttpBuilder* (^)(NSArray* types)) rx_setResponseContentType{
    return ^(NSArray* types){
        [self.acceptResponseContentTypes removeAllObjects];
        [self.acceptResponseContentTypes addObjectsFromArray:types];
        return self;
    };
}
-(RxHttpBuilder* (^)(id<IResponseObjectFactory> factory)) rx_setResponseFacotry{
    return ^(id<IResponseObjectFactory> factory){
        self.resCreator = factory;
        return self;
    };
}
-(RxHttpBuilder* (^)(NSTimeInterval outtime)) rx_setOutTime{
    return ^(NSTimeInterval interval){
        self.outtime = interval;
        return self;
    };
}
-(RxHttpBuilder* (^)(RxHttpRequestIntercept))rx_interceptRequest{
    return ^(RxHttpRequestIntercept intercept){
        self.reqIntercept = intercept;
        return self;
    };
}
-(RxHttpBuilder* (^)(RxHttpResponseIntercept))rx_interceptResponse{
    return ^(RxHttpResponseIntercept intercept){
        self.resIntercept = intercept;
        return self;
    };
}
//-(RxOC*(^)(void))rx_exec{
//    return ^(){
//        return [RxOC create:^(id<IRxEmitter> emit){
//            [emit onError:[[RxHttpException alloc] initWithCode:RXHTTPERR_NO_EXEC]];
//        }];
//    };
//}
@end


@implementation RxOpBuilder
@dynamic rx_setUrl;
@dynamic rx_setParams;
@dynamic rx_setResponseClass;
@dynamic rx_setResPicker;
-(instancetype)initWithRxHttp:(RxHttp*)rxHttp{
    self = [super init];
    self.rxHttp = rxHttp;
    [self.requestHeaders addEntriesFromDictionary:rxHttp.requestHeaders];
    [self.acceptResponseContentTypes addObjectsFromArray:rxHttp.acceptResponseContentTypes];
    self.reqIntercept = rxHttp.reqIntercept;
    self.resIntercept = rxHttp.resIntercept;
    self.isNeedCancelCommonTrans = NO;
    self.outtime = rxHttp.outtime;
    self.resCreator = rxHttp.resCreator;
    return self;
}
-(RxOpBuilder* (^)(NSString* url))rx_setUrl{
    return ^(NSString* url){
        self.tourl = url;
        return self;
    };
}
-(RxOpBuilder* (^)(id params))rx_setParams{
    return ^(NSDictionary* params){
        self.params = params;
        return self;
    };
}

-(RxOpBuilder* (^)(Class clazz))rx_setResponseClass{
    return ^(Class clazz){
        self.resClass = clazz;
        return self;
    };
}

-(RxOpBuilder* (^)(FuncPickResponseToRxOnNext clazz)) rx_setResPicker{
    return ^(FuncPickResponseToRxOnNext picker){
        self.resPicker  = picker;
        return self;
    };
}
-(RxOpBuilder* (^)())rx_cancelCommonTrans {
    return ^(){
        self.isNeedCancelCommonTrans  = YES;
        return self;
    };
}
//
-(NSDictionary*)buildUpParams{
    NSObject* param = ( NSObject*)self.params;
    NSDictionary* reqDict =param.mj_keyValues;
    return reqDict;
}
-(NSString*)buildUpUrl{
    if(self.tourl==nil || self.tourl.length==0){
        return @"";
    }
    NSString* temp = [self.tourl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([temp hasPrefix:@"http"]){
        return temp;
    }
    return [NSString stringWithFormat:@"%@%@",self.rxHttp.baseUrl,temp];
}
-(NSMutableURLRequest *)buildUpRequest:(NSString*)url params:(id)param{
    return nil;
}
-(void)ajustRequestHeaders{

}

-(void)dealResponseObject:(id)responseObject error:(NSError*)error emitter:(id<IRxEmitter>)emitter{
    if (error==nil) {
        id retobj = responseObject;
        if( self.resClass != nil && self.resCreator !=nil){//将responseObject转换成目标class的object
            retobj = [self.resCreator create:self.resClass response:responseObject];
        }
        NSException* pickexception = nil;
        if(self.resPicker!=nil){
            //结果挑选，也就是说可以通过这个过滤一些不需要的对象,这一步也可以使用,RxOC进行
            pickexception = self.resPicker(responseObject,retobj);
        }
        if(pickexception!=nil){
            [emitter onError:pickexception];
        }else{
            [emitter onNext:retobj];
            [emitter onComplete];
        }
    } else {
        //NSLog(@"===dataTaskWithRequest error:%@",error);
        [emitter onError:[[RxHttpException alloc] initWithCode:RXHTTPERR_NSERROR error:error]];
    }
}
+(AFHTTPSessionManager*)singleHttpSessionManager{
    static AFHTTPSessionManager* httpManager = nil;
    if(httpManager==nil){
        @synchronized (self) {
            httpManager = [AFHTTPSessionManager manager];
        }
    }
    return httpManager;
}

@dynamic rx_exec;
-(RxOC*(^)(void))rx_exec{
    return ^(void){
        RxOC* target = [RxOC create:^(id<IRxEmitter> emitter) {
            RxOpBuilder* obj = self;
            if(obj==nil){
                [emitter onError:[[RxHttpException alloc] initWithCode:RXHTTPERR_WEAK_RELEASED]];
                return ;
            }
            AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];

            //AFHTTPSessionManager* manager = [RxOpBuilder singleHttpSessionManager];
            //这里不用单例会内存泄露，因为manager与session是循环引用，但是用单例的话
            //responseSerializer又会让多个任务互相印象
            //可以看到AFURLSessionManager实现文件中，使用responseSerializer都是在NSUrlSession的回调中（以URLSession:开头的函数）
            AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.responseSerializer = responseSerializer;

            if(obj.acceptResponseContentTypes.count>0){
                manager.responseSerializer.acceptableContentTypes =[NSSet setWithArray:obj.acceptResponseContentTypes];
            }
            id reqDict =nil;
            if(self.params!=nil){
                if([self.params isKindOfClass:[NSString class]]){
                    NSString* paramStr = (NSString*)self.params;
                    if(!(paramStr==nil||paramStr
                            .length ==0)){
                        reqDict =[self buildUpParams];
                    }
                }else if([self.params isKindOfClass:[NSDictionary class]]){
                    NSDictionary* pD = self.params;
                    if(pD.allKeys.count>0){
                        reqDict =self.params;
                    }
                }else{
                    if(self.params!=nil){
                        reqDict =[self buildUpParams];
                    }
                }
            }

            NSString* url = [self buildUpUrl];
            //注意没有参数的时候reqDict一定要传入nil，不然在这里AFNetworking会产生错误
            NSMutableURLRequest *request =[self buildUpRequest:url params:reqDict];
            if(request == nil){
                [emitter onError:[[RxHttpException alloc] initWithCode:RXHTTPERR_NO_REQUEST]];
                return;
            }
            request.timeoutInterval= obj.outtime;//超时时间
            [self ajustRequestHeaders];
            NSArray * keys = [obj.requestHeaders allKeys];
            for (NSUInteger i = 0; i <keys.count; i ++) {
                id key = keys[i];
                id value = obj.requestHeaders[key];
                if(![key isEqualToString:HEADER_KEY_ContentType]){
                    RxLog(@"HeaderAdd %@ = %@",key,value);
                    [request addValue:value forHTTPHeaderField:key];
                    //在生成request的时候，
                    // 各个AFURLRequestSerialization都会加上相应的ContentType，重复加会导致某些服务器解析失败
                }
            }
            if(self.reqIntercept!=nil){
                self.reqIntercept(request);
            }
            RXWEAKDECLWITH(wsManager, manager)
            [[manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
                //NSLog(@"upload:%f",uploadProgress.fractionCompleted);
            } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
                //NSLog(@"download:%f",downloadProgress.fractionCompleted);
            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                        if(self.resIntercept!=nil){
                            self.resIntercept(response,responseObject,error);
                        }
                        [self dealResponseObject:responseObject error:error emitter:emitter];
                        [wsManager.session invalidateAndCancel];//这里必须取消NSURLSession因为有一个CFXURLCache _NSURLSessionLocal 引用循环
                        [wsManager setValue:nil forKey:@"session"];//这里也必须置空因为manager跟NSURLSession有引用循环
//                        [wsManager setValue:nil forKey:@"requestSerializer"];
//                        [wsManager setValue:nil forKey:@"responseSerializer"];
                    }] resume];
            //[emitter onError:[NSException exceptionWithName:@"aaa" reason:@"fdf" userInfo:nil]];
        }];
        if(self.rxHttp.commonCompose!=nil && !self.isNeedCancelCommonTrans){
//                    RxLog(@"=====commonCompose:%@ %d url:%@",
//                    self.rxHttp.commonCompose,
//                    self.isNeedCancelCommonTrans,
//                    self.tourl);
            target = target.compose(self.rxHttp.commonCompose);
        }
        return target;
    };
}
@end
