//
//  FJCell.h
//  FJ_2048
//
//  Created by mzl_Jfang on 16/3/7.
//  Copyright © 2016年 mzl_Jfang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FJTile;
@interface FJCell : NSObject

@property (nonatomic, assign) FJPosition position;

@property (nonatomic, strong) FJTile *tile;

- (instancetype)initWithPosition:(FJPosition)position;

@end
