//
//  FJGrid.m
//  FJ_2048
//
//  Created by mzl_Jfang on 16/3/7.
//  Copyright © 2016年 mzl_Jfang. All rights reserved.
//

#import "FJGrid.h"
#import "FJCell.h"
#import "FJTile.h"
#import "FJScene.h"

@interface FJGrid ()

@property (nonatomic, assign, readwrite) NSInteger dimension;
@end

@implementation FJGrid {
    NSMutableArray *_grid;
}

- (instancetype)initWithDimension:(NSInteger)dimension {
    if (self = [super init]) {
        _grid = [[NSMutableArray alloc] initWithCapacity:dimension];
        
        for (NSInteger i = 0; i < dimension; i++) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:dimension];
            for (NSInteger j = 0; j < dimension; j++) {
                [array addObject:[[FJCell alloc] initWithPosition:FJPositionMake(i, j)]];
            }
            [_grid addObject:array];
        }
        self.dimension = dimension;
    }
    return self;
}

#pragma mark - iterator

- (void)forEach:(iteratorBlock)block reverseOrder:(BOOL)reverse {
    if (!reverse) {
        for (NSInteger i = 0; i < self.dimension; i++)
            for (NSInteger j = 0; j < self.dimension; j++)
                block(FJPositionMake(i, j));
    } else {
        for (NSInteger i = self.dimension -1; i >= 0 ; i--)
            for (NSInteger j = self.dimension - 1; j >= 0; j--)
                block(FJPositionMake(i, j));
    }
}

#pragma mark Position helpers

- (FJCell *)cellAtPosition:(FJPosition)position {
    if (position.x >= self.dimension || position.y >= self.dimension || position.x < 0 || position.y < 0)  return nil;
    
    return [[_grid objectAtIndex:position.x] objectAtIndex:position.y];
}

- (FJTile *)tileAtPosision:(FJPosition)position {
    FJCell *cell = [self cellAtPosition:position];
    return cell ? cell.tile : nil;
}

#pragma mark - cell availability

- (BOOL)hasAvailableCells {
    return [self availableCells].count != 0;
}

- (FJCell *)randomAvailableCell {
    NSArray *availableCells = [self availableCells];
    if (availableCells.count) {
        return [availableCells objectAtIndex:arc4random_uniform((int)availableCells.count)];
    }
    return nil;
}

- (NSArray *)availableCells {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.dimension * self.dimension];
    [self forEach:^(FJPosition position) {
        FJCell *cell = [self cellAtPosition:position];
        if (!cell.tile) {
            [array addObject:cell];
        }
    } reverseOrder:NO];
    return array;
}

#pragma mark - Cell manipulation

- (void)insertTileRandomAvailablePositionWithDelay:(BOOL)delay {
    FJCell *cell = [self randomAvailableCell];
    if (cell) {
        FJTile *tile = [FJTile inserNewTileToCell:cell];
        [self.scene addChild:tile];
        
        SKAction *delayAction = delay ? [SKAction waitForDuration:GSTATE.animationDuration * 3] : [SKAction waitForDuration:0];
        SKAction *move = [SKAction moveBy:CGVectorMake(- GSTATE.tileSize / 2, - GSTATE.tileSize / 2) duration:GSTATE.animationDuration];
        SKAction *scale = [SKAction scaleTo:1 duration:GSTATE.animationDuration];
        [tile runAction:[SKAction sequence:@[delayAction,[SKAction group:@[move,scale]]]]];
    }
}

- (void)removeAllTilesAnimated:(BOOL)animated {
    [self forEach:^(FJPosition position) {
        FJTile *tile = [self tileAtPosision:position];
        if (tile) {
            [tile removeAnimated:animated];
        }
    } reverseOrder:NO];
}

@end


