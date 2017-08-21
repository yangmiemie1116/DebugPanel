//
//  DebugViewController.m
//  DebugPanel
//
//  Created by sheep on 2017/8/21.
//  Copyright © 2017年 sheep. All rights reserved.
//

#import "DebugViewController.h"
@interface DebugViewController ()
@property (nonatomic, strong) UITextField *onlineTextField;
@property (nonatomic, strong) UITextField *offlineTextField;
@property (nonatomic, strong) UITextField *readyTextField;
@property (nonatomic, strong) UILabel *toastLab;
@end

@implementation DebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"切换环境";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonDown)];
    [self p_setupTextField];
    [self p_setupToast];
}

- (void)p_setupTextField {
    UILabel *onlineLab = [UILabel new];
    onlineLab.text = @"生产环境";
    onlineLab.frame = CGRectMake(10, 80, 80, 30);
    onlineLab.textColor = [UIColor blackColor];
    onlineLab.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:onlineLab];
    
    self.onlineTextField = [[UITextField alloc] init];
    self.onlineTextField.keyboardType = UIKeyboardTypeURL;
    self.onlineTextField.frame = CGRectMake(100, 80, [UIScreen mainScreen].bounds.size.width-120, 30);
    self.onlineTextField.font = [UIFont systemFontOfSize:16];
    self.onlineTextField.textColor = [UIColor blackColor];
    self.onlineTextField.layer.borderWidth = 1.0;
    self.onlineTextField.text = self.onlineDomain;
    self.onlineTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:self.onlineTextField];
    
    UILabel *offlineLab = [UILabel new];
    offlineLab.text = @"测试环境";
    offlineLab.frame = CGRectMake(10, 120, 80, 30);
    offlineLab.textColor = [UIColor blackColor];
    offlineLab.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:offlineLab];
    self.offlineTextField = [[UITextField alloc] init];
    self.offlineTextField.keyboardType = UIKeyboardTypeURL;
    self.offlineTextField.frame = CGRectMake(100, 120, [UIScreen mainScreen].bounds.size.width-120, 30);
    self.offlineTextField.font = [UIFont systemFontOfSize:16];
    self.offlineTextField.textColor = [UIColor blackColor];
    self.offlineTextField.layer.borderWidth = 1.0;
    self.offlineTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.offlineTextField.text = self.offlineDomain;
    [self.view addSubview:self.offlineTextField];
    
    UILabel *readyLab = [UILabel new];
    readyLab.text = @"预生产环境";
    readyLab.frame = CGRectMake(10, 160, 85, 30);
    readyLab.textColor = [UIColor blackColor];
    readyLab.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:readyLab];
    self.readyTextField = [[UITextField alloc] init];
    self.readyTextField.keyboardType = UIKeyboardTypeURL;
    self.readyTextField.frame = CGRectMake(100, 160, [UIScreen mainScreen].bounds.size.width-120, 30);
    self.readyTextField.font = [UIFont systemFontOfSize:16];
    self.readyTextField.textColor = [UIColor blackColor];
    self.readyTextField.layer.borderWidth = 1.0;
    self.readyTextField.text = self.readyDomain;
    self.readyTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:self.readyTextField];
    
    
    UIButton *onlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    onlineButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 250, 100, 40);
    [onlineButton setTitle:@"一键正式" forState:UIControlStateNormal];
    onlineButton.backgroundColor = [UIColor lightGrayColor];
    [onlineButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:onlineButton];
    [onlineButton addTarget:self action:@selector(onlineButtonDown) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *offlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    offlineButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 310, 100, 40);
    [offlineButton setTitle:@"一键测试" forState:UIControlStateNormal];
    [offlineButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    offlineButton.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:offlineButton];
    [offlineButton addTarget:self action:@selector(offlineButtonDown) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *readyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    readyButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 370, 100, 40);
    [readyButton setTitle:@"一键预生产" forState:UIControlStateNormal];
    readyButton.backgroundColor = [UIColor lightGrayColor];
    [readyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:readyButton];
    [readyButton addTarget:self action:@selector(readyButtonDown) forControlEvents:UIControlEventTouchUpInside];
}

- (void)p_setupToast {
    self.toastLab = [UILabel new];
    self.toastLab.text = @"切换成功";
    self.toastLab.font = [UIFont systemFontOfSize:15];
    self.toastLab.textColor = [UIColor blackColor];
    [self.view addSubview:self.toastLab];
    self.toastLab.backgroundColor = [UIColor grayColor];
    self.toastLab.layer.masksToBounds = YES;
    self.toastLab.layer.cornerRadius = 6.0;
    self.toastLab.textAlignment = NSTextAlignmentCenter;
    self.toastLab.frame = CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height-100, 100, 30);
    self.toastLab.alpha = 0;
}

- (void)closeButtonDown {
    if (self.closeBlock) {
        self.closeBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onlineButtonDown {
    [self toast];
    if (self.httpChanged) {
        self.httpChanged([self.onlineTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
    }
}

- (void)offlineButtonDown {
    [self toast];
    if (self.httpChanged) {
        self.httpChanged([self.offlineTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
    }
}

- (void)readyButtonDown {
    [self toast];
    if (self.httpChanged) {
        self.httpChanged([self.readyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
    }
}

- (void)toast {
    self.toastLab.alpha = 1.0;
    [UIView animateWithDuration:0.3 delay:1.2 options:UIViewAnimationOptionCurveLinear animations:^{
        self.toastLab.alpha = 0;
    } completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
