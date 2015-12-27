//
//  LSGetImages.h
//  mogujie
//
//  Created by kevinlishuai on 15/11/17.
//  Copyright © 2015年 kevinlishuai. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Singleton.h"

@interface LSImageTool : NSObject

interfaceSingleton(ImageTool);

/** 图片数组 */
@property (nonatomic, strong) NSMutableArray *imagesArray;


- (void)reloadImagesFromLibrary;


@end
