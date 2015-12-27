//
//  LSBottomView.m
//  mogujie
//
//  Created by kevinlishuai on 15/11/17.
//  Copyright © 2015年 kevinlishuai. All rights reserved.
//

#import "LSBottomView.h"
#import "UIView+frame.h"
#import "Singleton.h"
#import "LSImageTool.h"
#import "LSConst.h"
#import "LSCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface LSBottomView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UIButton * button;

@property (nonatomic, weak) UICollectionViewFlowLayout * flowLayout;

@property (nonatomic, weak) UICollectionView * collectionV;

@property (nonatomic, strong) NSArray *imagesArray;

@property (nonatomic, strong) NSMutableDictionary *dictM;

@end

@implementation LSBottomView

- (NSMutableDictionary *)dictM{
    if (!_dictM) {
        _dictM = [NSMutableDictionary dictionary];
    }
    return _dictM;
}


static NSString * cellID = @"cellID";


+ (void)load{
    [[LSImageTool sharedImageTool] reloadImagesFromLibrary];
}

#pragma mark - initial
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        
        [self addChildViews];
    }
    return self;
}

- (void)addChildViews
{
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:panGesture];
    
    UIButton * button = [[UIButton alloc] init];
    [self addSubview:button];
    self.button = button;
    [self.button setImage:[UIImage imageNamed:@"closed_background"] forState:UIControlStateNormal];
    self.button.bounds = CGRectMake(0, 0, 44, 44);
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout =flowLayout;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    UICollectionView * collectionV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self addSubview:collectionV];
    collectionV.delegate = self;
    collectionV.dataSource = self;
    self.collectionV = collectionV;
    [collectionV registerClass:[LSCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    
    self.imagesArray = [[LSImageTool sharedImageTool] imagesArray];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.button.center = CGPointMake(self.width * 0.5, 22);
    self.collectionV.frame = CGRectMake(0, 44, self.width, self.height - 44);
}


#pragma mark - Add GestureRecognizor
- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:self];
    
    CGFloat offsetY = point.y;
    
    CGRect frame = self.frame;
    frame.origin.y += offsetY;
    self.frame = frame;
    
    [pan setTranslation:CGPointZero inView:self];
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagesArray.count;
}

#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LSCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        cell.imageView.image = [UIImage imageNamed:@"rate_imgslelect_bg"];
    } else {
        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
        NSString * urlStr = self.imagesArray[indexPath.item];
        
        NSURL *url=[NSURL URLWithString:urlStr];
        [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
            UIImage *image=[UIImage imageWithCGImage:asset.thumbnail];
            cell.imageView.image=image;
        }failureBlock:^(NSError *error) {
            NSLog(@"error=%@",error);
        }];
    }
    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 60);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 13, 10, 13);
}


#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * noticeName = nil;
    if (indexPath.item == 0) {
        noticeName = kOpenCameraNotice;
    } else {
        LSCollectionViewCell * cell = (LSCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [self.dictM setObject:cell.imageView.image forKey:@"image"];
        noticeName = kOpenPhotoNotice;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:noticeName object:nil userInfo:self.dictM];
}

@end
