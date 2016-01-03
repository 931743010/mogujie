//
//  LSCollectionViewController.m
//  mogujie
//
//  Created by kevinlishuai on 15/12/27.
//  Copyright © 2015年 kevinlishuai. All rights reserved.
//

#import "LSBannerViewController.h"
#import <MJExtension.h>
#import "LSBannerCell.h"
#import "LSModel.h"


#define kTopSize CGSizeMake([UIScreen mainScreen].bounds.size.width, 200)

static NSUInteger const kTimes = 10000;

@interface LSBannerViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

/** 图片数组 */
@property (nonatomic, strong) NSArray *images;

/** CollectionView */
@property (nonatomic, strong) UICollectionView * collectionView;

/** 定时器 */
@property (nonatomic, strong) NSTimer * timer;

/** 定时器 */
@property (nonatomic, weak) UIPageControl * pageControl;

@end

@implementation LSBannerViewController

static NSString * identifier = @"UICollectionViewCell";

#pragma mark - 懒加载
- (NSArray *)images
{
    if (!_images) {
        
        NSString * filePath = [[NSBundle mainBundle] pathForResource:@"images.plist" ofType:nil] ;
        NSArray * arr = [NSArray arrayWithContentsOfFile:filePath];
        
        NSMutableArray * arrayM = [NSMutableArray array];
        
        for (NSDictionary * dict in arr) {
            LSModel * model = [LSModel new];
            [model setValue:dict[@"imageName"] forKey:@"imageName"];
            [arrayM addObject:model];
        }
        
        _images = arrayM;
    }
    return _images;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCollectionView];
    
    [self setupPageControl];
    
    [self setupTimer];
    
    [self addObserver];
}

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer) name:@"kStopTimerNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupTimer) name:@"kResumeTimerNotification" object:nil];
}

- (void)setupPageControl
{
    UIPageControl * pageControl = [[UIPageControl alloc] init];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    self.pageControl.numberOfPages = self.images.count;
    CGPoint center = self.pageControl.center ;
    center.x = kTopSize.width * 0.5;
    center.y = kTopSize.height * 0.95;
    self.pageControl.center = center;
}

- (void)setupTimer
{
    [self.timer invalidate];
    self.timer = nil;
    
    NSTimer * timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)startTimer
{
    CGFloat currentPageIndex = self.collectionView.contentOffset.x / kTopSize.width;
    currentPageIndex ++;
    if (currentPageIndex == self.images.count * kTimes) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    } else {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:currentPageIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    }
}

#pragma mark - 初始化CollectionView
- (void)setupCollectionView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = kTopSize;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kTopSize.width, kTopSize.height) collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LSBannerCell class]) bundle:nil] forCellWithReuseIdentifier:identifier];
    collectionView.scrollEnabled = YES;
    collectionView.pagingEnabled = YES;
    collectionView.contentSize = CGSizeMake(self.images.count * kTopSize.width, 0);
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    NSInteger middleX = kTimes * 0.5;
    
    if (self.collectionView.contentOffset.x == 0) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:middleX inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    }
    
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return YES;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count * kTimes;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LSBannerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSInteger index = indexPath.item % self.images.count;
    cell.model = self.images[index];
    
    return cell;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setupTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / kTopSize.width;
    int currentPage = index % self.images.count;
    self.pageControl.currentPage = currentPage;
}


- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}


@end
