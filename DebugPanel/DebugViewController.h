//
//  DebugViewController.h
//  DebugPanel
//
//  Created by sheep on 2017/8/21.
//  Copyright © 2017年 sheep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebugViewController : UIViewController
@property (nonatomic, copy) void(^closeBlock)();
/**
 环境切换
 */
@property (nonatomic, copy) void(^httpChanged)(NSString *domain);
/**
 预生产环境域名
 */
@property (nonatomic, copy) NSString *readyDomain;

/**
 生产环境域名
 */
@property (nonatomic, copy) NSString *onlineDomain;

/**
 测试环境域名
 */
@property (nonatomic, copy) NSString *offlineDomain;
@end
