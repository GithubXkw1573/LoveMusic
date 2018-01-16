//
//  LMZAlbum.h
//  LoveMusic
//
//  Created by kevin xu on 16/3/2.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMZAlbum : NSObject<KWModelParserDelegate>
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *copywriter;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, assign) BOOL canDislike;
@property (nonatomic, copy) NSString *artistName;
@property (nonatomic, strong) NSArray *artists;
@property (nonatomic, copy) NSString *blurPicUrl;

@end
