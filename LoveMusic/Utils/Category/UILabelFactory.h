//
//  UILabelFactory.h
//  LoveMusic
//
//  Created by kevin xu on 16/3/2.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabelFactory : UILabel

+ (UILabel *)autoLabelWithTextColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)textAlignment;

+ (UILabel *)autoLabelWithTextColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)textAlignment text:(NSString *)text;

@end
