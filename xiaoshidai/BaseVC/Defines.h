//
//  Defines.h
//  框架一
//
//  Created by Apple on 15/12/16.
//
//

//--------------------------------------   框架初定义   --------------------------------------------------------------//

#ifndef Defines_h
#define Defines_h
//测试
//http://market.jql.cc
//http://192.168.1.188/market.jql.cc
//正式
//http://server.xsdai.net
#define IS_CESHI 0
#define IS_TEST_PAY 0

#if IS_CESHI
#if IS_TEST_PAY
#define IP @"http://testserver.xsdstore.com"//测试IP
#else
#define IP @"http://market.jql.cc"//测试IP
#endif
#else
#define IP @"http://server.xsdstore.com"//正式IP
#endif

#define IMAGES @"http://qw.coolmoban.com/Public/images/"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define MY_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
#define SDKLV [[[UIDevice currentDevice] systemVersion] floatValue]
//ARC BLOCK
#define WEAKSELF __weak __typeof(&*self)weakSelf = self
#define STRONGSELF __strong __typeof(weakSelf)strongSelf = weakSelf


#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define Screen_Bounds [UIScreen mainScreen].bounds

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define MY_IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define MY_IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define Multiple [[UIScreen mainScreen] bounds].size.width/375

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
//get the right bottom origin's x,y of a view
#define kVIEW_BX(view) (view.frame.origin.x + view.frame.size.width)
#define kVIEW_BY(view) (view.frame.origin.y + view.frame.size.height)
#define kIMG(iname) [UIImage imageNamed:iname]

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif

//是否为空
#define isNull(a)  ( (a==nil) || ((NSNull*)a==[NSNull null]) )
#define isNotNull(a)  (!isNull(a))
#define avoidNullStr(a) isNull(a) ? @"" : a

#define GrayColor color(125, 129, 133, 1) //tabar 字的颜色（默认）
#define FatherColor color(53, 172, 255, 1) //tabar 字的颜色（选中）
#define BorderColor colorValue(0xe5e5e5,1) //线的颜色
#define BackGroundColor colorValue(0xecedf1,1) //父视图背景色
#define TabberColor color(75,190,170,1) //tabar 背景色

#define FooterImage @"footerimage" //tabar 图片
#define FooterViewControl @"viewcontrol" //tabar 控制器
#define FooterName @"footername" //tabar 名字

//--------------------------------------   项目中定义   --------------------------------------------------------------//

#define mainHuang colorValue(0xff7f1a,1) //主题黄

#define SSAccount @"account"//历史帐号
#define login_key @"login_key"//登录返回key
#define user_ID @"user_id"//登录返回ID
#define Rc_token @"rc_token"
#define Is_reg @"is_reg"
#define Role_id @"role_id"
#define REALNAME_STATUS @"realname_status"


//权限
#define lim_ord @"lim_ord"//登录返回订单权限
#define lim_pro @"lim_pro"//登录返回产品权限
#define lim_com @"lim_com"//登录返回公司权限
#define lim_cum @"lim_cum"//登录返回客户权限
#define lim_sto @"lim_sto"//登录返回门店权限
//历史搜索
#define history_seach @"history_seach"
//角色分类
#define role_class @"role_class"//角色分类
//操作人
#define login_Operation @"login_Operation"
//部门
#define login_department @"login_department"

#endif /* Defines_h */

