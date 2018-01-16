//
//  KWDownloader.m
//  LoveMusic
//
//  Created by kevin xu on 16/3/12.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#define  kDocumentsDirectoryURL [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil]

#import "KWDownloader.h"

@interface KWDownloadTask : NSObject
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, strong) NSMutableData *resumeData;
@property (nonatomic, strong) NSURL *downloadFilePath;
@property (nonatomic, assign) int64_t totalBytesExpectedToWrite;
@property (nonatomic, assign) int64_t totalBytesWritten;
@property (nonatomic, assign) BOOL downloadCompleted;
@end

@implementation KWDownloadTask


@end

@interface KWDownloader ()
@property (nonatomic, strong) AFURLSessionManager *sessionManager;

@property (nonatomic, strong) NSMutableArray *downTaskList;
@property (nonatomic, strong) NSMutableDictionary *downTaskDic;

@property (nonatomic, strong) dispatch_queue_t synchronizationQueue;//互斥锁队列
@property (nonatomic, strong) dispatch_queue_t responseQueue;


@property (nonatomic, assign) NSInteger activeRequestCount;//当前下载中的个数
@end

@implementation KWDownloader

+ (instancetype)sharedownlader{
    static KWDownloader *downloader = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        downloader = [[self alloc] init];
    });
    return downloader;
}

+ (NSURLCache *)defaultURLCache {
    return [[NSURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024
                                         diskCapacity:150 * 1024 * 1024
                                             diskPath:@"com.xukaiwei.filedownloader"];
}

//默认下载路径
+ (NSURL *)defaultDownloadFilePathURL {
    return [kDocumentsDirectoryURL URLByAppendingPathComponent:@"FileDownloadPath"];
}

//默认session 配置
+ (NSURLSessionConfiguration *)defaultUrlSessionConfiguration{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    configuration.allowsCellularAccess = YES;
    configuration.timeoutIntervalForRequest = 60.0;
    configuration.URLCache = [KWDownloader defaultURLCache];
    
    return configuration;
}

- (instancetype)init{
    
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[self.class defaultUrlSessionConfiguration]];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];//返回二进制
    
    return [self initWithSessionManager:sessionManager
                  maxiumActiveDownloads:3];//默认并发下载数为3
}

