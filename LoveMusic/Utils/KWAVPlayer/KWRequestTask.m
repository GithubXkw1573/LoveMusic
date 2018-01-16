//
//  KWRequestTask.m
//  LoveMusic
//
//  Created by 许开伟 on 2017/12/21.
//  Copyright © 2017年 kevin xu. All rights reserved.
//

#import "KWRequestTask.h"
#import "NSURL+KWUrlLoader.h"
#import "NSString+KWFile.h"

@interface KWRequestTask ()<NSURLSessionDataDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation KWRequestTask

- (instancetype)init {
    if (self = [super init]) {
        [KWFileHandler createTempFile];
    }
    return self;
}

- (void)start{
    NSMutableURLRequest *request =  [NSMutableURLRequest
                                     requestWithURL:[self.requestURL originalSchemeURL] cachePolicy:NSURLRequestReloadIgnoringCacheData
                                     timeoutInterval:RequestTimeout];
    //添加下载range请求头
    if (self.requestOffset > 0) {
        [request addValue:[NSString stringWithFormat:@"bytes=%ld-%ld",
                           self.requestOffset, self.fileLength - 1] forHTTPHeaderField:@"Range"];
    }
    self.session = [NSURLSession sessionWithConfiguration:
                    [NSURLSessionConfiguration defaultSessionConfiguration]
                                                 delegate:self
                                            delegateQueue:[NSOperationQueue mainQueue]];
    //建立任务
    self.task = [self.session dataTaskWithRequest:request];
    //开始任务
    [self.task resume];
}

- (void)setCancel:(BOOL)cancel {
    _cancel = cancel;
    [self.task cancel];
    [self.session invalidateAndCancel];
}

#pragma mark - NSURLSessionDataDelegate
//开始网络回应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(nonnull NSURLResponse *)response completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler{
    if (self.cancel) {
        return;
    }
    NSLog(@"response: %@",response);
    completionHandler(NSURLSessionResponseAllow);
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    //获取range
    NSString *contentRange = [[httpResponse allHeaderFields]
                              objectForKey:@"Content-Range"];
    NSString * fileLength = [[contentRange componentsSeparatedByString:@"/"]
                             lastObject];
    self.fileLength = fileLength.integerValue > 0 ? fileLength.integerValue : response.expectedContentLength;
    
    if ([self.delegate respondsToSelector:@selector(requestTaskDidReceviceResponse)]) {
        [self.delegate requestTaskDidReceviceResponse];
    }
}

//服务器返回数据 可能会调用多次
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    if (self.cancel) {
        return;
    }
    //数据写入临时文件
    [KWFileHandler writeTempFileData:data];
    //累计缓存长度
    self.cacheLength += data.length;
    
    if ([self.delegate respondsToSelector:@selector(requestTaskDidUpdateCache)]) {
        [self.delegate requestTaskDidUpdateCache];
    }
}

//请求完成会调用该方法，请求失败则error有值
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (self.cancel) {
        NSLog(@"下载取消");
    }else {
        if (error) {
            if ([self.delegate respondsToSelector:@selector(requestTaskDidFininshWithError:)]) {
                [self.delegate requestTaskDidFininshWithError:error];
            }
        }else {
            //可以缓存则保存文件
            if (self.cache) {
                //保存整首歌曲
                [KWFileHandler cacheTempFileWithFileName:[NSString fileNameWithURL:self.requestURL]];
            }
            if ([self.delegate respondsToSelector:@selector(requestTaskDidFinishLoadingWithCache:)]) {
                [self.delegate requestTaskDidFinishLoadingWithCache:self.cache];
            }
        }
    }
}
@end
