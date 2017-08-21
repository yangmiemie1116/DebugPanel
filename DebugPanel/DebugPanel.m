//
//  DebugPanel.m
//  DebugPanel
//
//  Created by 杨志强 on 2017/8/21.
//  Copyright © 2017年 sheep. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DebugPanel.h"
#import "DebugViewController.h"
static NSInteger PanelWidth = 50;
@interface DebugPanel()
@property (nonatomic, strong) UIView *debugView;
@property (nonatomic, assign) CGPoint startPoint;
@end

@implementation DebugPanel
+ (void)load {
    [DebugPanel shareInstance];
}

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static DebugPanel *pannel;
    dispatch_once(&onceToken, ^{
        pannel = [[DebugPanel alloc] init];
    });
    return pannel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.debugView = [UIView new];
        self.debugView.backgroundColor = [UIColor blackColor];
        self.debugView.alpha = 0.1;
        self.debugView.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height-PanelWidth)/2, PanelWidth, PanelWidth);
        self.debugView.layer.cornerRadius = 8.0;
        self.debugView.layer.masksToBounds = YES;
        
        UILabel *dLab = [UILabel new];
        dLab.text = @"D";
        dLab.textColor = [UIColor whiteColor];
        dLab.font = [UIFont systemFontOfSize:20];
        dLab.textAlignment = NSTextAlignmentCenter;
        dLab.frame = CGRectMake(0, 0, PanelWidth, PanelWidth);
        [self.debugView addSubview:dLab];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeKeyWindow) name:UIWindowDidBecomeKeyNotification object:nil];
    }
    return self;
}

- (void)didBecomeKeyWindow {
    [[UIApplication sharedApplication].keyWindow addSubview:self.debugView];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes:)];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognize)];
    [self.debugView addGestureRecognizer:tapGes];
    [self.debugView addGestureRecognizer:pan];
    [tapGes requireGestureRecognizerToFail:pan];
}

- (void)tapRecognize {
    self.debugView.alpha = 0;
    DebugViewController *debugCtr = [DebugViewController new];
    __weak DebugPanel *weakSelf = self;
    debugCtr.closeBlock = ^{
        weakSelf.debugView.alpha = 0.1;
    };
    debugCtr.onlineBlock = ^(NSString *domain) {
        weakSelf.debugDomain = domain;
    };
    debugCtr.offlineBlock = ^(NSString *domain) {
        weakSelf.debugDomain = domain;
    };
    debugCtr.readyBlock = ^(NSString *domain) {
        weakSelf.debugDomain = domain;
    };
    UINavigationController *naviCtr = [[UINavigationController alloc] initWithRootViewController:debugCtr];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:naviCtr animated:YES completion:nil];
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