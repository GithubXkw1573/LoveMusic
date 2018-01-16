//
//  KWCycleLoadingView.m
//  LoveMusic
//
//  Created by 许开伟 on 16/4/25.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import "KWCycleLoadingView.h"

static CGFloat const kRadius1 = 30;
static CGFloat const kRadius2 = 18;
static CGFloat const kLineWidth = 4;
static CGFloat const kStepDuration = 3.0;

@interface ArcToCircleLayer : CALayer
@property (nonatomic) CGFloat progress;
@end

@implementation ArcToCircleLayer

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
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat radius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2 - kLineWidth / 2;
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // O
    CGFloat originStart = M_PI * 15 / 4;
    CGFloat originEnd = M_PI * 7 / 4;
    CGFloat currentOrigin = originStart - (originStart - originEnd) * self.progress;
    
    // D
    CGFloat destStart = M_PI * 2;
    CGFloat destEnd = 0;
    CGFloat currentDest = destStart - (destStart - destEnd) * self.progress;
    
    [path addArcWithCenter:center radius:radius startAngle:currentOrigin endAngle:currentDest clockwise:NO];
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetLineWidth(ctx, kLineWidth);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokePath(ctx);
}

@end

//顺时针layer
@interface DArcToCircleLayer : CALayer
@property (nonatomic) CGFloat progress;
@end

@implementation DArcToCircleLayer

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
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat radius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2 - kLineWidth / 2;
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // O
    CGFloat originStart = M_PI * 11 / 4;
    CGFloat originEnd = M_PI * 19 / 4;
    CGFloat currentOrigin = originStart - (originStart - originEnd) * self.progress;
    
    // D
    CGFloat destStart = M_PI * 5 / 2;
    CGFloat destEnd = M_PI * 9 / 2;
    CGFloat currentDest = destStart - (destStart - destEnd) * self.progress;
    
    [path addArcWithCenter:center radius:radius startAngle:currentOrigin endAngle:currentDest clockwise:YES];
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetLineWidth(ctx, kLineWidth);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokePath(ctx);
}

@end

@interface  KWCycleLoadingView ()
@property (nonatomic) ArcToCircleLayer *oneToCircleLayer;
@property (nonatomic) DArcToCircleLayer *twoToCircleLayer;
@end

@implementation KWCycleLoadingView

- (void)startAnimation {
    [self reset];
    [self doAnimate];
}

#pragma mark - animation
- (void)reset {
    [self.oneToCircleLayer removeFromSuperlayer];
    [self.twoToCircleLayer removeFromSuperlayer];
}

- (void)doAnimate {
    self.oneToCircleLayer = [ArcToCircleLayer layer];
    self.oneToCircleLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:self.oneToCircleLayer];
    
    
    
    self.twoToCircleLayer = [DArcToCircleLayer layer];
    self.twoToCircleLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:self.twoToCircleLayer];
    
    self.twoToCircleLayer.bounds = CGRectMake(0, 0, kRadius2 * 2 + kLineWidth, kRadius2 * 2 + kLineWidth);
    self.twoToCircleLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // animation
    self.twoToCircleLayer.progress = 1; // end status
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"progress"];
    animation1.duration = kStepDuration;
    animation1.fromValue = @0.0;
    animation1.toValue = @1.0;
    animation1.repeatCount = MAXFLOAT;
    [self.oneToCircleLayer addAnimation:animation1 forKey:nil];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"progress"];
    animation2.duration = kStepDuration;
    animation2.fromValue = @0.0;
    animation2.toValue = @1.0;
    animation2.repeatCount = MAXFLOAT;
    [self.twoToCircleLayer addAnimation:animation1 forKey:nil];
}




@end
