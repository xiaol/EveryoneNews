# Journalism

Journalism 是 `奇点资讯` 的pro版本.

 [emiji](http://www.emoji-cheat-sheet.com/)

主要是会使用:

- `Realm` 进行数据持久化的操作。
- ~~`MVVM` 进行代码框架的编写~~ :arrow_right: 改用自己的了
- 希望可以使用到 `AsyncDisplayKit` 框架进行页面的搭建，但是估计可能可行性不大
- 尽量使用 `ReactiveCocoa` 进行变量的变化检测

## Power

````
platform :ios, '8.0'
use_frameworks!

target :'Journalism' do
    pod 'AFDateHelper'
    pod 'ObjectMapper'                                       ## 首选
    pod 'MJRefresh'                                          ## 刷新控件
    pod 'PINRemoteImage'                                     ## 图片缓存加载组件
    pod 'SwiftyJSON'                                         ## JSON 数据解析组件
    pod 'RealmSwift'                                         ## Realm ORM 持久化组件
    pod 'XLPagerTabStrip'                                    ## 滑动切换ViewController分页组件
    pod 'SwaggerClient', :path => 'swift-client/'            ## Swagger model Request组件
end
```



## Requirements

iOS 8.0+
Xcode 7.0 or above


## To Do

- [ ] 分享弹出式图的 文字大小改变
- [ ] 新闻列表第一次刷新的时候如果数据很多，删除至30个
- [ ] 每一次页面刷新的时候，现在是每次会判断之后刷洗。修改为每次都会刷新
- [ ] 尝试使用滑动来推出关注页面视图
- [ ] 完成数据的解析
- [ ] 等待借口的完善
- [ ] 梳理整体框架，完成视图的 冗余 精简化
