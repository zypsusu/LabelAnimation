//
//  JWNewsChannelView.h
//  JWNewsChannelView
//
//  Created by zypsusu on 15/8/7.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWNewsChannelView : UIView
@property (nonatomic, weak) UIButton *backBtn;          // 返回按钮
@property (nonatomic, strong) NSMutableArray *array;    // 标签数组
@property (nonatomic, weak) UIScrollView *scrollView;  // 标签所在的View

- (void)ininWithArray:(NSArray *)array;
@end
