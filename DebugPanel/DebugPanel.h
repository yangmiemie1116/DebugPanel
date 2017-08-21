//
//  DebugPanel.h
//  DebugPanel
//
//  Created by 杨志强 on 2017/8/21.
//  Copyright © 2017年 sheep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DebugPanel : NSObject
+ (instancetype)shareInstance;
@property (nonatomic, copy) NSString *debugDomain;
@end
