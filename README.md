# CCScreenShot

[![CI Status](https://img.shields.io/travis/1178752402@qq.com/CCScreenShot.svg?style=flat)](https://travis-ci.org/1178752402@qq.com/CCScreenShot)
[![Version](https://img.shields.io/cocoapods/v/CCScreenShot.svg?style=flat)](https://cocoapods.org/pods/CCScreenShot)
[![License](https://img.shields.io/cocoapods/l/CCScreenShot.svg?style=flat)](https://cocoapods.org/pods/CCScreenShot)
[![Platform](https://img.shields.io/cocoapods/p/CCScreenShot.svg?style=flat)](https://cocoapods.org/pods/CCScreenShot)

## 使用
方法如下，可直接返回截图图片，或者使用block回调。
``` 
- (UIImage *)screenShot;
- (UIImage *)screenShotWithIndicator;
- (void)screenShot:(void(^)(UIImage *image))complete;
- (void)screenShotWithIndicator:(void(^)(UIImage *image))complete;
```

## 安装

支持 [CocoaPods](https://cocoapods.org) 安装

```ruby
pod 'CCScreenShot', '~>0.0.1'
```

## 证书

CCScreenShot is available under the MIT license. See the LICENSE file for more info.


## 更新说明
- 0.1.0 CCScreenShot构建。

## 补充

- 屏幕截图，支持UIView、UIScrollView、UITableView、UIWebView、WKWebView等。
- 前提条件是目标View需使用frame布局，因为里面有重置目标View的frame。若使用Autolayout布局，但仍想使用截图功能，则需要修改源码里重置frame的代码（注释行代码），改用autolayout重置frame。
- 没有做大规模测试。

