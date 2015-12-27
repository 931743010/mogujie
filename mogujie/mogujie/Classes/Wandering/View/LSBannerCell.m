//
//  LSBannerCell.m
//  mogujie
//
//  Created by kevinlishuai on 15/12/27.
//  Copyright © 2015年 kevinlishuai. All rights reserved.
//

#import "LSBannerCell.h"
#import <UIImageView+WebCache.h>
#import "LSModel.h"

@interface LSBannerCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation LSBannerCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(LSModel *)model
{
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.imageName] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.imageView.image = image;
    }];
    
}

@end
