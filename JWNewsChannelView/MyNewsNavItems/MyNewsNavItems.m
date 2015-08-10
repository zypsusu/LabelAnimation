//
//  MyNewsNavItems.m
//  JWBrowser
//
//  Created by 蔡成汉 on 15/7/20.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "MyNewsNavItems.h"

static MyNewsNavItems *myNewsNavItems;

@implementation MyNewsNavItems
@synthesize newsNavItems;

/**
 *  单例方法
 *
 *  @return 实例化之后的MyNewsNavItems
 */
+(MyNewsNavItems *)shareMyNewsNavItems
{
    @synchronized(self)
    {
        if (myNewsNavItems == nil)
        {
            myNewsNavItems = [[self alloc]init];
        }
    }
    return myNewsNavItems;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        //加载默认值
        newsNavItems = [NSMutableArray arrayWithArray:[self creatMyDefaultItemsArray]];
    }
    return self;
}

/**
 *  对外方法，对MyNewsNavItems进行赋值
 *
 *  @param array MyNewsNavItems数据源数组
 */
-(void)setMyNewsNavItemsWithArray:(NSArray *)array
{
    if (array != nil && array.count >0)
    {
        //数据处理
        
        NSMutableArray *tpArray = [NSMutableArray array];
        for (int i = 0; i<array.count; i++)
        {
            MyNewsNavItem *tpItem = [[MyNewsNavItem alloc]init];
            NSDictionary *tpDic = [array objectAtIndex:i];
            tpItem.itemName = [NSString stringWithFormat:@"%@",[tpDic objectForKey:@"itemName"]];
            if ([tpItem.itemName isEqualToString:@"本地"])
            {
                //获取当前的城市名
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *cityName = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"mycityname"]];
                if (cityName == nil || cityName.length <= 0 || [cityName isEqualToString:@"(null)"])
                {
                    cityName = @"本地";
                }
                tpItem.itemName = cityName;
            }
            tpItem.itemURL = [NSString stringWithFormat:@"%@",[tpDic objectForKey:@"itemURL"]];
            tpItem.itemId = [NSString stringWithFormat:@"%@",[tpDic objectForKey:@"itemId"]];
            [tpArray addObject:tpItem];
        }
        
        [newsNavItems removeAllObjects];
        [newsNavItems addObjectsFromArray:tpArray];
    }
}

/**
 *  构建默认数据 -- 数据来自plist文件
 *
 *  @return 默认
 */
-(NSArray *)creatMyDefaultItemsArray
{
    //加载plist数据
    NSString *tpItemsPath = [[NSBundle mainBundle]pathForResource:@"MyDefaultsNewsNavItems" ofType:@"plist"];
    NSArray *tpItemsArray = [[NSArray alloc]initWithContentsOfFile:tpItemsPath];
    NSMutableArray *tpArray = [NSMutableArray array];
    for (int i = 0; i<tpItemsArray.count; i++)
    {
        MyNewsNavItem *tpItem = [[MyNewsNavItem alloc]init];
        NSDictionary *tpDic = [tpItemsArray objectAtIndex:i];
        tpItem.itemName = [NSString stringWithFormat:@"%@",[tpDic objectForKey:@"itemName"]];
        if ([tpItem.itemName isEqualToString:@"本地"])
        {
            //获取当前的城市名
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *cityName = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"mycityname"]];
            if (cityName == nil || cityName.length <= 0 || [cityName isEqualToString:@"(null)"])
            {
                cityName = @"本地";
            }
            tpItem.itemName = cityName;
        }
        tpItem.itemURL = [NSString stringWithFormat:@"%@",[tpDic objectForKey:@"itemURL"]];
        tpItem.itemId = [NSString stringWithFormat:@"%@",[tpDic objectForKey:@"itemId"]];
        [tpArray addObject:tpItem];
    }
    return tpArray;
}



@end
