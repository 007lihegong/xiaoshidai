//
//  WKWebViewController.m
//  xiaoshidai
//
//  Created by XSD on 2016/11/24.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "WKWebViewController.h"
static NSString *IPURL = @"http://ios.wecash.net/wep/simple_h5.html?version=h5&channelId=3791&channelCode=11422a";

@interface WKWebViewController ()<WKUIDelegate,WKNavigationDelegate>{
    MBProgressHUD *_hud;
}
@property (nonatomic) WKWebView *webView;
// 设置加载进度条
@property(nonatomic,strong) UIProgressView *  ProgressView;
@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:MyBlueColor];
    [self initNavigation];
    [self initView];
}
-(void)initNavigation{
    
    self.navigationItem.title = LocalizationNotNeeded(@"闪银");
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title =@"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [self setBack:@""];
    
    self.navigationController.navigationBar.backItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont systemFontSize]],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
- (void)initView{
    _hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    //self.navigationController.navigationBar.hidden = YES;
    [self webView];
    [_hud show:YES];
    _hud.dimBackground = YES;
    _hud.labelText = @"加载中...";
    [_hud hide:YES afterDelay:1.0];

    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",IPURL]]]];
    // 创建进度条
    if (!self.ProgressView) {
        self.ProgressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.ProgressView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 3.0);
        // 设置进度条的色彩
        [self.ProgressView setTrackTintColor:[UIColor clearColor]];
        self.ProgressView.progressTintColor = [UIColor redColor];
        [self.view addSubview:self.ProgressView];
    }
    
    
}
- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)configuration:configuration];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.bounces = NO;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        _webView.allowsBackForwardNavigationGestures = YES;
        // 设置 可以前进 和 后退
        [self.view addSubview:_webView];
    }
    return _webView;
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    

    self.ProgressView.hidden = NO;
    NSLog(@"页面开始加载时调用");
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"当内容开始返回时调用");
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //_hud.labelText = @"加载完成";
    //[_hud hide:YES afterDelay:1.0];
    self.navigationItem.title = webView.title;
    NSLog(@"页面加载完成之后调用 webView.URL %@",webView.URL);
    
}
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    if (navigationAction.navigationType==WKNavigationTypeBackForward) {                  //判断是返回类型
        
        if (webView.backForwardList.backList.count>0) {                                  //得到栈里面的list
            for (WKBackForwardListItem * backItem in webView.backForwardList.backList) { //循环遍历，得到你想退出到
                //添加判断条件
                if(![backItem.title isEqualToString:@"闪银"]){
                    [webView goToBackForwardListItem:[webView.backForwardList.backList firstObject]];
                }
            }
        }
    }
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)backAction{
    //NSString * str = [NSString stringWithFormat:@"%@",_webView.URL.absoluteString];
    if (![_webView canGoBack]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [_webView goBack];
    }
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"页面加载失败时调用");
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    // 首先，判断是哪个路径
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        // 判断是哪个对象
        if (object == self.webView) {
            NSLog(@"进度信息：%lf",self.webView.estimatedProgress);
            if (self.webView.estimatedProgress == 1.0) {
                //隐藏
                self.ProgressView.hidden = YES;
            }else{
                // 添加进度数值
                self.ProgressView.progress = self.webView.estimatedProgress;
            }
        }
    }
}
- (void)didReceiveMemoryWarning {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    NSLog(@"%s",__func__);
   // [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}


@end
