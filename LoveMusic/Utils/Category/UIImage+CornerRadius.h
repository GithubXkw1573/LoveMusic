//
//  UIImage+CornerRadius.h
//  LoveMusic
//
//  Created by 许开伟 on 16/4/20.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CornerRadius)

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
- (UIImage *)imageCornerRadius:(CGFloat)radius;

- (UIImage *)imageCornerRadius:(CGFloat)radius fitSize:(CGSize)fitSize;

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
+ (UIImage *)imageNamed:(NSString *)name withCornerRadius:(CGFloat)radius;

@end
