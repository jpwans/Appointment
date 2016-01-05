//
//  Header.h
//  Appointment
//
//  Created by Pellet Mo on 15/12/22.
//  Copyright (c) 2015年 mopellet. All rights reserved.
//

#ifndef Appointment_Header_h
#define Appointment_Header_h

//                              _oo0oo_
//                             o8888888o
//                             88" . "88
//                             (| -_- |)
//                             0\  =  /0
//                           ___/'—'\___
//                        .' \\\|     |// '.
//                       / \\\|||  :  |||// \\
//                      / _ ||||| -:- |||||- \\
//                      | |  \\\\  -  /// |   |
//                      | \_|  ''\—/''  |_/ |
//                      \  .-\__  '-'  __/-.  /
//                    ___'. .'  /—.—\  '. .'___
//                 ."" '<  '.___\_<|>_/___.' >'  "".
//                | | : '-  \'.;'\ _ /';.'/ - ' : | |
//                \  \ '_.   \_ __\ /__ _/   .-' /  /
//            ====='-.____'.___ \_____/___.-'____.-'=====
//                              '=—='
//
//          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//
//                  佛祖保佑                 永无BUG


/**
 * 会自动重定向到login页面
 */
#define URL_Main @"http://mzxjnt.people.com.cn/jnt/web/ticket/queryGroupTicketBook.action"

/**
 * 登陆
 */
#define URL_Login @"http://mzxjnt.people.com.cn/jnt/web/user/login.action"

/**
 * 预约
 */
#define URL_TicketTask @"http://mzxjnt.people.com.cn/jnt/web/ticket/insertGroupTicket.action"
/**
 * 取消预约
 */
#define URL_Cancel @"http://mzxjnt.people.com.cn/jnt/web/ticket/cancelGroupTicket.action"
// id	246591

/**
 * 查看预约信息
 */
#define URL_viewTicket @"http://mzxjnt.people.com.cn/jnt/web/ticket/myGroupTicket.action"


#define VisitDate @"groupTicket.visitDate"
#define VisitTimeStart @"groupTicket.visitTimeStart"
#define VisitTimeEnd @"groupTicket.visitTimeEnd"
#define PersonCount @"groupTicket.expectPersonCount"
#define SecondCountKey @"groupTicket.secondCount"


#define Noti_SendValue @"SendValue"
#define Noti_ReloadTable @"ReloadTable"






#endif
