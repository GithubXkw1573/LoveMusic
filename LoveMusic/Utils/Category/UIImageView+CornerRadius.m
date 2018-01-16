//
//  UIImageView+CornerRadius.m
//  LoveMusic
//
//  Created by 许开伟 on 16/4/21.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import "UIImageView+CornerRadius.h"

#import "UIImage+CornerRadius.h"

@implementation UIImageView (CornerRadius)

- (void)addCornerRadius:(CGFloat)cornerRadius
{
    if (self) {
        self.image = [self.image imageCornerRadius:cornerRadius fitSize:CGSizeMake(30, 30)];
    }
}

@end
