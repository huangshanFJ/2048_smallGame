//
//  FJPosition.h
//  FJ_2048
//
//  Created by mzl_Jfang on 16/3/7.
//  Copyright © 2016年 mzl_Jfang. All rights reserved.
//

#ifndef FJPosition_h
#define FJPosition_h

typedef struct Position {
    NSInteger x;
    NSInteger y;
} FJPosition;

CG_INLINE FJPosition FJPositionMake(NSInteger x, NSInteger y) {
    FJPosition position;
    position.x = x; position.y = y;
    return position;
}

#endif /* FJPosition_h */
