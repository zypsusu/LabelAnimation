//
//  MyNewsNavItem.m
//  JWBrowser
//
//  Created by 蔡成汉 on 15/7/20.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "MyNewsNavItem.h"

@implementation MyNewsNavItem

-(id)init
{
    self = [super init];
    if (self)
    {
        //默认值
        self.itemName = @"";
        self.itemURL = @"";
        self.itemId = @"";
        self.lastRefreshTime = @"0";
//        self.itemTemp = [[JWNewsTemp alloc]init];
    }
    return self;
}



@end
