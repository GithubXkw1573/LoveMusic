//
//  PrintObject.h
//  LoveMusic
//
//  Created by kevin xu on 16/1/8.
//  Copyright © 2016年 kevin xu. All rights reserved.
//

#import "PrintObject.h"
#import <objc/runtime.h>
#define PRINT_OBJ_LOGGING 1

@implementation PrintObject

+ (NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++) {
        objc_property_t prop = props[i];
        id value = nil;
        
        @try {
            NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
            if (![self isExculdedProperty:propName]) {
                value = [self getObjectInternal:[obj valueForKey:propName]];
                if(value != nil) {
                    [dic setObject:value forKey:propName];
                }
            }
            
        }
        @catch (NSException *exception) {
            [self logError:exception];
        }
        
    }
    free(props);
    return dic;
}

+ (void)print:(id)obj
{
    NSLog(@"%@", [self getObjectData:obj]);
}

+ (NSArray *)excludePropertys
{
    return @[@"superclass",@"description",@"hash",@"debugDescription"];
}

+ (BOOL)isExculdedProperty:(NSString *)propName
{
    for(NSString *key in [self excludePropertys]){
        if ([key isEqualToString:propName]) {
            return YES;
            break;
        }
    }
    return NO;
}

+ (NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error
{
    return [NSJSONSerialization dataWithJSONObject:[self getObjectData:obj] options:options error:error];
}

+ (id)getObjectInternal:(id)obj
{
    if(!obj
       || [obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]]
       || [obj isKindOfClass:[NSValue class]]) {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]]) {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++) {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys) {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}

+ (void)logError:(NSException*)exp
{
#if PRINT_OBJ_LOGGING
    NSLog(@"PrintObject Error: %@", exp);
#endif
}

@end
