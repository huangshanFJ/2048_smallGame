//
//  FJGameManager.h
//  FJ_2048
//
//  Created by 方健 on 16/3/7.
//  Copyright © 2016年 mzl_Jfang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FJScene;

typedef NS_ENUM(NSInteger,FJDirection) {
    FJDirectionUp,
    FJDirectionLeft,
    FJDirectionDown,
    FJDirectionRight
};

@interface FJGameManager : NSObject

- (void)startNewSeeeionWithScene:(FJScene *)scene;

- (void)moveToDirection:(FJDirection)direction;

@end
