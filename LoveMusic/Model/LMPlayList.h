//
//  LMPlayList.h
//  LoveMusic
//
//  Created by kevin xu on 16/3/2.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMPlayList : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *copywriter;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, assign) BOOL canDislike;
@property (nonatomic, assign) CGFloat playCount;
@property (nonatomic, assign) BOOL highQuality;
@property (nonatomic, assign) NSInteger trackCount;

@end
