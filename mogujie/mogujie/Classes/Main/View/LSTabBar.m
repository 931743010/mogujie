//
//  LSTabBar.m
//  mogujie
//
//  Created by kevinlishuai on 15/11/13.
//  Copyright © 2015年 kevinlishuai. All rights reserved.
//

#import "LSTabBar.h"
#import "UIView+frame.h"
@interface LSTabBar ()

@property (nonatomic, weak) UIButton * photoButton;

@end

@implementation LSTabBar


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        // 添加一个加号按钮
        UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage * image = [self addImage:[UIImage imageNamed:@"post_bkg"] toImage:[UIImage imageNamed:@"post_camara" ] withSize:CGSizeMake(40, 40)];
        [photoButton setImage:image forState:UIControlStateNormal];
        photoButton.bounds = CGRectMake(0, 0, 40, 40);
        [photoButton addTarget:self action:@selector(photoButtonClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:photoButton];
        self.photoButton = photoButton;
    }
    return self;
}

- (void)photoButtonClick:(UIButton *)button
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCameraNotice object:nil];
}

- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 withSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    
    // Draw image1
    [image1 drawInRect:(CGRect){{0,0}, size}];
    
    // Draw image2
    [image2 drawInRect:CGRectMake(10, 10, size.width - 20, size.height - 20)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整加号按钮的位置
    CGFloat h = self.frame.size.height;
    self.photoButton.center = CGPointMake(screenW * 0.5, h * 0.5);
    
    // 按钮的frame数据
    CGFloat buttonH = h;
    CGFloat buttonW = screenW / 5;
    CGFloat buttonY = 0;
    CGFloat buttonX = 0;

    
    int index = 0;
    for (UIView * view in self.subviews) {
        if (![NSStringFromClass(view.class) isEqualToString:@"UITabBarButton"]) continue;
        if (index > 1) {
            buttonX = (index + 1) * buttonW;
        } else {
            buttonX = index * buttonW;
        }
        view.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        index ++;
    }
}



@end
