//
//  LMSongModel.m
//  LoveMusic
//
//  Created by kevin xu on 16/3/8.
//  Copyright © 2016年 kevin xu. All rights reserved.
//
NSString *const trackDetailUrl = @"http://music.163.com/api/playlist/detail";//歌单

#import "LMSongModel.h"

@implementation LMSongTrack

+ (NSDictionary *)kw_modelDictionary
{
    return @{@"tracks":@"LMSongModel"};
}

+ (void)getSongTrackByTrackId:(NSInteger)trackId withCompletedBlock:(void(^)(LMSongTrack *, NSError *))block{
    NSDictionary *parmeter = @{@"id":@(trackId)};
    [[KWHttpEngine sharedEngine] startHttpGetRequestWithUrl:trackDetailUrl parameters:parmeter callback:^(id responseObj, NSError *error){
        if (!error) {
            id result = [responseObj objectForKey:@"result"];
            LMSongTrack *track = [LMSongTrack kw_ObjectWithKeyValues:result];
            if (block) {
                block(track,nil);
            }
        }else{
            if (block) {
                block (nil, error);
            }
        }
        
        
    }];
}

@end

@implementation LMSongModel

+ (NSDictionary *)kw_modelDictionary
{
    return @{@"album":@"LMZAlbum",
             @"bMusic":@"LMMusic"};
}

@end
