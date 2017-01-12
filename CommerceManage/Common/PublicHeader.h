//
//  PublicHeader.h
//  CommerceManage
//
//  Created by 小花 on 2016/12/26.
//  Copyright © 2016年 vaic. All rights reserved.
//

#ifndef PublicHeader_h
#define PublicHeader_h

#define screenW [[UIScreen mainScreen] bounds].size.width
#define screenH [[UIScreen mainScreen] bounds].size.height

        /**项目的IP*/
#define URL_IP @"http://172.16.10.15:9300/"  //内网IP
//#define URL_IP @"http://59.108.94.40:9100/"  //外网IP

        /**图片的IP*/
#define URL_IP_IMG @"http://172.16.10.15:9300/" //内网图片
//#define URL_IP_IMG @"http://59.108.94.40:9100/" //外网图片

        /**项目名称*/
#define PROJECT_NAME @"gsl-api"        //内网
//#define PROJECT_NAME @"gsl-api"    //外网



#define GENERAL_NEWS @"/gsl/news/newsList"                  //3.1	普通新闻列表接口
#define BANNER_NEWS @"/gsl/news/newsBannerList"             //3.2	Banner新闻列表接口
#define DETAIL_NEWS @"/gsl/news/getNews"                    //3.3	新闻详情接口
#define BUSINESS_LIST @"/gsl/business/businessList"         //3.4	商业列表接口
#define BUSINESS_DETAIL @"/gsl/business/getBusiness"        //3.5	商业项目详情接口
#define USER_LOGIN @"/gsl/sysUser/login"                    //3.6	登陆接口
#define USER_CHANGE_PW @"/gsl/sysUser/upPass"               //3.7	修改密码接口
#define MEETING_SIGNIN @"/gsl/meeting/signIn"               //3.8	会议签到接口
#define MEETING_LIST @"/gsl/meeting/meetingList"            //3.9	会议列表查询接口
#define MEETING_CHANGE_JOIN @"/gsl/meeting/join"            //3.10	修改会议参加状态接口
#define WEATHER @"/gsl/meeting/weather"                     //3.11	获取天气情况接口

//占位图
#define PLACEHOLDER_IMG [UIImage imageNamed:@"top_logo"]




#define ColorWithRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 颜色值RGB
#define Color_RGBA(r,g,b,a)                       [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

//app 主题色
#define APP_THEME_COLOR Color_RGBA(57,166,220,1)


#define FitSize(v) ((v)/375.0f*[[UIScreen mainScreen] bounds].size.width)


#endif /* PublicHeader_h */
