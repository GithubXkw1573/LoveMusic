//
//  KWHttpEngine.h
//  LoveMusic
//
//  Created by kevin xu on 16/1/6.
//  Copyright © 2016年 kevin xu. All rights reserved.
//
typedef void (^SuccessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^FailureBlock)(NSURLSessionDataTask *task, NSError *error);

#import <Foundation/Foundation.h>

@interface KWHttpEngine : NSObject

+ (instancetype)sharedEngine;

- (instancetype)initWithBaseUrl:(NSString *)baseUrl;

- (void)startHttpGetRequestWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters callback:(void (^)(id, NSError *))block;


- (void)startHttpPostRequestWithUrl:(NSString *)urlString parmeters:(NSDictionary *)parmeters callback:(void (^)(id, NSError *))block;

@end
