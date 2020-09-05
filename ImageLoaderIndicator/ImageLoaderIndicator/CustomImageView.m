//
//  CustomImageView.m
//  ImageLoaderIndicatorObjC
//
//  Created by Kevin Bradley on 9/5/20.
//  Copyright © 2020 Rounak Jain. All rights reserved.
//

#import "CustomImageView.h"
#import "UIImageView+WebCache.h"

@implementation CustomImageView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    self.progressIndicatorView = [[CircularLoaderView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.progressIndicatorView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v]|" options:0 metrics:nil views:@{@"v": self.progressIndicatorView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v]|" options:0 metrics:nil views:@{@"v": self.progressIndicatorView}]];
    
    self.progressIndicatorView.translatesAutoresizingMaskIntoConstraints = false;
    
    NSURL *url = [NSURL URLWithString:@"https://koenig-media.raywenderlich.com/uploads/2015/02/mac-glasses.jpeg"];
    [self sd_setImageWithURL:url placeholderImage:nil options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        self.progressIndicatorView.progress = (CGFloat)receivedSize / (CGFloat)expectedSize;
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
       
        if (error){
            NSLog(@"error: %@", error);
        }
        [self.progressIndicatorView reveal];
    }];
    return self;
    
}


@end
