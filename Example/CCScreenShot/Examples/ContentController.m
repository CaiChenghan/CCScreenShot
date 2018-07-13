//
//  ContentController.m
//  MyScreenShortDemo
//
//  Created by 蔡成汉 on 2018/7/12.
//  Copyright © 2018年 蔡成汉. All rights reserved.
//

#import "ContentController.h"
#import <CRToast/CRToast.h>

@interface ContentController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"结果展示";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    CGRect imageRect = self.view.bounds;
    if (self.image) {
        imageRect = CGRectMake(0, 0, MAX(self.scrollView.frame.size.width, self.image.size.width), MAX(self.scrollView.frame.size.height, self.image.size.height));
    }
    self.imageView.frame = imageRect;
    self.scrollView.contentSize = imageRect.size;
    
    if (self.image && self.image.size.height > 7500) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showToast:@"图片过长，可能无法加载"];
        });
    }
}

- (void)showToast:(NSString *)string {
    BOOL isShowing = [CRToastManager isShowingNotification];
    if (!isShowing)
    {
        NSDictionary *options = @{
                                  kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                                  kCRToastTextKey : string,
                                  kCRToastFontKey : [UIFont boldSystemFontOfSize:19],
                                  kCRToastTextColorKey : [UIColor whiteColor],
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : [UIColor colorWithRed:255.0/255.0 green:116.0/255.0 blue:1.0/255.0 alpha:1],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                                  kCRToastTimeIntervalKey : @(1)
                                  };
        [CRToastManager showNotificationWithOptions:options
                                    completionBlock:^{
                                        NSLog(@"Completed");
                                    }];
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = _image;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.alwaysBounceVertical = YES;
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
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
