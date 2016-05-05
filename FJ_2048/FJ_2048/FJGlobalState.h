//
//  FJGlobalState.h
//  FJ_2048
//
//  Created by mzl_Jfang on 16/3/7.
//  Copyright © 2016年 mzl_Jfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FJPosition.h"

#define GSTATE [FJGlobalState state]
#define SETTING [NSUserDefaults standardUserDefaults]
#define NOTIF [NSNotificationCenter defaultCenter]

typedef NS_ENUM(NSInteger, FJGameType) {
    FJGameTypePowerOf2 = 0,
    FJGameTypePowerOf3 = 1,
    FJGameTypeFibonacci = 2
};

@interface FJGlobalState : NSObject

@property (nonatomic, assign, readonly) NSInteger dimension;//尺寸
@property (nonatomic, assign, readonly) NSInteger winningLevel;
@property (nonatomic, assign, readonly) NSInteger tileSize;
@property (nonatomic, assign, readonly) NSInteger borderWidth;
@property (nonatomic, assign, readonly) NSInteger cornerRadius;
@property (nonatomic, assign, readonly) NSInteger horizontalOffset;
@property (nonatomic, assign, readonly) NSInteger verticalOffset;
@property (nonatomic, assign, readonly) NSInteger animationDuration;
@property (nonatomic, assign, readonly) FJGameType gameType;

@property (nonatomic, assign) BOOL needRefresh;

/** The singleton instance of state. */
+ (FJGlobalState *)state;

/** Refreshes global state to reflect user choice. */
- (void)loadGlobalState;

/**
 * Whether the two levels can merge with each other to form another level.
 * This behavior is commutative.
 *
 * @param level1 The first level.
 * @param level2 The second level.
 * @return YES if the two levels are actionable with each other.
 */
- (BOOL)isLevel:(NSInteger)level1 mergeableWithLevel:(NSInteger)level2;

/**
 * The resulting level of merging the two incoming levels.
 *
 * @param level1 The first level.
 * @param level2 The second level.
 * @return The resulting level, or 0 if the two levels are not actionable.
 */
- (NSInteger)mergeLevel:(NSInteger)level1 withLevel:(NSInteger)level2;

/**
 * The numerical value of the specified level.
 *
 * @param level The level we are interested in.
 * @return The numerical value of the level.
 */
- (NSInteger)valueForLevel:(NSInteger)level;

/**
 * The background color of the specified level.
 *
 * @param level The level we are interested in.
 * @return The color of the level.
 */
- (UIColor *)colorForLevel:(NSInteger)level;

/**
 * The text color of the specified level.
 *
 * @param level The level we are interested in.
 * @return The color of the level.
 */
- (UIColor *)textColorForLevel:(NSInteger)level;

- (UIColor *)backgroundColor;

- (UIColor *)boardColor;

- (UIColor *)scoreBoardColor;

- (UIColor *)buttonColor;

- (NSString *)boldFontName;

- (NSString *)regularFontName;

/**
 * The text size of the specified value.
 *
 * @param value The value we are interested in.
 * @return The text size of the value.
 */
- (CGFloat)textSizeForValue:(NSInteger)value;

/**
 * The starting location of the position.
 *
 * @param position The position we are interested in.
 * @return The location in points, relative to the grid.
 */
- (CGPoint)locationOfPosition:(FJPosition)position;

/**
 * The starting x location of the position.
 *
 * @param position The position we are interested in.
 * @return The x location in points, relative to the grid.
 */
- (CGFloat)xLocationOfPosition:(FJPosition)position;

/**
 * The starting y location of the position.
 *
 * @param position The position we are interested in.
 * @return The y location in points, relative to the grid.
 */
- (CGFloat)yLocationOfPosition:(FJPosition)position;



@end
