# OddityOcUI

## What is it?

OddityOcUI 是IOS的一个新闻继承框架，可以在很短时间之内完成应用内的新闻框架的植入，让用户完成新闻浏览，查看，以及后台服务器基于用户观看喜好的所推荐的新闻    
现在我们也进行了一些不同新闻的扩展，对于用户的喜好，会推送相对应的新闻，实时热门新闻也会第一时间呈现，对于喜欢观看视频的用户我们也进行了相对应的升级，让用户有更多的选择，保证用户停留时长

------------------------

## How To Get Started

------------------------

>ps: 虽然我们的SDK支持Cocoapods导入，但是由于我们并没有上传到实际的Cocoapods Repos中。所以使用的时候需要使用开发模式本地导入

1. 下载我们的`OddityOcUI`的资源，包含`Classes`文件夹和`OddityOcUI.podspec`配置文件
2. 将资源文件放置到 项目的根目录下    
类似于这样子的一个类型    
````
┌----Classes
├----OddityOcUI.podspec
├----OcExample
├----OcExample.xcodeproj
├----OcExample.xcworkspace
├----Example
└----More Your Other files
````
3. 编辑`Podfile`文件  
4. 完成`pod install`

## install

````Ruby
platform :ios, '8.0'
use_frameworks!

target :'Example' do
    pod 'OddityUI', :path => './'     ## MGTemplateEngine组件
end
````

## Use

````objective-c
#import "AppDelegate.h"
#import <OddityOcUI/OddityOcUI-umbrella.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.window.rootViewController = [[MainNavigationController alloc] initWithRootViewController:[[LPHomeViewController alloc] init]];

    return YES;
}
````

## Some problems encountered

在配置的时候会遇到一些问题

### Status Bar

如果你的项目是LightBar那么在导入我们的sdk之后就会出现这个Bar颜色的问题。    
这个时候你需要修改的你的`Info.plist`文件添加 `View controller-based status bar appearance`为True，默认为false     
之后就StatusBar就正常了

### 接口调用
文件路径  OCExample/LPNewsSDK/LPHomeViewController+LPNewsSDKHomeList.m
@implementation LPHomeViewController (LPNewsSDKHomeList)

// 首页滑动时调用
- (void)homeListDidScroll {
NSLog(@"首页滑动");
}

// 进入详情页
- (void)pushDetailViewController {
NSLog(@"进入详情页");
}

// 切换频道
- (void)switchChannel {
NSLog(@"切换频道栏");
}
 

@end



