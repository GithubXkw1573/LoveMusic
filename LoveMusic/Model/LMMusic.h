//
//  LMMusic.h
//  LoveMusic
//
//  Created by kevin xu on 16/3/8.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMMusic : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger bitrate;
@property (nonatomic, copy) NSString *extension;
@property (nonatomic, copy) NSString *playTime;
@property (nonatomic, assign) CGFloat volumeDelta;
@end
