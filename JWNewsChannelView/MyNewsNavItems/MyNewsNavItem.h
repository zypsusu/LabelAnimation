//
//  MyNewsNavItem.h
//  JWBrowser
//
//  Created by 蔡成汉 on 15/7/20.
//  Copyright (c) 2015年 JW. All rights reserved.
//

/**
 *  新闻导航的item
 */

#import <Foundation/Foundation.h>
//#import "JWNewsTemp.h"

@interface MyNewsNavItem : NSObject

/**
 *  导航item的名字
 */
@property (nonatomic , strong) NSString *itemName;

/**
 *  导航数据URL
 */
@property (nonatomic , strong) NSString *itemURL;

/**
 *  导航item的Id
 */
@property (nonatomic , strong) NSString *itemId;

/**
 *  新闻分类头上一次刷新时间 -- 其实指向的是新闻的刷新时间
 */
@property (nonatomic , strong) NSString *lastRefreshTime;

/**
 *  缓存的数据 -- 内存中
 */
//@property (nonatomic , strong) JWNewsTemp *itemTemp;

@end
