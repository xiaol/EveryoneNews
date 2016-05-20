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
    pod 'XLPagerTabStrip'
end
```



## Requirements

iOS 8.0+
Xcode 7.0 or above

## Finish
- [x] 主页框架的导入以及可行性预测
- [x] 完成 Swagger 数据请求
- [x] 完成 Realm 数据库的 Orm 可持久化操作
- [x] 完成频道管理页面的 移动 排序 删除等操作
- [x] 完成主页显示内容

## To Do

- [ ] 网络数据的请求模块的导入。使用`Swagger`
- [ ] 完成登录页面的 微信 qq 登陆。
- [ ] 商量一下是不是需要味了对Apple的思想，进行 UIFont的改版。
