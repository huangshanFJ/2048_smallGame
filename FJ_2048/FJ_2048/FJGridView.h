//
//  FJBestView.h
//  FJ_2048
//
//  Created by mzl_Jfang on 16/3/7.
//  Copyright © 2016年 mzl_Jfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJGrid;
@interface FJGridView : UIView

+ (UIImage *)gridImageWithGrid:(FJGrid *)grid;

+ (UIImage *)gridImageWithOverlay;

@end
