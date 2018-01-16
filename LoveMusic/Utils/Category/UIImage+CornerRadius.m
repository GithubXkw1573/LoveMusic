//
//  UIImage+CornerRadius.m
//  LoveMusic
//
//  Created by 许开伟 on 16/4/20.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import "UIImage+CornerRadius.h"

@implementation UIImage (CornerRadius)

/**
 *  @author Kevin  Xu, 16-04-20 11:04:07
 *
 *  @brief 获取圆角图片
 *
 *  @param radius 圆角度
 *
 *  @return 返回圆角后的图片
 *
 *  @since <#1.0#>
 */
- (UIImage *)imageCornerRadius:(CGFloat)radius
{
    CGRect rect = CGRectMake(0.f, 0.f, self.size.width, self.size.height);
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageCornerRadius:(CGFloat)radius fitSize:(CGSize)fitSize
{
    CGRect rect = CGRectMake(0.f, 0.f, fitSize.width, fitSize.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawInRect:rect];
    CGContextDrawPath(UIGraphicsGetCurrentContext(),kCGPathFillStroke);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  @author Kevin  Xu, 16-04-20 11:04:14
 *
 *  @brief 返回一个带圆角度数的图片
 *
 *  @param name   图片名称
 *  @param radius 圆角度
 *
 *  @return 返回圆角后的图片
 *
 *  @since <#1.0#>
 */
+ (UIImage *)imageNamed:(NSString *)name withCornerRadius:(CGFloat)radius
{
    UIImage *image = [UIImage imageNamed:name];
    
    return [image imageCornerRadius:radius];
}

@end
