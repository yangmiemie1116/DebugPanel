# DebugPanel
http请求的环境切换工具，用于切换生产环境，测试环境，预生产环境，**仅在DEBUG模式下有效**，当你看不到这个按钮的时候连续点击屏幕三下，他就出现了
# 安装
pod 'DebugPanel'

# 使用
```
[DebugPanel shareInstance].httpChanged = ^(NSString *domain) {
    //环境切换成功后的回调
};
    //可选
[DebugPanel shareInstance].offlineDomain = @"http://xxx.com";
[DebugPanel shareInstance].onlineDomain = @"http://xxx.com";
```
切换成功后 `[DebugPanel shareInstance].useDomain`就是当前使用的http地址
