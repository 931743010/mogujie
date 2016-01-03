//
//  LSTabBarController.m
//  mogujie
//
//  Created by kevinlishuai on 15/11/13.
//  Copyright © 2015年 kevinlishuai. All rights reserved.
//

#import "LSTabBarController.h"
#import "LSWanderingController.h"
#import "LSBuyController.h"
#import "LSChatController.h"
#import "LSMeController.h"
#import "LSTabBar.h"
#import "LSNavController.h"
#import "LSPublishViewController.h"
#import "LSConst.h"
#import "LSContextTransitioning.h"

@interface LSTabBarController ()

@end

@implementation LSTabBarController


#pragma mark - 初始化
- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupChildViewControllers];
    
    [self setupTabBar];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postPhoto) name:kCameraNotice object:nil];
}

#pragma mark - 初始化子控制器
- (void)setupChildViewControllers
{
    // 逛逛逛
    LSWanderingController * wanderingVC = [[LSWanderingController alloc] init];
    [self childViewController:wanderingVC imageName:@"icon_tabbar_timeline" selectedImageName:@"icon_tabbar_timeline_selected" withTitle:@"逛逛逛"];
    wanderingVC.view.backgroundColor = [UIColor whiteColor];
    
    // 买买买
    LSBuyController * buyVC = [[LSBuyController alloc] init];
    [self childViewController:buyVC imageName:@"Shopping-cart" selectedImageName:@"Shopping-cart_selected" withTitle:@"买买买"];
    
    // 聊聊聊
    LSChatController * chatVC = [[LSChatController alloc] init];
    [self childViewController:chatVC imageName:@"tabbar_im" selectedImageName:@"tabbar_im_selected" withTitle:@"聊聊聊"];
    
    // 我我我
    LSMeController * meVC = [[LSMeController alloc] init];
    [self childViewController:meVC imageName:@"mgjme_tabbarItem_me" selectedImageName:@"mgjme_tabbarItem_me_selected" withTitle:@"我我我"];
}

- (void)childViewController:(UIViewController *)vc imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName withTitle:(NSString *)title
{
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.tabBarItem.image = [UIImage imageNamed:imageName];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    nav.tabBarItem.title = title;
    [self addChildViewController:nav];
}

#pragma mark - 初始化tabBar
- (void)setupTabBar
{
    [self setValue:[[LSTabBar alloc] init] forKeyPath:@"tabBar"];
    self.tabBar.tintColor = [UIColor redColor];
}

#pragma mark - 监听中间按钮的点击
- (void)postPhoto
{
    LSPublishViewController * publishVC = [[LSPublishViewController alloc] init];
    
    LSNavController * publishNav = [[LSNavController alloc] initWithRootViewController:publishVC];
    
    publishNav.transitioningDelegate = [LSContextTransitioning sharedContextTransitioning];
    
    [self presentViewController:publishNav animated:YES completion:nil];
}



@end
