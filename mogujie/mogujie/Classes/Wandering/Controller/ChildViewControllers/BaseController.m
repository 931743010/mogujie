//
//  BaseController.m
//  mogujie
//
//  Created by kevinlishuai on 15/12/27.
//  Copyright © 2015年 kevinlishuai. All rights reserved.
//

#import "BaseController.h"

@interface BaseController ()

@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollEnabledDidChanged) name:@"UITableViewScrollEnabledChangedNotification" object:nil];
}


- (void)scrollEnabledDidChanged
{
    self.tableView.scrollEnabled = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0) {
        scrollView.scrollEnabled = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"note" object:nil];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
