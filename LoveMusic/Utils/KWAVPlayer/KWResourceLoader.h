//
//  KWResourceLoader.h
//  LoveMusic
//
//  Created by 许开伟 on 2017/12/21.
//  Copyright © 2017年 kevin xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "KWRequestTask.h"

#define MimeType @"video/mp4"

@class KWResourceLoader;
@protocol KWResourceLoaderDelegate<NSObject>

@required
- (void)loader:(KWResourceLoader *)loader cacheProgress:(CGFloat)progress;

@optional
- (void)loader:(KWResourceLoader *)loader failLoadingWithError:(NSError *)error;

@end

@interface KWResourceLoader : NSObject<AVAssetResourceLoaderDelegate>
@property (nonatomic, weak) id<KWResourceLoaderDelegate> delegate;
@property (atomic, assign) BOOL seekRequired; //Seek标识
@property (nonatomic, assign) BOOL cacheFinished;

- (void)stopLoading;
@end
