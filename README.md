# Appointment
人民大会堂抢预约
====

## 联系方式 
* Email:351420450@qq.com
* WeChat:wzw351420450 
* 欢迎大家与我一起学习进步

## 项目目录
* [Appointment](https://github.com/MoPellet/Appointment)
* [MOMenuView](https://github.com/MoPellet/MOMenuView)





一、项目相关
------- 
  * CocoaPods安装 [AFNetworking](https://github.com/AFNetworking/AFNetworking) 
  * 添加自定义的 MBProgressHUD（参考[MBProgressHUD](https://github.com/jdg/MBProgressHUD),本项目中所用在MBProgressHUD文件夹里面）
  * [预约网站](http://mzxjnt.people.com.cn/jnt/web/user/UserLogin.jsp)

二、具体思路
------- 
* 保存账号信息等参数在偏好设置里面（避免每次都要）
* 预约流程：登陆->预约1->预约2->删除cookie。在ios应用程序中，一个应用程序只有一个共享cookie的保存区域。所以不能用异步多线程，可以用同步单线程（运用递归，或者在越狱的设   备也可以用多进程的方法）

三、功能（仅预约，每个账号每天只能成功预约2次）
-------  
* 单任务
* 批量任务
* 定时任务

四、部分截图
------- 
* 扫描二维码下载 密码:xinhuoyouxi ![](https://github.com/MoPellet/Appointment/raw/master/screenshots/5.png)
* 可预约状态截图 ![](https://github.com/MoPellet/Appointment/raw/master/screenshots/2.jpg) 
* 预约成功列表截图 ![](https://github.com/MoPellet/Appointment/raw/master/screenshots/1.jpg) 
* 预约失败截图 ![](https://github.com/MoPellet/Appointment/raw/master/screenshots/3.jpg) 
* 预约主界面（demo版） ![](https://github.com/MoPellet/Appointment/raw/master/screenshots/4.png) 
