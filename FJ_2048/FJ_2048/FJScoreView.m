//
//  FJScoreView.m
//  FJ_2048
//
//  Created by mzl_Jfang on 16/3/7.
//  Copyright © 2016年 mzl_Jfang. All rights reserved.
//

#import "FJScoreView.h"

@implementation FJScoreView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.layer.cornerRadius = GSTATE.cornerRadius;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor greenColor];
}

- (void)updateAppearance {
    self.backgroundColor = [GSTATE scoreBoardColor];
    self.title.font = [UIFont fontWithName:[GSTATE boldFontName] size:12];
    self.score.font = [UIFont fontWithName:[GSTATE regularFontName] size:16];
}

@end
