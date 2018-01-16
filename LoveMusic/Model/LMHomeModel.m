//
//  LMHomeModel.m
//  LoveMusic
//
//  Created by kevin xu on 16/3/2.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import "LMHomeModel.h"

@implementation LMHomeModel

+ (void)getHomeDataWithCompletedBlock:(void(^)(LMHomeModel *, NSError *))block
{
    dispatch_queue_t homeDataQueue = dispatch_queue_create("my.gethomedata.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(homeDataQueue, ^(){
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"batch" ofType:@""];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if (!error) {
            NSArray *result = [[json objectForKey:@"/api/personalized/playlist"] objectForKey:@"result"];
            NSArray *playList = [LMPlayList kw_ObjectWithKeyValueArray:result];
            LMHomeModel *homeModel = [LMHomeModel new];
            homeModel.playSheetList = playList;
            NSArray *albumResult = [[json objectForKey:@"/api/personalized/newalbum"] objectForKey:@"result"];
            NSArray *albumList = [LMZAlbum kw_ObjectWithKeyValueArray:albumResult];
            homeModel.albumList = albumList;
            NSInteger newalbumId = [[[[json objectForKey:@"/api/personalized/toplist"] objectForKey:@"topList"] objectForKey:@"id"] integerValue];
            homeModel.newTopListId = newalbumId;
            homeModel.hotTopListId = 3778678;
            homeModel.soarTopListId = 19723756;
            if (block) {
                block(homeModel, nil);
            }
        }else{
            if (block) {
                block(nil,error);
            }
        }
    });
}


@end
