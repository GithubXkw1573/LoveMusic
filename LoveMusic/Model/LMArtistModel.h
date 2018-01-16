//
//  LMArtistModel.h
//  LoveMusic
//
//  Created by kevin xu on 16/3/8.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMArtistModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, strong) NSArray *alias;//[@"string"]：原唱歌手名
@property (nonatomic, assign) NSInteger albumSize;//专辑大小
@property (nonatomic, copy) NSString *briefDesc;//专辑描述
@end
