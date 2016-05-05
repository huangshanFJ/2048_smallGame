//
//  FJTile.m
//  FJ_2048
//
//  Created by mzl_Jfang on 16/3/7.
//  Copyright © 2016年 mzl_Jfang. All rights reserved.
//

#import "FJTile.h"
#import "FJCell.h"

typedef void (^FJBlock)();
@implementation FJTile {
    
    SKLabelNode *_value;
    NSMutableArray *_pendingActions;
    
    FJBlock _pendingBlock;
}

#pragma mark - tile creation

+ (FJTile *)inserNewTileToCell:(FJCell *)cell {
    FJTile *tile = [[FJTile alloc] init];
    
    CGPoint origin = [GSTATE locationOfPosition:cell.position];
    tile.position = CGPointMake(origin.x + GSTATE.tileSize / 2, origin.y + GSTATE.tileSize / 2);
    [tile setScale:0];
    cell.tile = tile;
    return tile;
}

- (instancetype)init {
    if (self = [super init]) {
        CGRect rect = CGRectMake(0, 0, GSTATE.tileSize, GSTATE.tileSize);
        CGPathRef rectPath = CGPathCreateWithRoundedRect(rect, GSTATE.cornerRadius, GSTATE.cornerRadius, NULL);
        self.path = rectPath;
        CFRelease(rectPath);
        self.lineWidth = 0;
        
        _pendingActions = [[NSMutableArray alloc] init];
        
        _value = [SKLabelNode labelNodeWithFontNamed:[GSTATE boldFontName]];
        _value.position = CGPointMake(GSTATE.tileSize / 2, GSTATE.tileSize / 2);
        _value.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        _value.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [self addChild:_value];
        
        if (GSTATE.gameType == FJGameTypeFibonacci) {
            self.level = arc4random_uniform(100) < 40 ? 1 : 2;
        } else {
            self.level = arc4random_uniform(100) < 95 ? 1 : 2;
        }
        [self refreshValue];
    }
    return self;
}

#pragma mark - public methods

- (void)removeFromParentCell {
    if (self.cell.tile == self) self.cell.tile = nil;
}

- (BOOL)hasPendingMerge {
    return _pendingActions.count > 1;
}

- (void)commitPendingActions {
    [self runAction:[SKAction sequence:_pendingActions] completion:^{
        [_pendingActions removeAllObjects];
        if (_pendingBlock) {
            _pendingBlock();
            _pendingBlock = nil;
        }
    }];
}

- (BOOL)canMergeWithTile:(FJTile *)tile {
    if (!tile) {
        return NO;
    }
    return [GSTATE isLevel:self.level mergeableWithLevel:tile.level];
}

- (NSInteger)mergeToTile:(FJTile *)tile {
    if (!tile || [tile hasPendingMerge]) return 0;
    NSInteger newLevel = [GSTATE mergeLevel:self.level withLevel:tile.level];
    if (newLevel > 0) {
        [self moveToCell:tile.cell];
        [tile removeWithDelay];
        [self updateLevelTo:newLevel];
        [_pendingActions addObject:[self pop]];
    }
    return newLevel;
}

- (NSInteger)merge3ToTile:(FJTile *)tile andTile:(FJTile *)furtherTile {
    if (!tile || [tile hasPendingMerge] || [furtherTile hasPendingMerge]) return 0;
    
    NSInteger newLevel = MIN([GSTATE mergeLevel:self.level withLevel:tile.level], [GSTATE mergeLevel:tile.level withLevel:furtherTile.level]);
    
    if (newLevel > 0) {
        [tile moveToCell:furtherTile.cell];
        [tile moveToCell:furtherTile.cell];
        
        [tile removeWithDelay];
        [furtherTile removeWithDelay];
        
        [self updateLevelTo:newLevel];
        [_pendingActions addObject:[self pop]];
    }
    return newLevel;
}

- (void)updateLevelTo:(NSInteger)level {
    self.level = level;
    [_pendingActions addObject:[SKAction runBlock:^{
        [self refreshValue];
    }]];
}

- (void)refreshValue {
    long value = [GSTATE valueForLevel:self.level];
    _value.text = [NSString stringWithFormat:@"%ld",value];
    _value.fontColor = [GSTATE textColorForLevel:self.level];
    _value.fontSize = [GSTATE textSizeForValue:value];
    
    self.fillColor = [GSTATE colorForLevel:self.level];
}

- (void)moveToCell:(FJCell *)cell {
    [_pendingActions addObject:[SKAction moveTo:[GSTATE locationOfPosition:cell.position] duration:GSTATE.animationDuration]];
    self.cell.tile = nil;
    cell.tile = self;
}

- (void)removeAnimated:(BOOL)animated {
    
    if (animated) [_pendingActions addObject:[SKAction scaleTo:0 duration:GSTATE.animationDuration]];
    [_pendingActions addObject:[SKAction removeFromParent]];
    
    __weak typeof(self) weakSelf = self;
    _pendingBlock = ^{
        [weakSelf removeFromParentCell];
    };
    [self commitPendingActions];
}

- (void)removeWithDelay {
    SKAction *wait = [SKAction waitForDuration:GSTATE.animationDuration];
    SKAction *remove = [SKAction removeFromParent];
    [self runAction:[SKAction sequence:@[wait,remove]] completion:^{
        [self removeFromParentCell];
    }];
}

#pragma mark - skaction helpers 

- (SKAction *)pop {
    CGFloat d = 0.15 * GSTATE.tileSize;
    SKAction *wait = [SKAction waitForDuration:GSTATE.animationDuration];
    SKAction *enlarge = [SKAction scaleTo:1.3 duration:GSTATE.animationDuration / 1.5];
    SKAction *move = [SKAction moveBy:CGVectorMake(-d, -d) duration:GSTATE.animationDuration / 1.5];
    SKAction *restore = [SKAction scaleTo:1 duration:GSTATE.animationDuration / 1.5];
    SKAction *moveBack = [SKAction moveBy:CGVectorMake(d, d) duration:GSTATE.animationDuration / 1.5];
    return [SKAction sequence:@[wait, [SKAction group:@[enlarge, move]], [SKAction group:@[restore, moveBack]]]];
}

@end









