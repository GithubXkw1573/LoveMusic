//
//  KWHttpEngine.m
//  LoveMusic
//
//  Created by kevin xu on 16/1/6.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import "KWHttpEngine.h"

#import <AFNetworking.h>

@interface KWHttpEngine ()
{
    AFHTTPSessionManager *sessionManager;
}
@end

@implementation KWHttpEngine

static KWHttpEngine *shareEngine;

+ (instancetype)sharedEngine
{
    if (!shareEngine) {
        @synchronized (self) {
            shareEngine = [[KWHttpEngine alloc] init];
        }
    }
    return shareEngine;
}

- (instancetype)initWithBaseUrl:(NSString *)baseUrl{
    if (self = [super init]) {
        sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        sessionManager = [AFHTTPSessionManager manager];
    }
    return self;
}


/*!
 *  @author Kevin Xu, 2016-02-16 14:02
 *
 *  @brief Get
 *
 *  @param urlString url
 *  @param parmeters parmeters
 *  @param block     callback
 *
 *  @since 1.0.0
 */
- (void)startHttpGetRequestWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters callback:(void (^)(id, NSError *))block
{
    [sessionManager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id respoonseObject){
        if (block) {
            block(respoonseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"http request error:-------errorCode:%@------errorReason:%@",@(error.code),
              error.localizedDescription);
        if (block) {
            block(nil, error);
        }
    }];
}


/*!
 *  @author Kevin Xu, 2016-02-16 14:02
 *
 *  @brief Post
 *
 *  @param urlString url
 *  @param parmeters parmeters
 *  @param block     callback
 *
 *  @since 1.0.0
 */
- (void)startHttpPostRequestWithUrl:(NSString *)urlString parmeters:(NSDictionary *)parmeters callback:(void (^)(id, NSError *))block
{
    [sessionManager POST:urlString parameters:parmeters progress:nil success:^(NSURLSessionDataTask *task, id respoonseObject){
        if (block) {
            block(respoonseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"http request error:-------errorCode:%@------errorReason:%@",@(error.code),
              error.localizedDescription);
        if (block) {
            block(nil, error);
        }
    }];
}

@end
