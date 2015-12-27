//
//  HotViewController.m
//  01-网易新闻(搭建界面)
//
//  Created by xiaomage on 15/11/22.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "AttentionController.h"

@interface AttentionController ()

@end

@implementation AttentionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        self.view.backgroundColor = [UIColor orangeColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@----%zd", self.class, indexPath.row];
    return cell;
}

@end
