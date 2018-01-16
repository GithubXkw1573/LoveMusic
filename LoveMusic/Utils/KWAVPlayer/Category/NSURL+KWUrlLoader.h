//
//  NSURL+KWUrlLoader.h
//  LoveMusic
//
//  Created by 许开伟 on 2017/12/24.
//  Copyright © 2017年 kevin xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (KWUrlLoader)
//流文件格式
- (NSURL *)customSchemeURL;
//http格式
- (NSURL *)originalSchemeURL;
@end
