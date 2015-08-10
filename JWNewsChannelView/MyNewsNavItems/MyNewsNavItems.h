//
//  MyNewsNavItems.h
//  JWBrowser
//
//  Created by 蔡成汉 on 15/7/20.
//  Copyright (c) 2015年 JW. All rights reserved.
//

/**
 *  新闻导航的items
 */

#import <Foundation/Foundation.h>
#import "MyNewsNavItem.h"

@interface MyNewsNavItems : NSObject

/**
 *  新闻导航分类头
 */
@property (nonatomic , strong) NSMutableArray *newsNavItems;

/**
 *  单例方法
 *
 *  @return 实例化之后的MyNewsNavItems
 */
+(MyNewsNavItems *)shareMyNewsNavItems;

/**
 *  对外方法，对MyNewsNavItems进行赋值
 *
 *  @param array MyNewsNavItems数据源数组
 */
-(void)setMyNewsNavItemsWithArray:(NSArray *)array;

@end
