//
//  LSWanderingController.m
//  mogujie
//
//  Created by kevinlishuai on 15/11/13.
//  Copyright © 2015年 kevinlishuai. All rights reserved.
//

#import "LSBottomContentViewController.h"
#import "BoyFriendController.h"
#import "AttentionController.h"
#import "KawaiiController.h"
#import "PersonalController.h"
#import "StreetSnapController.h"
#import "HotViewController.h"
#import "BeautyController.h"
#import "TravelController.h"

@interface LSBottomContentViewController () <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger count;

/** 标题数组 */
@property (nonatomic, strong) NSArray *titleArray;

/** 标题滚动视图*/
@property (nonatomic, weak) UIScrollView *titleView;

/** 上一次选中的按钮*/
@property (nonatomic, weak) UIButton *previousSelectedButton;

/** 下面内容的视图*/
@property (nonatomic, weak) UIScrollView *contentView;

@end

@implementation LSBottomContentViewController

#pragma mark - 懒加载标题数组
- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"关注", @"热点", @"私搭", @"街拍", @"男票", @"可爱", @"脸赞", @"旅行"];
        self.count = _titleArray.count;
    }
    return _titleArray;
}

#pragma mark - 初始化
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 初始化子控制器
    [self setupChildControllers];
    
    // 初始化标题视图
    [self setupTitleView];
    
    [self setupContentView];
}

#pragma mark - 初始化子控制器
- (void)setupChildControllers
{
    [self addChildViewController:[[AttentionController alloc] init]];
    [self addChildViewController:[[HotViewController alloc] init]];
    [self addChildViewController:[[PersonalController alloc] init]];
    [self addChildViewController:[[StreetSnapController alloc] init]];
    [self addChildViewController:[[BoyFriendController alloc] init]];
    [self addChildViewController:[[KawaiiController alloc] init]];
    [self addChildViewController:[[BeautyController alloc] init]];
    [self addChildViewController:[[TravelController alloc] init]];
}

#pragma mark - 初始化TitleView
- (void)setupTitleView
{
    UIScrollView * titleView = [[UIScrollView alloc] init];
    titleView.translatesAutoresizingMaskIntoConstraints = NO;
    
    titleView.frame = CGRectMake(0, 0, screenW, LSTitleViewH);
    [self.view addSubview:titleView];
    titleView.showsVerticalScrollIndicator = NO;
    titleView.showsHorizontalScrollIndicator = NO;
    [self setupTitleButtonsWithTitleView:titleView];
    self.titleView = titleView;
}

#pragma mark - 给TitleView设置标题按钮
- (void)setupTitleButtonsWithTitleView:(UIScrollView *)titleView
{
    CGSize buttonSize = [[self.titleArray firstObject] boundingRectWithSize:CGSizeMake(MAXFLOAT, LSTitleViewH) options:0 attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:25]} context:nil].size;
    
    CGFloat buttonW = buttonSize.width + LSCommonMargin;
    CGFloat buttonH = LSTitleViewH;
    for (int i = 0; i < self.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleView addSubview:button];
        button.titleLabel.font = [UIFont systemFontOfSize:25];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.frame = CGRectMake(buttonW * i , 0, buttonW, buttonH);
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        if (i == 0) [self buttonClick:button];
    }
    titleView.contentSize = CGSizeMake(buttonW * self.count, 0);
}

- (void)buttonClick:(UIButton *)button
{
    self.previousSelectedButton.selected = NO;
    button.selected = YES;
    
    CGPoint offset = CGPointMake(button.tag * screenW, 0);
    labs(button.tag - self.previousSelectedButton.tag) >= 2 ? [self.contentView setContentOffset:offset animated:YES] : [self.contentView setContentOffset:offset animated:YES];
    
    self.previousSelectedButton = button;
    
    // 设置标题的点击偏移
    CGFloat offsetX = button.centerX - screenW * 0.5;
    if (offsetX < 0) offsetX = 0;
    CGFloat maxOffsetX = self.titleView.contentSize.width - screenW;
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    [self.titleView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark - 初始化ContentView
- (void)setupContentView
{
    UIScrollView * contentView = [[UIScrollView alloc] init];
    contentView.frame = CGRectMake(0, LSTitleViewH, screenW, screenH - LSTitleViewH);
    [self.view addSubview:contentView];
    
    contentView.pagingEnabled = YES;
    contentView.contentSize = CGSizeMake(screenW * self.count, 0);
    contentView.delegate = self;
    self.contentView = contentView;
    
    [self chooseViewControllerAtIndex:0];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / screenW;

    [self chooseViewControllerAtIndex:index];
    
    UIButton * button = self.titleView.subviews[index];
    
    [self buttonClick:button];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / screenW;
    [self chooseViewControllerAtIndex:index];
}

#pragma mark - 选择控制器
- (void)chooseViewControllerAtIndex:(NSInteger)index
{
    UITableViewController * vc = self.childViewControllers[index];
    if (vc.viewIfLoaded) {
        return;
    }
    [self.contentView addSubview:vc.view];
    vc.view.frame = CGRectMake(index * screenW, 0, screenW, self.contentView.height);
    vc.view.backgroundColor = randomColor;
}

@end
