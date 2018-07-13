//
//  ViewShotController.m
//  MyScreenShortDemo
//
//  Created by 蔡成汉 on 2018/7/12.
//  Copyright © 2018年 蔡成汉. All rights reserved.
//

#import "ViewShotController.h"
#import "ContentController.h"

@interface ViewShotController ()

@end

@implementation ViewShotController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"UIView截图";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *yellowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    yellowView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:yellowView];
    
    UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(100, 300, 200, 100)];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(rightBarItemIsTouch)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)rightBarItemIsTouch {
    __weak typeof(self) weakSelf = self;
    [self.view screenShot:^(UIImage *image) {
        ContentController *controller = [[ContentController alloc]init];
        controller.image = image;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
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
