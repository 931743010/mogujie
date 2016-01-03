//
//  UIScrollView+LSState.m
//  mogujie
//
//  Created by kevinlishuai on 16/1/2.
//  Copyright © 2016年 kevinlishuai. All rights reserved.
//

#import "UIScrollView+LSState.h"
#import <objc/message.h>

@implementation UIScrollView (LSState)

static NSString * LSScrollStateKey = nil;
- (void)setState:(LSScrollState)state
{
    objc_setAssociatedObject(self, &LSScrollStateKey, @(state), OBJC_ASSOCIATION_ASSIGN);
}

- (LSScrollState)state
{
    return (LSScrollState)objc_getAssociatedObject(self, &LSScrollStateKey);
}

@end
