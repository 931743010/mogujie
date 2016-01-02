//
//  LSCameraViewController.m
//  mogujie
//
//  Created by kevinlishuai on 15/11/17.
//  Copyright © 2015年 kevinlishuai. All rights reserved.
//

#import "LSPublishViewController.h"
#import "LSBottomView.h"
#import "LSConst.h"
#import "LSImageTool.h"

@interface LSPublishViewController ()

@property (nonatomic, weak) LSBottomView * bottomV;

@end

@implementation LSPublishViewController

#pragma mark - 初始化
- (instancetype)init{
    if (self = [super init]) {
        [self addChildView];
    }
    return self;
}

#pragma mark - 添加子控件
- (void)addChildView{
    LSBottomView * bottomV = [[LSBottomView alloc] init];
    [self.view addSubview:bottomV];
    self.bottomV = bottomV;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏
    [self setupNav];

    // 添加通知观察者
    [self addObservers];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor lightGrayColor];
}


#pragma mark - 布局子控件
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGFloat h = 300;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat x = 0;
    CGFloat y = [UIScreen mainScreen].bounds.size.height - h;
    self.bottomV.frame = CGRectMake(x, y, w, h);
}

#pragma mark - 初始化导航栏
- (void)setupNav
{
    
    UINavigationBar * navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:[UIColor blackColor]];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"closed_background"] style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(next:)];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
}

#pragma mark - 添加通知观察者
- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openCamera) name:kOpenCameraNotice object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(choosePhoto:) name:kOpenPhotoNotice object:nil];
}


#pragma mark - 监听导航栏按钮的点击
- (void)back:(UIBarButtonItem *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
    UINavigationBar * navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:[UIColor whiteColor]];
}


- (void)next:(UIBarButtonItem *)btn{
    
}


#pragma mark - note
/**
 *  开启相机
 */
- (void)openCamera{
    UIImagePickerController * pickerC = [[UIImagePickerController alloc] init];
    pickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:pickerC animated:YES completion:nil];
}

/**
 *  选择照片
 *
 *  @param notification 通知
 */
- (void)choosePhoto:(NSNotification *)notification{
    
    NSLog(@"%@", notification.userInfo);
    
}



@end
