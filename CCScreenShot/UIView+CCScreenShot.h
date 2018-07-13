//
//  UIView+CCScreenShot.h
//  MyScreenShortDemo
//
//  Created by 蔡成汉 on 2018/7/10.
//  Copyright © 2018年 蔡成汉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CCScreenShot)

- (UIImage *)screenShot;
- (UIImage *)screenShotWithIndicator;
- (void)screenShot:(void(^)(UIImage *image))complete;
- (void)screenShotWithIndicator:(void(^)(UIImage *image))complete;

@end
