//
//  NSString+KWFile.m
//  LoveMusic
//
//  Created by 许开伟 on 2017/12/29.
//  Copyright © 2017年 kevin xu. All rights reserved.
//

#import "NSString+KWFile.h"

@implementation NSString (KWFile)

//音频缓存路径
+ (NSString *)cacheFolderPath{
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"MusicCaches"];
}

//音频临时存放路径
+ (NSString *)tempFilePath{
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:@"MusicTmp"];
}

//获取网络资源的文件名称
+ (NSString *)fileNameWithURL:(NSURL *)url{
    NSArray *paths = [url.path componentsSeparatedByString:@"/"];
    if (paths.count) {
        return [paths lastObject];
    }else{
        return nil;
    }
}

@end
