# Appointment
人民大会堂抢预约
====  

一、本项目所使用第三方
------- 
  1、CocoaPods安装 [AFNetworking](https://github.com/AFNetworking/AFNetworking) 
  ```ruby
  source 'https://github.com/CocoaPods/Specs.git'
  platform :ios, '8.0'
  pod 'AFNetworking', '~> 3.0'
  ```
  2、添加自定义的 MBProgressHUD（参考[MBProgressHUD](https://github.com/jdg/MBProgressHUD),本项目中所用在MBProgressHUD文件夹里面）

二、具体思路
------- 
  1、预约流程：登陆->预约1->预约2->删除cookie。在ios应用程序中，一个应用程序只有一个共享cookie的保存区域。所以不能用异步多线   程，可以用同步单线程（运用递归，或者在越狱的设备也可以用多进程的方法）
      2、保存账号信息等参数在偏好设置里面（避免每次都要）
  
  

