//
//  NSURL+KWUrlLoader.m
//  LoveMusic
//
//  Created by 许开伟 on 2017/12/24.
//  Copyright © 2017年 kevin xu. All rights reserved.
//

#import "NSURL+KWUrlLoader.h"

@implementation NSURL (KWUrlLoader)

- (NSURL *)customSchemeURL {
    NSURLComponents * components = [[NSURLComponents alloc] initWithURL:self resolvingAgainstBaseURL:NO];
    components.scheme = @"streaming";
    return [components URL];
}

- (NSURL *)originalSchemeURL {
    NSURLComponents * components = [[NSURLComponents alloc] initWithURL:self resolvingAgainstBaseURL:NO];
    components.scheme = @"http";
    return [components URL];
}

@end
