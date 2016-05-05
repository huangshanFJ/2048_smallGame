//
//  FJBestView.m
//  FJ_2048
//
//  Created by mzl_Jfang on 16/3/7.
//  Copyright © 2016年 mzl_Jfang. All rights reserved.
//

#import "FJGridView.h"
#import "FJGrid.h"

@implementation FJGridView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [GSTATE scoreBoardColor];
        self.layer.cornerRadius = GSTATE.cornerRadius;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (instancetype)init {
    NSInteger side = GSTATE.dimension * (GSTATE.tileSize + GSTATE.borderWidth) + GSTATE.borderWidth;
    CGFloat verticalOffset = [[UIScreen mainScreen] bounds].size.height - GSTATE.verticalOffset;
    return [self initWithFrame:CGRectMake(GSTATE.horizontalOffset, verticalOffset - side, side, side)];
}

+ (UIImage *)gridImageWithGrid:(FJGrid *)grid {
    UIView *backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    backgroundView.backgroundColor = [GSTATE backgroundColor];
    FJGridView *view = [[FJGridView alloc] init];
    [backgroundView addSubview:view];
    
    [grid forEach:^(FJPosition position) {
        CALayer *layer = [CALayer layer];
        CGPoint point = [GSTATE locationOfPosition:position];
        
        CGRect frame = layer.frame;
        frame.size = CGSizeMake(GSTATE.tileSize, GSTATE.tileSize);
        frame.origin = CGPointMake(point.x, [[UIScreen mainScreen] bounds].size.height - point.y - GSTATE.tileSize);
        layer.frame = frame;
        
        layer.backgroundColor = [GSTATE boardColor].CGColor;
        layer.cornerRadius = GSTATE.cornerRadius;
        layer.masksToBounds = YES;
        [backgroundView.layer addSublayer:layer];
    } reverseOrder:NO];
    return [FJGridView snapshotWithView:backgroundView];
}

+ (UIImage *)gridImageWithOverlay {
    UIView *backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.opaque = NO;
    
    FJGridView *view = [[FJGridView alloc] init];
    view.backgroundColor = [GSTATE backgroundColor];
    [backgroundView addSubview:view];
    
    return [FJGridView snapshotWithView:backgroundView];
}

+ (UIImage *)snapshotWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.frame.size, view.opaque, 0.0);
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end




