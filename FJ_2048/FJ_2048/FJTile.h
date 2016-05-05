//
//  FJTile.h
//  FJ_2048
//
//  Created by mzl_Jfang on 16/3/7.
//  Copyright © 2016年 mzl_Jfang. All rights reserved.
//

@import SpriteKit;
@class FJCell;
@interface FJTile : SKShapeNode

@property (nonatomic, strong) FJCell *cell;

@property (nonatomic, assign) NSInteger level;

+ (FJTile *)inserNewTileToCell:(FJCell *)cell;

- (void)commitPendingActions;

- (BOOL)canMergeWithTile:(FJTile *)tile;

- (NSInteger)mergeToTile:(FJTile *)tile;

- (NSInteger)merge3ToTile:(FJTile *)tile andTile:(FJTile *)furtherTile;

- (void)moveToCell:(FJCell *)cell;

- (void)removeAnimated:(BOOL)animated;

@end
