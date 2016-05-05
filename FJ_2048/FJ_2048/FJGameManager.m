//
//  FJGameManager.m
//  FJ_2048
//
//  Created by 方健 on 16/3/7.
//  Copyright © 2016年 mzl_Jfang. All rights reserved.
//

#import "FJGameManager.h"
#import "FJTile.h"
#import "FJGrid.h"
#import "FJScene.h"
#import "FJMainViewController.h"

BOOL iterate(NSInteger value, BOOL countUp, NSInteger upper, NSInteger lower) {
    return countUp ? value < upper : value > lower;
}

@implementation FJGameManager {

    BOOL _over;
    BOOL _won;
    BOOL _keepPlaaying;
    NSInteger _score;
    NSInteger _pendingScore;
    FJGrid *_grid;
    CADisplayLink *_addTileDisplayLink;
}

#pragma mark _setUp 

- (void)startNewSeeeionWithScene:(FJScene *)scene {
    if (_grid) [_grid removeAllTilesAnimated:NO];
    if (! _grid || _grid.dimension != GSTATE.dimension) {
        _grid = [[FJGrid alloc] initWithDimension:GSTATE.dimension];
        _grid.scene = scene;
    }
    [scene loadBoardWithGrid:_grid];
    _score = 0; _over = NO ; _won = NO ; _keepPlaaying = NO;
    
    _addTileDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(addTwoRandomTiles)];
    [_addTileDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)addTwoRandomTiles {
    if (_grid.scene.children.count <= 1) {
        [_grid insertTileRandomAvailablePositionWithDelay:NO];
        [_grid insertTileRandomAvailablePositionWithDelay:NO];
        [_addTileDisplayLink invalidate];
    }
}

#pragma mark - Actions

- (void)moveToDirection:(FJDirection)direction {
    __block FJTile *tile = nil;
    
    BOOL reverse = direction == FJDirectionUp || direction == FJDirectionRight;
    NSInteger unit = reverse ? 1 : -1;
    
    if (direction == FJDirectionUp || direction == FJDirectionDown) {
        [_grid forEach:^(FJPosition position) {
            if ((tile = [_grid tileAtPosision:position])) {
                NSInteger target = position.x;
                for (NSInteger i = position.x + unit; iterate(i, reverse, _grid.dimension, -1); i += unit) {
                    FJTile *t = [_grid tileAtPosision:FJPositionMake(i, position.y)];
                    if (!t) target = i;
                    
                    else {
                        NSInteger level = 0;
                        if (GSTATE.gameType == FJGameTypePowerOf3) {
                            FJPosition further = FJPositionMake(i + unit, position.y);
                            FJTile *ft = [_grid tileAtPosision:further];
                            if (ft) {
                                level = [tile merge3ToTile:t andTile:ft];
                            }
                        } else {
                            level = [tile mergeToTile:t];
                        }
                        
                        if (level) {
                            target = position.x;
                            _pendingScore = [GSTATE valueForLevel:level];
                        }
                        break;
                        
                    }
                }
                if (target != position.x) {
                    [tile moveToCell:[_grid cellAtPosition:FJPositionMake(target, position.y)]];
                    _pendingScore ++;
                }
            }
        } reverseOrder:reverse];
    }
    else {
        [_grid forEach:^(FJPosition position) {
            if ((tile = [_grid tileAtPosision:position])) {
                NSInteger targer = position.y;
                for (NSInteger i = position.y + unit; iterate(i, reverse, _grid.dimension, -1); i += unit) {
                    FJTile *t = [_grid tileAtPosision:FJPositionMake(position.x, i)];
                    
                    if (!t) {
                        targer = i;
                    }
                    else {
                        NSInteger level = 0 ;
                        if (GSTATE.gameType == FJGameTypePowerOf3) {
                            FJPosition futher = FJPositionMake(position.x, i + unit);
                            FJTile *ft = [_grid tileAtPosision:futher];
                            if (ft) {
                                level = [tile merge3ToTile:t andTile:ft];
                            }
                        } else {
                            level = [tile mergeToTile:t];
                        }
                        
                        if (level) {
                            targer = position.y;
                            _pendingScore = [GSTATE valueForLevel:level];
                        }
                        break;
                    }
                }
                
                if (targer != position.y) {
                    [tile moveToCell:[_grid cellAtPosition:FJPositionMake(position.x, targer)]];
                    _pendingScore ++;
                }
            }
        } reverseOrder:reverse];
    }
    
    if (!_pendingScore) return;
    [_grid forEach:^(FJPosition position) {
        FJTile *tile = [_grid tileAtPosision:position];
        if (tile) {
            [tile commitPendingActions];
            if (tile.level >= GSTATE.winningLevel) _won = YES;
        }
    } reverseOrder:reverse];
    
    [self materializePendingScore];
    
    if (!_keepPlaaying && _won) {
        _keepPlaaying = YES;
        [_grid.scene.viewController endGame:YES];
    }
    
    [_grid insertTileRandomAvailablePositionWithDelay:YES];
    if (GSTATE.dimension == 5 && GSTATE.gameType == FJGameTypePowerOf2) {
        [_grid insertTileRandomAvailablePositionWithDelay:YES];
    }
    if (![self movesAvailable]) {
        [_grid.scene.viewController endGame:NO];
    }
    
}

#pragma mark -score

- (void)materializePendingScore {
    
    _score += _pendingScore;
    _pendingScore = 0;
    [_grid.scene.viewController updateScore:_score];
}

#pragma mark - state checkers

- (BOOL)movesAvailable {
    return [_grid hasAvailableCells] || [self adjacentMatchesAvailable];
}

- (BOOL)adjacentMatchesAvailable {
    for (NSInteger i = 0; i < _grid.dimension; i++) {
        for (NSInteger j = 0; j < _grid.dimension; j++) {
            FJTile *tile = [_grid tileAtPosision:FJPositionMake(i, j)];
            if (!tile) continue;
            
            if (GSTATE.gameType == FJGameTypePowerOf3) {
                if (([tile canMergeWithTile:[_grid tileAtPosision:FJPositionMake(i + 1, j)]] &&
                     [tile canMergeWithTile:[_grid tileAtPosision:FJPositionMake(i + 2, j)]]) ||
                    ([tile canMergeWithTile:[_grid tileAtPosision:FJPositionMake(i, j + 1)]] &&
                     [tile canMergeWithTile:[_grid tileAtPosision:FJPositionMake(i, j + 2)]])) {
                    return YES;
                }
            } else {
                if ([tile canMergeWithTile:[_grid tileAtPosision:FJPositionMake(i + 1, j)]] ||
                    [tile canMergeWithTile:[_grid tileAtPosision:FJPositionMake(i, j + 1)]]) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

@end
