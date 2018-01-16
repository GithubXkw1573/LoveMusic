//
//  NSString+KWFile.h
//  LoveMusic
//
//  Created by 许开伟 on 2017/12/29.
//  Copyright © 2017年 kevin xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KWFile)

//音频缓存路径
+ (NSString *)cacheFolderPath;

//音频临时存放路径
+ (NSString *)tempFilePath;

//获取网络资源的文件名称
+ (NSString *)fileNameWithURL:(NSURL *)url;
@end
