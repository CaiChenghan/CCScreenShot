//
//  WebViewShotController.m
//  MyScreenShortDemo
//
//  Created by 蔡成汉 on 2018/7/12.
//  Copyright © 2018年 蔡成汉. All rights reserved.
//

#import "WebViewShotController.h"
#import "ContentController.h"

@interface WebViewShotController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WebViewShotController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"UIWebView截图";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [self.webView loadRequest:request];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(rightBarItemIsTouch)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)rightBarItemIsTouch {
    __weak typeof(self) weakSelf = self;
    [self.webView screenShotWithIndicator:^(UIImage *image) {
        ContentController *controller = [[ContentController alloc]init];
        controller.image = image;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
