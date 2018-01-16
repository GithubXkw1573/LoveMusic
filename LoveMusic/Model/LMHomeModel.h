//
//  LMHomeModel.h
//  LoveMusic
//
//  Created by kevin xu on 16/3/2.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMPlayList.h"
#import "LMZAlbum.h"

@interface LMHomeModel : NSObject
@property (nonatomic, assign) NSInteger newTopListId;//新歌榜
@property (nonatomic, assign) NSInteger hotTopListId;//热歌榜
@property (nonatomic, assign) NSInteger soarTopListId;//飙升榜
@property (nonatomic, strong) NSArray<LMPlayList *> *playSheetList;
@property (nonatomic, strong) NSArray<LMZAlbum *> *albumList;

+ (void)getHomeDataWithCompletedBlock:(void(^)(LMHomeModel *, NSError *))block;
@end
