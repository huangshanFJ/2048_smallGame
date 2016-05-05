//
//  FJGrid.h
//  FJ_2048
//
//  Created by mzl_Jfang on 16/3/7.
//  Copyright © 2016年 mzl_Jfang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FJScene,FJCell,FJTile;
typedef void (^iteratorBlock)(FJPosition position);
@interface FJGrid : NSObject

@property (nonatomic, assign ,readonly) NSInteger dimension;

@property (nonatomic, weak) FJScene *scene;

- (instancetype)initWithDimension:(NSInteger)dimension;

- (void)forEach:(iteratorBlock)block reverseOrder:(BOOL)reverse;

- (FJCell *)cellAtPosition:(FJPosition)position;

- (FJTile *)tileAtPosision:(FJPosition)position;

- (BOOL)hasAvailableCells;

- (void)insertTileRandomAvailablePositionWithDelay:(BOOL)delay;

- (void)removeAllTilesAnimated:(BOOL)animated;

@end
