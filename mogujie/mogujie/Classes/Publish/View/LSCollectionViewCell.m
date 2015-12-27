//
//  LSCollectionViewCell.m
//  mogujie
//
//  Created by kevinlishuai on 15/11/17.
//  Copyright © 2015年 kevinlishuai. All rights reserved.
//

#import "LSCollectionViewCell.h"

@interface LSCollectionViewCell ()

@end

@implementation LSCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"LSCollectionViewCell" owner:self options:nil] lastObject];
        self.imageView.layer.cornerRadius = 5;
        self.imageView.layer.masksToBounds = YES;
    }
    return self;
}

@end
