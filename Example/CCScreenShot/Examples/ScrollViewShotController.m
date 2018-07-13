//
//  ScrollViewShotController.m
//  MyScreenShortDemo
//
//  Created by 蔡成汉 on 2018/7/12.
//  Copyright © 2018年 蔡成汉. All rights reserved.
//

#import "ScrollViewShotController.h"
#import "ContentController.h"

@interface ScrollViewShotController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ScrollViewShotController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"UIScrollView截图";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    UIView *yellowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    yellowView.backgroundColor = [UIColor yellowColor];
    [self.scrollView addSubview:yellowView];
    
    UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(100, 300, 200, 100)];
    redView.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:redView];
    
    UIView *blueView = [[UIView alloc]initWithFrame:CGRectMake(250, 500, 200, 400)];
    blueView.backgroundColor = [UIColor blueColor];
    [self.scrollView addSubview:blueView];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(rightBarItemIsTouch)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)rightBarItemIsTouch {
    __weak typeof(self) weakSelf = self;
    [self.scrollView screenShot:^(UIImage *image) {
        ContentController *controller = [[ContentController alloc]init];
        controller.image = image;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*1.5, self.view.bounds.size.height*1.5);
    }
    return _scrollView;
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
