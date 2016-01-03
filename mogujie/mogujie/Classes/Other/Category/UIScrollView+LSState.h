//
//  UIScrollView+LSState.h
//  mogujie
//
//  Created by kevinlishuai on 16/1/2.
//  Copyright © 2016年 kevinlishuai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LSScrollState) {
    LSScrollStateTop,
    LSScrollStateScroll,
    LSScrollStateBottom
};

@interface UIScrollView (LSState)

@property (nonatomic, assign) LSScrollState state;

@end
