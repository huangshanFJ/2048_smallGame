//
//  FJScene.m
//  FJ_2048
//
//  Created by mzl_Jfang on 16/3/7.
//  Copyright © 2016年 mzl_Jfang. All rights reserved.
//

#import "FJScene.h"
#import "FJGameManager.h"
#import "FJGridView.h"

#define EFFECTIVE_SWIPE_DISTANCE_THRESHOLD 20.0f

#define VALID_SWIPE_DIRECTION_THRESHOLD 2.0f

@implementation FJScene {

    FJGameManager *_manager;
    
    BOOL _hasPendingSwipe;
    
    SKSpriteNode *_board;
}

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _manager = [[FJGameManager alloc] init];
    }
    return self;
}

- (void)loadBoardWithGrid:(FJGrid *)grid {
    if (_board) {
        [_board removeFromParent];
    }
    
    UIImage *image = [FJGridView gridImageWithGrid:grid];
    SKTexture *backgroundTexture = [SKTexture textureWithCGImage:image.CGImage];
    _board = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
    [_board setScale:1 / [UIScreen mainScreen].scale];
    _board.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:_board];
}

- (void)startNewGame {
    [_manager startNewSeeeionWithScene:self];
}

#pragma mark - swipe handing

- (void)didMoveToView:(SKView *)view {
    if (view == self.view) {
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        [self.view addGestureRecognizer:recognizer];
    } else {
        for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
            [self.view removeGestureRecognizer:recognizer];
        }
    }
}

- (void)handleSwipe:(UIPanGestureRecognizer *)swipe {
    if (swipe.state == UIGestureRecognizerStateBegan) {
        _hasPendingSwipe = YES;
    } else if (swipe.state == UIGestureRecognizerStateChanged) {
        [self commitTranslation:[swipe translationInView:self.view]];
    }
}

- (void)commitTranslation:(CGPoint)translation {
    if (!_hasPendingSwipe) return;
    
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    
    if (MAX(absX, absY) < EFFECTIVE_SWIPE_DISTANCE_THRESHOLD) return;
    
    if (absX > absY * VALID_SWIPE_DIRECTION_THRESHOLD) {
        translation.x < 0 ? [_manager moveToDirection:FJDirectionLeft] :
                            [_manager moveToDirection:FJDirectionRight];

    } else if (absY > absX * VALID_SWIPE_DIRECTION_THRESHOLD) {
        translation.y < 0 ? [_manager moveToDirection:FJDirectionUp] :
                            [_manager moveToDirection:FJDirectionDown];
    }
    _hasPendingSwipe = NO;
}

@end


