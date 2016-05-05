//
//  FJScene.h
//  FJ_2048
//
//  Created by mzl_Jfang on 16/3/7.
//  Copyright © 2016年 mzl_Jfang. All rights reserved.
//

@import SpriteKit;

@class FJMainViewController,FJGrid;

@interface FJScene : SKScene

@property (nonatomic, weak) FJMainViewController *viewController;

- (void)startNewGame;

- (void)loadBoardWithGrid:(FJGrid *)grid;

@end
