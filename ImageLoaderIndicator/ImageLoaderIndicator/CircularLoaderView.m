//
//  CircularLoaderView.m
//  ImageLoaderIndicatorObjC
//
//  Created by Kevin Bradley on 9/5/20.
//  Copyright © 2020 Rounak Jain. All rights reserved.
//

#import "CircularLoaderView.h"

@implementation CircularLoaderView {
    CGFloat _progress;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    if (progress > 1){
        self.circlePathLayer.strokeEnd = 1;
    } else if (progress < 0){
        self.circlePathLayer.strokeEnd = 0;
    } else {
        self.circlePathLayer.strokeEnd = progress;
    }
}

- (CGFloat)progress {
    return self.circlePathLayer.strokeEnd;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _circleRadius = 20.0;
    _circlePathLayer = [CAShapeLayer new];
    [self configure];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
     _circleRadius = 20.0;
    _circlePathLayer = [CAShapeLayer new];
    [self configure];
    return self;
}

- (void)configure {
    
    self.circlePathLayer.frame = self.bounds;
    self.circlePathLayer.lineWidth = 2;
    self.circlePathLayer.fillColor = [UIColor clearColor].CGColor;
    self.circlePathLayer.strokeColor = [UIColor redColor].CGColor;
    [[self layer] addSublayer:self.circlePathLayer];
    self.backgroundColor = [UIColor whiteColor];
    
    self.progress = 0;
    
    
}

- (CGRect)circleFrame {
    CGRect circleFrame = CGRectMake(0, 0, 2 * self.circleRadius, 2 * self.circleRadius);
    CGRect circlePathBounds = self.circlePathLayer.bounds;
    circleFrame.origin.x = CGRectGetMidX(circlePathBounds) - CGRectGetMidX(circleFrame);
    circleFrame.origin.y = CGRectGetMidY(circlePathBounds) - CGRectGetMidY(circleFrame);
    return circleFrame;
}

- (UIBezierPath *)circlePath {
    return [UIBezierPath bezierPathWithOvalInRect:self.circleFrame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.circlePathLayer.frame = self.bounds;
    self.circlePathLayer.path = [self circlePath].CGPath;
}

- (void)reveal {

    //1
    self.backgroundColor = [UIColor clearColor];
    self.progress = 1.0;
    //2
    [self.circlePathLayer removeAnimationForKey:@"strokeEnd"];
    //3
    [self.circlePathLayer removeFromSuperlayer];
    [self superview].layer.mask = self.circlePathLayer;
    
    //1
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat finalRadius = sqrt(center.x*center.x) + (center.y*center.y);
    CGFloat radiusInset = finalRadius - self.circleRadius;
    CGRect outerRect = CGRectInset([self circleFrame], -radiusInset, -radiusInset);
    CGPathRef toPath = [UIBezierPath bezierPathWithOvalInRect:outerRect].CGPath;
    
    //2
    CGPathRef fromPath = self.circlePathLayer.path;
    CGFloat fromLineWidth = self.circlePathLayer.lineWidth;
    
    //3
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.circlePathLayer.lineWidth = 2*finalRadius;
    self.circlePathLayer.path = toPath;
    [CATransaction commit];
    
    //4
    CABasicAnimation *lineWidthAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    lineWidthAnimation.fromValue = @(fromLineWidth);
    lineWidthAnimation.toValue = @(2*finalRadius);
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (__bridge id _Nullable)(fromPath);
    pathAnimation.toValue = (__bridge id _Nullable)(toPath);
    
    //5
    CAAnimationGroup *groupAnimation = [CAAnimationGroup new];
    groupAnimation.duration = 1;
    groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    groupAnimation.animations = @[pathAnimation, lineWidthAnimation];
    groupAnimation.delegate = self;
    
    [self.circlePathLayer addAnimation:groupAnimation forKey:@"strokeWidth"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self superview].layer.mask = nil;
}


@end
