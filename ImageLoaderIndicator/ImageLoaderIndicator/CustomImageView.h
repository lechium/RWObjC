//
//  CustomImageView.h
//  ImageLoaderIndicatorObjC
//
//  Created by Kevin Bradley on 9/5/20.
//  Copyright © 2020 Rounak Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircularLoaderView.h"
NS_ASSUME_NONNULL_BEGIN

@interface CustomImageView : UIImageView

@property CircularLoaderView *progressIndicatorView;

@end

NS_ASSUME_NONNULL_END
