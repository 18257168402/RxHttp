//
//  ViewController.m
//  RxHttp
//
//  Created by 黎书胜 on 2018/5/4.
//  Copyright © 2018年 黎书胜. All rights reserved.
//

#import "ViewController.h"
#import "RxHttp.h"
#import "KQError.h"

@interface ViewController ()
{
    RxHttp* _client;
}
@end

@interface KQGDEmptyResult:NSObject
@property (assign, nonatomic) int code;//错误代码
@property (strong, nonatomic) NSString* msg;//错误信息
@end
@implementation KQGDEmptyResult
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
            @"code" : @"success",
            @"msg" : @"message"};
}
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self buildClient];

    UIButton* btn1 = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 100, 50)];
    btn1.backgroundColor = [UIColor grayColor];
    [btn1 setTitle:@"最简单post" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(onClickBtn1) forControlEvents:UIControlEventTouchUpInside];
}



#define KQGD_BASE_URL @"http://120.27.19.15:8080"
#define KQGD_API_VERIFYCHECK    @"/work/smsValidate"

-(void)onClickBtn1{
    NSDictionary * req = @{
            @"sjhm":@"1273222651261",
            @"code":@"12345"
    };
    [_client commonPostQuery:KQGD_API_VERIFYCHECK
                             params:req
                           resClazz:[KQGDEmptyResult class]]
            .compose(CommonIORxTrans)//线程中调用，主线程处理结果
            .subcribeTryErr(^(KQGDEmptyResult* result){
                NSLog(@">>>>>>post ret:%d",result.code);
            },^(NSException *e){
                NSLog(@">>>>>post err:%@",e.reason);
            });
}

-(void)buildClient{
    _client = [[RxHttp alloc] initWithBaseUrl:KQGD_BASE_URL]
            .rx_setOutTime(5)//统一设置超时时间
            .rx_setResponseFacotry([JsonResponseObjectFactory new])//统一设置返回数据的转化工厂类
            .rx_setRequestContentType(CONTENT_TYPE_FORM)//统一设置requestContentType为json,如果某个请求需要其他形式则单独设置
            .rx_addResponseContentType(CONTENT_TYPE_JSON)//统一添加接收数据类型
            .rx_addResponseContentType(CONTENT_TYPE_TEXT)
            .rx_addResponseContentType(CONTENT_TYPE_TEXT_JSON)
            .rx_addResponseContentType(CONTENT_TYPE_TEXT_HTML)
            .rx_addResponseContentType(CONTENT_TYPE_TEXT_js)
            .rx_setCommonComposeTrans([self CommonResultTrans])
            .rx_interceptRequest(^(NSMutableURLRequest *req){
                RxLogT(@"GCClient",@"req.url:%@ \n\r req.headers:%@ \n\r req.body:%@ req.bodyStream:%@"
                        ,req.URL.absoluteString,req.allHTTPHeaderFields,
                        [[ NSString alloc] initWithData:req.HTTPBody encoding:NSUTF8StringEncoding],req.HTTPBodyStream);
            })
            .rx_interceptResponse(^(NSURLResponse * response, id   responseObject, NSError *  error){
                RxLogT(@"GCClient",@"res.url:%@ \n\r res.response:%@  \n\r res.error:%@",
                        response.URL.absoluteString,
                        [[ NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding],error);
            });//统一设置执行RxOC的compose
}
-(RxComposeTrans)CommonResultTrans{
    return ^(RxOC * up){
        return [self commonResultTransToDown:up];
    };
}
-(RxOC *)commonResultTransToDown:(RxOC*)up{//对数据做统一处理
    return  up.map(^(id from){
        //EasyLog(@"commonResultTransToDown from class:%@ value:%@",[from class],from);
        if(from==nil){
            @throw [KQError makeErr:ERRID_HTTP code:HTTP_ERR_JSONERR];
        }
        id code_v = [from valueForKey:@"code"];
        if(code_v==nil){
            @throw [KQError makeErr:ERRID_HTTP code:HTTP_ERR_JSONERR];
        }
        NSString* msg  = [from valueForKey:@"msg"];
        NSInteger code = ((NSNumber *)code_v).boolValue?0:1234;//KQGDStatusTransToCode(((NSNumber *)code_v).boolValue,[msg trim]);

        if(code != 0){
            @throw [KQError makeErr:ERRID_SHOPNETWORK code:code msg:msg];
        }
        if(![from isKindOfClass:[KQGDEmptyResult class]]){
            id data =  [from valueForKey:@"data"];
            if(data == nil){
                @throw [KQError makeErr:ERRID_HTTP code:HTTP_ERR_JSONERR];
            }else{
                return data;
            }
        }
        return from;
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
