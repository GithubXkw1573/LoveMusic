//
//  LMSongModel.h
//  LoveMusic
//
//  Created by kevin xu on 16/3/8.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LMSongModel;
@interface LMSongTrack : NSObject<KWModelParserDelegate>
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *discription;
@property (nonatomic, copy) NSString *coverImgUrl;
@property (nonatomic, assign) NSInteger playCount;
@property (nonatomic, assign) NSInteger trackCount;
@property (nonatomic, assign) NSInteger subscribedCount;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) NSInteger shareCount;
@property (nonatomic, assign) BOOL subscribed;
@property (nonatomic, strong) NSArray *tracks;//歌单列表

+ (void)getSongTrackByTrackId:(NSInteger)trackId withCompletedBlock:(void(^)(LMSongTrack *, NSError *))block;

@end

@class LMZAlbum,LMMusic;
@interface LMSongModel : NSObject<KWModelParserDelegate>

@property (nonatomic, copy) NSString *mp3Url;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger duration;//歌曲时长
@property (nonatomic, strong) NSArray *alias;//[@"string"]：原唱歌手名
@property (nonatomic, strong) LMZAlbum *album;//专辑
@property (nonatomic, assign) NSInteger fee;//费用 0标示免费
@property (nonatomic, strong) LMMusic *bMusic;//音频信息
@end
