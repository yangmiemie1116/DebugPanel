//
//  DebugPanel.m
//  DebugPanel
//
//  Created by sheep on 2017/8/21.
//  Copyright © 2017年 sheep. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DebugPanel.h"
#import "DebugViewController.h"
static NSInteger PanelWidth = 50;
@interface DebugPanel()
@property (nonatomic, strong) UIView *debugView;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, copy, readwrite) NSString *useDomain;
@end

@implementation DebugPanel

+ (void)load {
    [DebugPanel shareInstance];
}

+ (instancetype)shareInstance
{
#ifdef DEBUG
    static dispatch_once_t onceToken;
    static DebugPanel *pannel;
    dispatch_once(&onceToken, ^{
        pannel = [[DebugPanel alloc] init];
    });
    return pannel;
#endif
    return nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.debugView = [UIView new];
        self.debugView.backgroundColor = [UIColor blackColor];
        self.debugView.alpha = 0.1;
        self.debugView.frame = CGRectMake(0, 0, PanelWidth, PanelWidth);
        self.debugView.layer.cornerRadius = 8.0;
        self.debugView.layer.masksToBounds = YES;
        
        UILabel *dLab = [UILabel new];
        dLab.text = @"D";
        dLab.textColor = [UIColor orangeColor];
        dLab.font = [UIFont systemFontOfSize:25];
        dLab.textAlignment = NSTextAlignmentCenter;
        dLab.frame = CGRectMake(0, 0, PanelWidth, PanelWidth);
        [self.debugView addSubview:dLab];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeKeyWindow) name:UIWindowDidBecomeKeyNotification object:nil];
    }
    return self;
}

- (NSString*)useDomain {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"useDomain"];
}

- (void)setUseDomain:(NSString *)useDomain {
    [[NSUserDefaults standardUserDefaults] setObject:useDomain forKey:@"useDomain"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didBecomeKeyWindow {
    [[UIApplication sharedApplication].keyWindow addSubview:self.debugView];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes:)];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognize)];
    [self.debugView addGestureRecognizer:tapGes];
    [self.debugView addGestureRecognizer:pan];
    [tapGes requireGestureRecognizerToFail:pan];
    
    UITapGestureRecognizer *tapWindow = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWindowGes)];
    tapWindow.numberOfTapsRequired = 3;
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:tapWindow];
}

- (UIViewController *)topViewController {
    return [self p_topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)p_topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self p_topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self p_topViewControllerWithRootViewController:navigationController.topViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self p_topViewControllerWithRootViewController:presentedViewController];
    } else {
        if ([rootViewController.parentViewController isKindOfClass:[UINavigationController class]]) {
            return rootViewController;
        }
        return nil;
    }
}

- (void)tapWindowGes {
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.debugView];
}

- (void)tapRecognize {
    self.debugView.alpha = 0;
    DebugViewController *debugCtr = [DebugViewController new];
    debugCtr.offlineDomain = self.offlineDomain;
    debugCtr.onlineDomain = self.onlineDomain;
    debugCtr.readyDomain = self.readyDomain;
    __weak DebugPanel *weakSelf = self;
    debugCtr.closeBlock = ^{
        weakSelf.debugView.alpha = 0.1;
    };
    debugCtr.httpChanged = ^(NSString *domain) {
        weakSelf.useDomain = domain;
        if (weakSelf.httpChanged) {
            weakSelf.httpChanged(domain);
        }
    };
    UINavigationController *naviCtr = [[UINavigationController alloc] initWithRootViewController:debugCtr];
    [[self topViewController] presentViewController:naviCtr animated:YES completion:nil];
}

- (void)panGes:(UIPanGestureRecognizer*)ges {
    UIView *gesView = ges.view;
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.startPoint = self.debugView.frame.origin;
            self.debugView.alpha = 0.6;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint location = [ges translationInView:gesView];
            CGFloat y = self.startPoint.y + location.y;
            CGFloat x = self.startPoint.x + location.x;
            if (x < 0) {
                x = 0;
            }
            if (x > ([UIScreen mainScreen].bounds.size.width - PanelWidth)) {
                x = [UIScreen mainScreen].bounds.size.width - PanelWidth;
            }
            if (y < 0) {
                y = 0;
            }
            if (y > ([UIScreen mainScreen].bounds.size.height - PanelWidth)) {
                y = [UIScreen mainScreen].bounds.size.height - PanelWidth;
            }
            self.debugView.frame = CGRectMake(x, y, PanelWidth, PanelWidth);
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            self.debugView.alpha = 0.2;
            CGPoint origin = self.debugView.frame.origin;
            if (origin.x >= ([UIScreen mainScreen].bounds.size.width-PanelWidth)/2) {
                origin.x = [UIScreen mainScreen].bounds.size.width-PanelWidth;
            }
            if (origin.x < ([UIScreen mainScreen].bounds.size.width-PanelWidth)/2) {
                origin.x = 0;
            }
            [UIView animateWithDuration:0.2 animations:^{
                self.debugView.frame = CGRectMake(origin.x, origin.y, self.debugView.frame.size.width, self.debugView.frame.size.height);
            }];
        }
            break;
        default:
            break;
    }
}

@end