- (instancetype)initWithSessionManager:(AFURLSessionManager *)sessionManager maxiumActiveDownloads:(NSInteger)maxDownLimit{
    if (self = [super init]) {
        self.sessionManager = sessionManager;
        self.maximumActiveDownloads = maxDownLimit;
        self.activeRequestCount = 0;
        
        self.downTaskList = [NSMutableArray array];
        self.downTaskDic = [NSMutableDictionary dictionary];
        
        NSString *name = [NSString stringWithFormat:@"com.xukaiwei.filedownloader.synchronizationqueue-%@", [[NSUUID UUID] UUIDString]];
        self.synchronizationQueue = dispatch_queue_create([name cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_SERIAL);
        
        name = [NSString stringWithFormat:@"com.xukaiwei.filedownloader.responsequeue-%@", [[NSUUID UUID] UUIDString]];
        self.responseQueue = dispatch_queue_create([name cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_CONCURRENT);
        
        //注册下载完成（包括失败）通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileDownloadComletedNotificationHandler:) name:AFNetworkingTaskDidCompleteNotification object:nil];
        
    }
    return self;
}

/**
 *  @author kevin xu, 16-03-24 16:03:26
 *
 *  @brief download with url
 *
 *  @param url <#url description#>
 *
 *  @since <#1.0#>
 */
- (KWDownloadTask *)downloadFileWithUrlString:(NSURL *)url
{
    NSString *identifier = url.absoluteString;
    
    KWDownloadTask *existTask = self.downTaskDic[identifier];
    
    //如果下载任务存在，直接返回
    if (existTask) {
        
        //如果存在未完成下载的请求，则从断点出继续下载
        if (existTask.resumeData && !existTask.downloadCompleted) {
            existTask.task = [self.sessionManager downloadTaskWithResumeData:existTask.resumeData progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response){
                NSURL *defaultPath = [self.class defaultDownloadFilePathURL];
                
                return [defaultPath URLByAppendingPathComponent:[response suggestedFilename]];
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error){
                NSLog(@"finished:%@",filePath.absoluteString);
                
                existTask.downloadFilePath = filePath;
                if (!error) {
                    existTask.downloadCompleted = YES;
                }
            }];
        }
        [existTask.task resume];
        
        return existTask;
    }
    
    //添加新任务
    KWDownloadTask *newTask = [KWDownloadTask new];
    newTask.identifier = identifier;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [self.sessionManager downloadTaskWithRequest:request
                                                                         progress:^(NSProgress *progress){
                                                                             NSLog(@"download progress:%@",@(progress.fractionCompleted));
                                                                         }
                                                                      destination:^NSURL *(NSURL *targetPath, NSURLResponse *response){
                                                                          NSURL *defaultPath = [self.class defaultDownloadFilePathURL];
                                                                          
                                                                          return [defaultPath URLByAppendingPathComponent:[response suggestedFilename]];
                                                                      }
                                                                completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error){
                                                                    NSLog(@"finished:%@",filePath.absoluteString);
                                                                    
                                                                    newTask.downloadFilePath = filePath;
                                                                    if (!error) {
                                                                        newTask.downloadCompleted = YES;
                                                                    }
                                                                }];
    newTask.task = task;
    
    self.downTaskDic[identifier] = newTask;
    
    //开启任务下载
    [task resume];
    
    return newTask;
    
    
    
//    [task cancelByProducingResumeData:^(NSData *resumeData){
//        
//    }];
//    
//    
//    
//    [self.sessionManager setDownloadTaskDidResumeBlock:^(NSURLSession *session, NSURLSessionDownloadTask *task, int64_t fileOffset, int64_t expectedTotalBytes){
//        NSLog(@"download resume:%@",@(fileOffset));
//    }];
////
//    [self.sessionManager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite){
//        NSLog(@"download percent:%@",@(totalBytesExpectedToWrite));
//    }];
////
//    
//    [self.sessionManager setTaskDidCompleteBlock:^(NSURLSession *session, NSURLSessionTask *downloadTask, NSError *error){
//        NSLog(@"download percent:%@",error.localizedDescription);
//    }];
}

- (BOOL)cancelDownloadUrl:(NSURL *)downloadUrl
{
    NSString *identifier = downloadUrl.absoluteString;
    
    KWDownloadTask *existTask = self.downTaskDic[identifier];
    
    if (existTask) {
        [existTask.task cancelByProducingResumeData:^(NSData *resumeData){
            existTask.resumeData = [NSMutableData dataWithData:resumeData];
        }];
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)paulseDownloadWithUrl:(NSURL *)downloadUrl
{
    NSString *identifier = downloadUrl.absoluteString;
    
    KWDownloadTask *existTask = self.downTaskDic[identifier];
    
    if (existTask) {
        [existTask.task suspend];
        return YES;
    }else{
        return NO;
    }
}

- (void)fileDownloadComletedNotificationHandler:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    id obj = [notification object];
    if ([obj isKindOfClass:[NSURLSessionTask class]]) {
        NSURLSessionTask *task = obj;
        KWDownloadTask *myTask = [self getEqualTask:task];
        if (myTask) {
            NSError *error = userInfo[AFNetworkingTaskDidCompleteErrorKey];
            NSURL *fileDownloadURL = userInfo[AFNetworkingTaskDidCompleteAssetPathKey];
            NSData *resumeData = userInfo[AFNetworkingTaskDidCompleteResponseDataKey];
            myTask.resumeData = [NSMutableData dataWithData:resumeData];;
            myTask.downloadFilePath = fileDownloadURL;
            if (error) {
                [myTask.task cancelByProducingResumeData:^(NSData *resumeData){
                    myTask.resumeData = [NSMutableData dataWithData:resumeData];
                }];
            }
        }
        
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (KWDownloadTask *)getEqualTask:(NSURLSessionTask *)task
{
    NSEnumerator *enumerator = [self.downTaskDic objectEnumerator];
    id key;
    KWDownloadTask *findTask = nil;
    
    while ((key = [enumerator nextObject]))
    {
        KWDownloadTask *downTask = key;
        if (downTask.task.taskIdentifier == task.taskIdentifier) {
            findTask = downTask;
            break;
        }
    }
    return findTask;
}

@end
