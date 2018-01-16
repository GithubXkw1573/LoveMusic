//
//  KWDownloader.h
//  LoveMusic
//
//  Created by kevin xu on 16/3/12.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KWDownloadTask;
@interface KWDownloader : NSObject

/**
 *  @author kevin xu, 16-03-27 14:03:33
 *
 *  @brief 默认同时下载数为3
 *
 *  @since <#1.0#>
 */
@property (nonatomic, assign) NSInteger maximumActiveDownloads;//并发最大下载数

+ (instancetype)sharedownlader;

- (KWDownloadTask *)downloadFileWithUrlString:(NSURL *)url;

@end
