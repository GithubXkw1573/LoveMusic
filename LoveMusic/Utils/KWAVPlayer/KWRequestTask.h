//
//  KWRequestTask.h
//  LoveMusic
//
//  Created by 许开伟 on 2017/12/21.
//  Copyright © 2017年 kevin xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWFileHandler.h"

#define RequestTimeout 10.0f

@protocol KWRequestTaskDelegate <NSObject>

@required
- (void)requestTaskDidUpdateCache;//更新缓冲进度代理方法

@optional
- (void)requestTaskDidReceviceResponse;
- (void)requestTaskDidFinishLoadingWithCache:(BOOL)cache;
- (void)requestTaskDidFininshWithError:(NSError *)error;

@end

@interface KWRequestTask : NSObject

@property (nonatomic, weak) id<KWRequestTaskDelegate> delegate;
@property (nonatomic, strong) NSURL *requestURL;
@property (nonatomic, assign) NSUInteger requestOffset;//请求起始位置
@property (nonatomic, assign) NSUInteger fileLength;//文件长度
@property (nonatomic, assign) NSUInteger cacheLength;//缓冲长度
@property (nonatomic, assign) BOOL cache;//是否缓存文件
@property (nonatomic, assign) BOOL cancel;//是否取消请求

/**
 *  开始请求
 */
- (void)start;

@end
