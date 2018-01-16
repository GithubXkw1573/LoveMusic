//
//  KWFileHandler.m
//  LoveMusic
//
//  Created by 许开伟 on 2017/12/21.
//  Copyright © 2017年 kevin xu. All rights reserved.
//

#import "KWFileHandler.h"
#import "NSString+KWFile.h"

@implementation KWFileHandler

/**
 创建临时文件夹

 @return 是否创建成功
 */
+ (BOOL)createTempFile {
    NSFileManager * manager = [NSFileManager defaultManager];
    NSString * path = [NSString tempFilePath];
    if ([manager fileExistsAtPath:path]) {
        [manager removeItemAtPath:path error:nil];
    }
    return [manager createFileAtPath:path contents:nil attributes:nil];
}


/**
 往临时文件写数据（追加模式）

 @param data 要写入的数据
 */
+ (void)writeTempFileData:(NSData *)data {
    NSFileHandle * handle = [NSFileHandle fileHandleForWritingAtPath:[NSString tempFilePath]];
    [handle seekToEndOfFile];
    [handle writeData:data];
}


/**
 从临时文件里读取从offset开始length个字节数据

 @param offset 读取开始位置
 @param length 读取长度
 @return data  数据
 */
+ (NSData *)readTempFileDataWithOffset:(NSUInteger)offset length:(NSUInteger)length {
    NSFileHandle * handle = [NSFileHandle fileHandleForReadingAtPath:[NSString tempFilePath]];
    [handle seekToFileOffset:offset];
    return [handle readDataOfLength:length];
}


/**
 把临时文件数据同步到缓存文件里

 @param name 文件名
 */
+ (void)cacheTempFileWithFileName:(NSString *)name {
    NSFileManager * manager = [NSFileManager defaultManager];
    NSString * cacheFolderPath = [NSString cacheFolderPath];
    if (![manager fileExistsAtPath:cacheFolderPath]) {
        [manager createDirectoryAtPath:cacheFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString * cacheFilePath = [NSString stringWithFormat:@"%@/%@", cacheFolderPath, name];
    BOOL success = [[NSFileManager defaultManager] copyItemAtPath:[NSString tempFilePath] toPath:cacheFilePath error:nil];
    NSLog(@"cache file : %@", success ? @"success" : @"fail");
}

/**
 获取URL对应的缓存文件

 @param url 网络URL地址
 @return 返回URL对应的本地缓存文件，如果有，返回本地文件路径，如果没有，返回nil
 */
+ (NSString *)cacheFileExistsWithURL:(NSURL *)url{
    NSString *cacheFilePath = [NSString stringWithFormat:@"%@/%@",
                               [NSString cacheFolderPath],
                               [NSString fileNameWithURL:url]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFilePath]) {
        return cacheFilePath;
    }else{
        return nil;
    }
}


/**
 清除缓存

 @return 是否成功
 */
+ (BOOL)clearCache {
    NSFileManager * manager = [NSFileManager defaultManager];
    return [manager removeItemAtPath:[NSString cacheFolderPath] error:nil];
}
@end
