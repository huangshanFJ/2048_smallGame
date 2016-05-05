//
//  FJCell.m
//  FJ_2048
//
//  Created by mzl_Jfang on 16/3/7.
//  Copyright © 2016年 mzl_Jfang. All rights reserved.
//

#import "FJCell.h"
#import "FJTile.h"

@implementation FJCell

- (instancetype)initWithPosition:(FJPosition)position {
    if (self = [super init]) {
        self.position = position;
        self.tile = nil;
    }
    return self;
}

- (void)setTile:(FJTile *)tile {
    _tile = tile;
    if (tile) tile.cell = self;
}

@end
