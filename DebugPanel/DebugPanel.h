//
//  DebugPanel.h
//  DebugPanel
//
//  Created by sheep on 2017/8/21.
//  Copyright © 2017年 sheep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DebugPanel : NSObject
+ (instancetype)shareInstance;

/**
 最终使用的域名
 */
@property (nonatomic, copy, readonly) NSString *useDomain;

/**
 生产环境域名
 */
@property (nonatomic, copy) NSString *onlineDomain;

/**
 测试环境域名
 */
@property (nonatomic, copy) NSString *offlineDomain;

/**
 预生产环境域名
 */
@property (nonatomic, copy) NSString *readyDomain;

/**
 环境切换成功的回调
 */
@property (nonatomic, copy) void(^httpChanged)(NSString *domain);
@end
