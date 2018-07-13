//
//  UIView+CCScreenShot.m
//  MyScreenShortDemo
//
//  Created by 蔡成汉 on 2018/7/10.
//  Copyright © 2018年 蔡成汉. All rights reserved.
//

#import "UIView+CCScreenShot.h"
#import <WebKit/WebKit.h>
#import <objc/runtime.h>

static char CCScreenShotCCIndicatorViewKey;


@interface UIView ()

@property (nonatomic, strong) UIActivityIndicatorView *screenShotIndicatorView;

@end


@implementation UIView (CCScreenShot)

- (UIImage *)screenShot {
    return [self _screenShotWithIndicator:NO];
}

- (UIImage *)screenShotWithIndicator {
    return [self _screenShotWithIndicator:YES];
}

- (UIImage *)_screenShotWithIndicator:(BOOL)indicator {
    __block UIImage *shotImage = nil;
    __block BOOL finish = NO;
    [self screenShotWithIndicator:indicator complete:^(UIImage *image) {
        shotImage = image;
        finish = YES;
    }];
    while (!finish) {
        [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return shotImage;
}

- (void)screenShot:(void(^)(UIImage *image))complete {
    [self screenShotWithIndicator:NO complete:complete];
}

- (void)screenShotWithIndicator:(void (^)(UIImage *))complete {
    [self screenShotWithIndicator:YES complete:complete];
}

- (void)screenShotWithIndicator:(BOOL)indicator complete:(void (^)(UIImage *))complete {
    if ([self isKindOfClass:[WKWebView class]] || [self isKindOfClass:[NSClassFromString(@"WKScrollView") class]]) {
        WKWebView *webView = (WKWebView *)self;
        if ([self isKindOfClass:[NSClassFromString(@"WKScrollView") class]]) {
            webView = (WKWebView *)self.superview;
        }
        [self screenWkWebViewShot:webView showIndicator:indicator complete:complete];
    } else if ([self isKindOfClass:[UIWebView class]] || [self isKindOfClass:[NSClassFromString(@"_UIWebViewScrollView") class]]) {
        UIWebView *webView = (UIWebView *)self;
        if ([self isKindOfClass:[NSClassFromString(@"_UIWebViewScrollView") class]]) {
            webView = (UIWebView *)self.superview;
        }
        [self screenWebViewShot:webView showIndicator:indicator complete:complete];
    } else if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        [self screenScrollViewShot:scrollView showIndicator:indicator complete:complete];
    } else {
        [self screenViewShot:indicator complete:complete];
    }
}

#pragma mark - private fun

- (void)startIndicator:(UIView *)view showIndicator:(BOOL)showIndicator {
    if (showIndicator) {
        if (!self.screenShotIndicatorView) {
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [view addSubview:indicatorView];
            self.screenShotIndicatorView = indicatorView;
        }
        self.screenShotIndicatorView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        [self.screenShotIndicatorView startAnimating];
    } else {
        [self stopIndicator];
    }
}

- (void)stopIndicator {
    if (self.screenShotIndicatorView) {
        [self.screenShotIndicatorView stopAnimating];
        [self.screenShotIndicatorView removeFromSuperview];
        self.screenShotIndicatorView = nil;
    }
}

- (void)screenWkWebViewShot:(WKWebView *)webView showIndicator:(BOOL)indicator complete:(void(^)(UIImage *image))complete {
    CGRect originRect = webView.frame;
    CGPoint originContentOffset = webView.scrollView.contentOffset;
    CGSize contentSize = webView.scrollView.contentSize;
    
    NSUInteger page = floor(contentSize.height/webView.bounds.size.height);
    NSTimeInterval expTime = log10(page);
    
    UIView *snapShotView = [webView snapshotViewAfterScreenUpdates:YES];
    snapShotView.frame = webView.frame;
    [webView.superview addSubview:snapShotView];
    [self startIndicator:snapShotView showIndicator:indicator];
    
    //重置frame - 若是自动布局，则无效
    webView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    webView.scrollView.contentOffset = CGPointZero;
    
    UIGraphicsBeginImageContextWithOptions(contentSize, NO, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(expTime* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [webView drawViewHierarchyInRect:CGRectMake(0, 0, contentSize.width, contentSize.height) afterScreenUpdates:YES];
        UIImage *shotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        webView.frame = originRect;
        webView.scrollView.contentOffset = originContentOffset;
        [snapShotView removeFromSuperview];
        [self stopIndicator];
        if (complete) {
            complete(shotImage);
        }
    });
}

- (void)screenWebViewShot:(UIWebView *)webView showIndicator:(BOOL)indicator complete:(void(^)(UIImage *image))complete {
    CGRect originRect = webView.frame;
    CGPoint originContentOffset = webView.scrollView.contentOffset;
    CGSize contentSize = webView.scrollView.contentSize;
    
    NSUInteger page = floor(contentSize.height/webView.bounds.size.height);
    NSTimeInterval expTime = log10(page);
    
    UIView *snapShotView = [webView snapshotViewAfterScreenUpdates:YES];
    snapShotView.frame = webView.frame;
    [webView.superview addSubview:snapShotView];
    [self startIndicator:snapShotView showIndicator:indicator];
    
    //重置frame - 若是自动布局，则无效
    webView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    webView.scrollView.contentOffset = CGPointZero;
    
    UIGraphicsBeginImageContextWithOptions(contentSize, NO, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(expTime* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [webView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *shotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        webView.frame = originRect;
        webView.scrollView.contentOffset = originContentOffset;
        [snapShotView removeFromSuperview];
        [self stopIndicator];
        if (complete) {
            complete(shotImage);
        }
    });
}

- (void)screenScrollViewShot:(UIScrollView *)scrollView showIndicator:(BOOL)indicator complete:(void(^)(UIImage *image))complete {
    CGRect originRect = scrollView.frame;
    CGPoint originContentOffset = scrollView.contentOffset;
    CGSize contentSize = scrollView.contentSize;
    
    NSUInteger page = floor(contentSize.height/scrollView.bounds.size.height);
    NSTimeInterval expTime = log10(page);
    
    UIView *snapShotView = [scrollView snapshotViewAfterScreenUpdates:YES];
    snapShotView.frame = scrollView.frame;
    [scrollView.superview addSubview:snapShotView];
    [self startIndicator:snapShotView showIndicator:indicator];
    
    CGSize contexSize = CGSizeMake(MAX(originRect.size.width, contentSize.width), MAX(originRect.size.height, contentSize.height));
    //重置frame - 若是自动布局，则无效
    scrollView.frame = CGRectMake(0, 0, contexSize.width, contexSize.height);
    scrollView.contentOffset = CGPointZero;
    
    UIGraphicsBeginImageContextWithOptions(contexSize, NO, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(expTime* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self containsWKWebView]) {
            [scrollView drawViewHierarchyInRect:CGRectMake(0, 0, contexSize.width, contexSize.height) afterScreenUpdates:YES];
        }else{
            [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
        }
        UIImage *shotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        scrollView.frame = originRect;
        scrollView.contentOffset = originContentOffset;
        [snapShotView removeFromSuperview];
        [self stopIndicator];
        if (complete) {
            complete(shotImage);
        }
    });
}

- (void)screenViewShot:(BOOL)indicator complete:(void(^)(UIImage *image))complete {
    [self startIndicator:self showIndicator:indicator];
    CGRect bounds = self.bounds;
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, -self.frame.origin.x, -self.frame.origin.y);
    if ([self containsWKWebView]) {
        [self drawViewHierarchyInRect:bounds afterScreenUpdates:YES];
    }else{
        [self.layer renderInContext:context];
    }
    UIImage *shotImage  = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    [self stopIndicator];
    if (complete) {
        complete(shotImage);
    }
}

/**
 是否包含wkWebView
 
 @return YES包含；NO不包含
 */
- (BOOL)containsWKWebView {
    if ([self isKindOfClass:[WKWebView class]]) {
        return YES;
    }
    for (UIView *tpView in self.subviews) {
        if ([tpView containsWKWebView]) {
            return YES;
        }
    }
    return NO;
}

- (void)setScreenShotIndicatorView:(UIActivityIndicatorView *)screenShotIndicatorView {
    objc_setAssociatedObject(self, &CCScreenShotCCIndicatorViewKey, screenShotIndicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView *)screenShotIndicatorView {
    return objc_getAssociatedObject(self, &CCScreenShotCCIndicatorViewKey);
}


@end
