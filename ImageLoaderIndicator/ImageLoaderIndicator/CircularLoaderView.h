//
//  CircularLoaderView.h
//  ImageLoaderIndicatorObjC
//
//  Created by Kevin Bradley on 9/5/20.
//  Copyright © 2020 Rounak Jain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircularLoaderView : UIView <CAAnimationDelegate>

@property CAShapeLayer *circlePathLayer;
@property CGFloat circleRadius;

- (void)setProgress:(CGFloat)progress;
- (CGFloat)progress;

- (void)reveal;

@end

NS_ASSUME_NONNULL_END
