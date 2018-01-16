//
//  LMTrackDetailCoverCell.h
//  LoveMusic
//
//  Created by kevin xu on 16/3/10.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMSongTrack;
@interface LMTrackDetailCoverCell : UITableViewCell

- (void)bindModel:(LMSongTrack *)track;

@end
