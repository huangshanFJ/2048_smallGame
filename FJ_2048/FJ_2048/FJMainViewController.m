//
//  FJMainViewController.m
//  FJ_2048
//
//  Created by mzl_Jfang on 16/3/7.
//  Copyright © 2016年 mzl_Jfang. All rights reserved.
//

#import "FJMainViewController.h"
#import "FJScoreView.h"
#import "FJOverView.h"
#import "FJGridView.h"
#import "FJGameManager.h"
#import "FJScene.h"

#import <SpriteKit/SpriteKit.h>

@implementation FJMainViewController {

    IBOutlet UIButton *_restartButton;
    IBOutlet UIButton *_settingsButton;
    IBOutlet UILabel *_targetScore;
    IBOutlet UILabel *_subtitle;
    IBOutlet FJScoreView *_scoreView;
    IBOutlet FJScoreView *_bestView;
    
    FJScene *_scene;
    
    IBOutlet FJOverView *_overlay;
    IBOutlet UIImageView *_overlayBackground;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateState];
    
    _bestView.score.text = [NSString stringWithFormat:@"%ld",(long)[SETTING integerForKey:@"Best Score"]];
    
    _restartButton.layer.cornerRadius = [GSTATE cornerRadius];
    _restartButton.layer.masksToBounds = YES;
    
    _settingsButton.layer.cornerRadius = [GSTATE cornerRadius];
    _settingsButton.layer.masksToBounds = YES;
    
    _overlay.hidden = YES;
    _overlayBackground.hidden = YES;
    
    SKView *skView = (SKView *)self.view;
    
    FJScene *scene = [FJScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [skView presentScene:scene];
    [self updateScore:0];
    [scene startNewGame];
    
    _scene = scene;
    _scene.viewController = self;
}

- (void)updateState {
    
    [_scoreView updateAppearance];
    [_bestView updateAppearance];
    
    _restartButton.backgroundColor = [GSTATE buttonColor];
    _restartButton.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:14];
    
    _settingsButton.backgroundColor = [GSTATE buttonColor];
    _settingsButton.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:14];
    
    _targetScore.textColor = [GSTATE buttonColor];
    
    long target = [GSTATE valueForLevel:GSTATE.winningLevel];
    
    if (target > 100000) {
        _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:34];
    } else if (target < 10000) {
        _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:42];
    } else {
        _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:40];
    }
    
    _targetScore.text = [NSString stringWithFormat:@"%ld",target];
    
    _subtitle.textColor = [GSTATE buttonColor];
    _subtitle.font = [UIFont fontWithName:[GSTATE regularFontName] size:14];
    _subtitle.text = [NSString stringWithFormat:@"健哥真帅--%ld",target];
    
    _overlay.message.font = [UIFont fontWithName:[GSTATE regularFontName] size:36];
    _overlay.keepPlaying.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:17];
    _overlay.restartGame.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:17];
    
    _overlay.message.textColor = [GSTATE buttonColor];
    [_overlay.keepPlaying setTitleColor:[GSTATE buttonColor] forState:UIControlStateNormal];
    [_overlay.restartGame setTitleColor:[GSTATE buttonColor] forState:UIControlStateNormal];
    
}

- (void)updateScore:(NSInteger)score {
    _scoreView.score.text = [NSString stringWithFormat:@"%ld",(long)score];
    if ([SETTING integerForKey:@"Best Score"] < score) {
        [SETTING setInteger:score forKey:@"Best Score"];
        _bestView.score.text = [NSString stringWithFormat:@"%ld",(long)score];
    }
}

- (IBAction)restart:(id)sender {
    [self hideOverlay];
    [self updateScore:0];
    [_scene startNewGame];
}

- (IBAction)keepPlaying:(id)sender {
    [self hideOverlay];
}

- (IBAction)done:(UIStoryboardSegue *)segue {
    ((SKView *)self.view).paused = NO;
    if (GSTATE.needRefresh) {
        [GSTATE loadGlobalState];
        [self updateState];
        [self updateScore:0];
        [_scene startNewGame];
    }
}

- (void)endGame:(BOOL)won {
    _overlay.hidden = NO;
    _overlay.alpha = 0;
    _overlayBackground.hidden = NO;
    _overlayBackground.alpha = 0;
    
    if (!won) {
        _overlay.keepPlaying.hidden = YES;
        _overlay.message.text = @"Game Over";
    } else {
        _overlay.keepPlaying.hidden = NO;
        _overlay.message.text = @"You win";
    }
    
    _overlayBackground.image = [FJGridView gridImageWithOverlay];
    
    CGFloat verticalOffset = [[UIScreen mainScreen] bounds].size.height - GSTATE.verticalOffset;
    NSInteger side = GSTATE.dimension * (GSTATE.tileSize + GSTATE.borderWidth) + GSTATE.borderWidth;
    _overlay.center = CGPointMake(GSTATE.horizontalOffset + side / 2, verticalOffset - side / 2);
    
    [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _overlay.alpha = 1;
        _overlayBackground.alpha = 1;
    } completion:^(BOOL finished) {
        ((SKView *)self.view).paused = YES;
    }];
}

- (void)hideOverlay {
    ((SKView *)self.view).paused = NO;
    if (!_overlay.hidden) {
        [UIView animateWithDuration:0.5 animations:^{
            _overlay.alpha = 0;
            _overlayBackground.alpha = 0;
        } completion:^(BOOL finished) {
            _overlay.hidden = YES;
            _overlayBackground.hidden = YES;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ((SKView *)self.view).paused = YES;
}
@end
