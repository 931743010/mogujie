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

@interface LSBannerViewController ()

@property (nonatomic, strong) NSArray *array;

@end

@implementation LSBannerViewController

- (NSArray *)array
{
    if (!_array) {
        _array = [LSModel mj_objectArrayWithFilename:@"images.plist"];;
    }
    return _array;
}

static NSString * const reuseIdentifier = @"bannerCell";


- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.contentSize = CGSizeMake(screenW * self.array.count, 0);
    self.collectionView.pagingEnabled = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LSBannerCell class])bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LSBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.model = self.array[indexPath.item];
    
    return cell;
}



@end
