//
//  LMHomeTopEntrenceCell.h
//  LoveMusic
//
//  Created by kevin xu on 16/3/3.
//  Copyright © 2016年 kevin xu. All rights reserved.
//
typedef NS_ENUM(NSInteger, TopListType) {
    TopListTypeNew,//最新
    TopListTypeHot,//热歌
    TopListTypeSoar,//飙升
};


#import <UIKit/UIKit.h>

@interface LMHomeTopEntrenceCell : UICollectionViewCell

- (void)bindTopType:(NSInteger)topType idValue:(NSInteger)idVlaue;

@end
