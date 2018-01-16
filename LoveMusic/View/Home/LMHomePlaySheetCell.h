//
//  LMHomePlaySheetCell.h
//  LoveMusic
//
//  Created by kevin xu on 16/3/2.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

typedef NS_ENUM(NSInteger, CellContentType) {
    CellContentTypeSheet,//歌单
    CellContentTypeAlbum,//专辑
};

#import <UIKit/UIKit.h>
@class LMZAlbum,LMPlayList;
@interface LMHomePlaySheetCell : UICollectionViewCell

- (void)bindSheetModel:(LMPlayList *)sheet;
- (void)bindAlbumModel:(LMZAlbum *)album;
@end
