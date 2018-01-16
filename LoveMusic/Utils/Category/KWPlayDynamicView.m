//
//  KWPlayDynamicView.m
//  LoveMusic
//
//  Created by 许开伟 on 16/5/16.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import "KWPlayDynamicView.h"

@interface PlayDynacicLayer : CALayer
@property (nonatomic) CGFloat progress;
@end

@implementation PlayDynacicLayer

@dynamic progress;

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"progress"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);//线条颜色
    CGContextSetLineWidth(ctx, 1.5);
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGFloat degress = 4 * self.progress * (1 - self.progress);
    
    CGContextMoveToPoint(ctx, width/5,  height);
    CGContextAddLineToPoint(ctx, width/5,  0.6 * height - 0.4 * height * degress);
    
    CGContextMoveToPoint(ctx, 0.4 * width, height);
    CGContextAddLineToPoint(ctx, 0.4 * width,  0.2 * height + 0.4 * height * degress);
    
    CGContextMoveToPoint(ctx, 0.6 * width, height);
    CGContextAddLineToPoint(ctx, 0.6 * width,  0.5 * height - 0.4 * height * degress);
    
    CGContextMoveToPoint(ctx, 0.8 * width, height);
    CGContextAddLineToPoint(ctx, 0.8 * width,  0.3 * height + 0.4 * height * degress);
    
    CGContextDrawPath(ctx, kCGPathStroke); //绘制路径
}

@end


@interface  KWPlayDynamicView ()
@property (nonatomic, strong) PlayDynacicLayer *playDynacicLayer;
@end
@implementation KWPlayDynamicView

- (void)startAnimation {
    [self reset];
    [self showStopMode];
    [self addPlayMode];
}

- (void)stopAnimation{
    [self reset];
    [self showStopMode];
}

#pragma mark - animation
- (void)reset {
    [self.playDynacicLayer removeFromSuperlayer];
}

- (void)showStopMode{
    self.playDynacicLayer = [PlayDynacicLayer layer];
    self.playDynacicLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:self.playDynacicLayer];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    self.playDynacicLayer.bounds = CGRectMake(0.1 * width, 0.1 * height, 0.8 * width, 0.8 * height);
    self.playDynacicLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // animation
    self.playDynacicLayer.progress = 1; // end status
}

- (void)addPlayMode
{
    //动起来
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"progress"];
    animation1.duration = 0.8;
    animation1.fromValue = @0.0;
    animation1.toValue = @1.0;
    animation1.repeatCount = MAXFLOAT;
    [self.playDynacicLayer addAnimation:animation1 forKey:nil];
}

@end
