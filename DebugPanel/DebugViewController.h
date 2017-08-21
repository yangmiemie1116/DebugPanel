//
//  DebugViewController.h
//  DebugPanel
//
//  Created by 杨志强 on 2017/8/21.
//  Copyright © 2017年 sheep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebugViewController : UIViewController
@property (nonatomic, copy) void(^onlineBlock)(NSString *domain);
@property (nonatomic, copy) void(^offlineBlock)(NSString *domain);
@property (nonatomic, copy) void(^readyBlock)(NSString *domain);
@property (nonatomic, copy) void(^closeBlock)();
@end
