//
//  FJTheme.h
//  FJ_2048
//
//  Created by mzl_Jfang on 16/3/7.
//  Copyright © 2016年 mzl_Jfang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FJTheme <NSObject>

+ (UIColor *)boardColor;

+ (UIColor *)backgroundColor;

+ (UIColor *)scoreBoardColor;

+ (UIColor *)buttonColor;

+ (NSString *)boldFontName;

+ (NSString *)regularFontName;

+ (UIColor *)colorForLevel:(NSInteger)level;

+ (UIColor *)textColorForLevel:(NSInteger)level;

@end

@interface FJTheme : NSObject

+ (Class)themeClassForType:(NSInteger)type;

@end
