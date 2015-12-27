//
//  LSGetImages.m
//  mogujie
//
//  Created by kevinlishuai on 15/11/17.
//  Copyright © 2015年 kevinlishuai. All rights reserved.
//

#import "LSImageTool.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface LSImageTool ()

@end

@implementation LSImageTool

implementationSingleton(ImageTool)


- (void)reloadImagesFromLibrary
{
    
    
    self.imagesArray = [[NSMutableArray alloc] init];
    
    __block NSMutableArray * array = self.imagesArray;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
            ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
                NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
                if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                    NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
                }else{
                    NSLog(@"相册访问失败.");
                }
            };
            
            ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
                if (result!=NULL) {
                    
                    if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                        
                        NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                        [array addObject:urlstr];
                    }

                }
                
            };
            
            ALAssetsLibraryGroupsEnumerationResultsBlock libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
                
                if (group == nil)
                {
                    
                }
                
                if (group!=nil) {
                    NSString *g=[NSString stringWithFormat:@"%@",group];//获取相簿的组
                    
                    NSString *g1=[g substringFromIndex:16 ] ;
                    NSArray *arr=[[NSArray alloc] init];
                    arr=[g1 componentsSeparatedByString:@","];
                    NSString *g2=[[arr objectAtIndex:0] substringFromIndex:5];
                    if ([g2 isEqualToString:@"Camera Roll"]) {
                        g2=@"相机胶卷";
                    }
//                    NSString *groupName=g2;//组的name
                    
                    [group enumerateAssetsUsingBlock:groupEnumerAtion];
                }
                
            };
            
            ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
            [library enumerateGroupsWithTypes:ALAssetsGroupAll
                                   usingBlock:libraryGroupsEnumeration
                                 failureBlock:failureblock];
        
    });

}


@end
