//
//  UILabelFactory.m
//  LoveMusic
//
//  Created by kevin xu on 16/3/2.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import "UILabelFactory.h"

@implementation UILabelFactory

/*!
 *  @author Kevin Xu, 2015-12-21 13:12
 *
 *  @brief purelayout 方式
 *
 *  @param textColor     <#textColor description#>
 *  @param font          <#font description#>
 *  @param textAlignment <#textAlignment description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
+ (UILabel *)autoLabelWithTextColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [UILabel newAutoLayoutView];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = textColor;
    label.font = font;
    label.textAlignment = textAlignment;
    
    return label;
}

+ (UILabel *)autoLabelWithTextColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)textAlignment text:(NSString *)text
{
    UILabel *label = [UILabel newAutoLayoutView];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = textColor;
    label.font = font;
    label.textAlignment = textAlignment;
    label.text = text;
    
    return label;
}

@end
