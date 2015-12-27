//
//  LSContextTransitioning.m
//  mogujie
//
//  Created by kevinlishuai on 15/12/3.
//  Copyright © 2015年 kevinlishuai. All rights reserved.
//

#import "LSContextTransitioning.h"

#import "LSNavController.h"

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height
#define coverSize 30


@implementation LSContextTransitioning

implementationSingleton(ContextTransitioning);

#pragma mark - UIViewControllerAnimatedTransitioning
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
    /*
     *  关于这个参数transitionContext, 该参数是一个实现了UIViewControllerContextTransitioning 让我们访问一些实现过渡所必须的对象
     */
    
    /*
     * containerView 转场动画发生的容器
     */
    UIView * containerView = [transitionContext containerView];
    
    /**
     *  viewControllerForKey 方法获取过渡中的两个controller
     */
    UIViewController * fromVc = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVc = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * fromV = fromVc.view;
    UIView * toV = toVc.view;
    
    /**
     *  通过这两个方法，可以获得过渡动画前后两个ViewController的frame
     *  initialFrameForViewController:
     *  finalFrameForViewController:
     */
    CGRect rect = [transitionContext finalFrameForViewController:toVc];
    
    if (![toVc isKindOfClass:[LSNavController class]]) {
        [containerView addSubview:fromVc.view];
        [containerView addSubview:toVc.view];
        // 设置初始状态
        fromV.alpha = 1;
        // 动画过渡到最终状态
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromV.alpha = 0;
            toV.alpha = 1;
        } completion:^(BOOL finished) {
            // 在这里需要对进行过属性设置的内容进行复原
            [transitionContext completeTransition:YES];
        }];
        
    } else {
        UIView * coverView = [[UIView alloc] initWithFrame:CGRectMake(0,0, coverSize, coverSize)];
        coverView.backgroundColor = [UIColor colorWithRed:255/255.0 green:55/255.0 blue:131/255.0 alpha:0.9];
        coverView.center = CGPointMake(screenW * 0.5, rect.size.height);
        [coverView.layer setValue:@(coverSize*0.5) forKey:@"cornerRadius"];
        coverView.layer.masksToBounds = YES;
        [containerView addSubview:toV];
        [containerView addSubview:coverView];
        
        toV.alpha = 0;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] * 2 animations:^{
            [coverView.layer setValue:@60 forKeyPath:@"transform.scale"];
            fromV.alpha = 0;
            toV.alpha = 0.3;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1.0 animations:^{
                toV.alpha = 1;
                coverView.alpha = 0;
            }completion:^(BOOL finished) {
                [coverView removeFromSuperview];
                [transitionContext completeTransition:YES];
            }];
        }];
    }
    
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}


@end
