//
//  JWNewsChannelView.m
//  JWNewsChannelView
//
//  Created by zypsusu on 15/8/7.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "JWNewsChannelView.h"
#import "MyNewsNavItems.h"
#import "MyNewsNavItem.h"
#define Duration 0.3
#define StausBarHeight  20 // 状态栏高度
#define TabBarHeight 49    // 底部工具栏高度
#define NavigationBarHeigth 44  // 导航栏高度
#define NavigationBarTotalHeigth 64 // 导航栏总高度
#define Kcount  15          // 标签个数

@interface JWNewsChannelView()
{
    BOOL contain; //是否包含中心点
    CGPoint startPoint; // 初始位置
    CGPoint originPoint;// 初始中心点
}
@property (nonatomic, weak) UILabel *titleLabel;       // 标题栏
@property (nonatomic, weak) UILabel *labTitle;         // 小标题
@end

@implementation JWNewsChannelView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setViewFrame];
}

/// 设置各控件frame
- (void)setViewFrame{
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.frame = CGRectMake(0, 0, width, height);
    CGFloat margin  = 10;
    NSLog(@"%f, %f", height, width);

    self.titleLabel.frame = CGRectMake(0, StausBarHeight, width, TabBarHeight);
    self.backBtn.frame = CGRectMake(width - 50, StausBarHeight, TabBarHeight, TabBarHeight);
    self.scrollView.frame = CGRectMake(0, NavigationBarTotalHeigth, width, height);
    self.scrollView.contentSize = CGSizeMake(width, height * 1.1);
    self.labTitle.frame = CGRectMake(margin, 0, width, 36);
    
   // 按钮frame,按需求自定义每行标签个数
    // 横竖屏判断
    int count = 7;
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
        count = 4;
    }
    CGFloat widthBtn = (width - (count + 1) * margin) / count;
    CGFloat heightBtn = 44;
    for (int i = 0; i < self.array.count; i++) {
        CGFloat clor = i / count;
        CGFloat line = i % count;
        UIButton *btn = (UIButton *)[self.scrollView viewWithTag:i + 100];
        btn.frame = CGRectMake((margin + widthBtn) * line + margin,36 + (margin + heightBtn) * clor, widthBtn, heightBtn);
    }
    NSLog(@"%@", NSStringFromCGRect(self.frame));
}

/// 创建各个控件
- (void)setUp{
    // 创建channelView,导航label，
    UILabel *label = [[UILabel alloc] init];
    self.titleLabel = label;
    label.text = @"频道管理";
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage imageNamed:@"CloseButonImage"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"CloseButonHighlightedImage"] forState:UIControlStateHighlighted];
    self.backBtn = backBtn;
    [self addSubview:backBtn];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    self.scrollView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:0.8];
    [self addSubview:scrollView];
    
    UILabel *labTitle = [[UILabel alloc] init];
    labTitle.text = @"点亮你的兴趣频道，长按拖拽可排序";
    labTitle.textColor = [UIColor grayColor];
    [labTitle setFont:[UIFont systemFontOfSize:12]];
    self.labTitle = labTitle;
    [self.scrollView addSubview:labTitle];

    for (int i = 0; i < Kcount; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i + 100;
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn addGestureRecognizer:longPressGesture];
        [self.scrollView addSubview:btn];
    }
}

/**
 *  重写setter方法，设置btn属性
 *
 *  @param array 读取plist获取到的数组，控制器传过来
 */
- (void)setArray:(NSMutableArray *)array{
    _array = array;
    for (int i = 0; i < array.count; i++) {
        // 设置属性，文字
        UIButton *btn = (UIButton *)[self.scrollView viewWithTag:i + 100];
        [btn setTitle:array[i][@"itemName"] forState:UIControlStateNormal];
        if ([array[i][@"itemIsSelect"] isEqual:@1]) {
            [btn setBackgroundColor:[UIColor colorWithRed:58/255.0 green:138/255.0 blue:250/255.0 alpha:1.0]];

            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
    btn.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}

/**
 *  长按手势动画
 *
 *  @param sender 长按手势
 */
- (void)buttonLongPressed:(UILongPressGestureRecognizer *)gesture
{
    UIButton *btn = (UIButton *)gesture.view;
    
    // 开始时获取初始位置，设置放大透明动画
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        startPoint = [gesture locationInView:gesture.view];
        originPoint = btn.center;
        [UIView animateWithDuration:Duration animations:^{
            
            btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
            btn.alpha = 0.7;
        }];
    }
    // 拖动时判断是否包含center，包含则移动各控件frame
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        
        CGPoint newPoint = [gesture locationInView:gesture.view];
        CGFloat deltaX = newPoint.x - startPoint.x;
        CGFloat deltaY = newPoint.y - startPoint.y;
        btn.center = CGPointMake(btn.center.x+deltaX,btn.center.y+deltaY);
        [self.scrollView bringSubviewToFront:btn];
        
        NSLog(@"center = %@",NSStringFromCGPoint(btn.center));
        
        NSInteger index = [self indexOfPoint:btn.center withButton:btn];
        if (index<0)
        {
            contain = NO;
        }
        else
        {
//            if (index < btn.tag) {
//                CGPoint temp = CGPointZero;
//                temp = [self.scrollView viewWithTag:index + 100].center;
//                for (NSInteger i = index + 100; i < btn.tag ; i++) {
//                    
//                    [UIView animateWithDuration:Duration animations:^{
//
//                        UIButton *button1 = (UIButton *)[self.scrollView viewWithTag:i];
//                        UIButton *button2 = (UIButton *)[self.scrollView viewWithTag:i + 1];
//                        button1.center = button2.center;
//                        
//                    }];
//                }
//                btn.center = temp;
//                
//            } else {
//                CGPoint temp = CGPointZero;
//                temp = [self.scrollView viewWithTag:index].center;
//                for (NSInteger i = btn.tag; i < index; i++) {
//                    
//                    [UIView animateWithDuration:Duration animations:^{
//                        UIButton *button1 = (UIButton *)[self.scrollView viewWithTag:i];
//                        UIButton *button2 = (UIButton *)[self.scrollView viewWithTag:i + 1];
//
//                        button2.center = button1.center;
//
//                    }];
//                }
//                btn.center = temp;
//            }
            [UIView animateWithDuration:Duration animations:^{
                
                CGPoint temp = CGPointZero;
                UIButton *button = (UIButton *) [self.scrollView viewWithTag:index + 100];
                temp = button.center;
                button.center = originPoint;
                btn.center = temp;
                
   // 保证更改后的位置不发生变化，即时改变数组的排序
                [self.array exchangeObjectAtIndex:index withObjectAtIndex:btn.tag - 100];
                button.tag = btn.tag;
                btn.tag = index + 100;
                NSLog(@"%@", self.array);
                originPoint = btn.center;
                contain = YES;
            }];
        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:Duration animations:^{
            
            btn.transform = CGAffineTransformIdentity;
            btn.alpha = 1.0;
            if (!contain)
            {
                btn.center = originPoint;
            }
        }];
    }
}

/**
 *  判断中心点center是否在rect范围内，判断是否重叠
 *
 *  @param point 传要判断的点
 *  @param btn   要判断的对象，获取frame
 *
 *  @return 返回重叠对象的索引
 */
- (NSInteger)indexOfPoint:(CGPoint)point withButton:(UIButton *)btn
{
    for (NSInteger i = 0; i<_array.count; i++)
    {
        UIButton *button =(UIButton *) [self.scrollView viewWithTag:i + 100];
        if (button != btn)
        {
            if (CGRectContainsPoint(button.frame, point))
            {
                return i;
            }
        }
    }
    return -1;
}

/// 按钮点击选中标记或未选中
- (void)btnClick:(UIButton *)sender{
    NSMutableDictionary *dic = self.array[sender.tag - 100];
    NSNumber *isSelect = dic[@"itemIsSelect"];

// 对数组进行读取并读写，两种状态标记
    if ([isSelect  isEqual: @0]) {
        sender.transform = CGAffineTransformMakeScale(0.5 , 0.5);
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5  initialSpringVelocity:5.0 options:0 animations:^{
            sender.transform = CGAffineTransformMakeScale(1.0, 1.0);
            [sender setBackgroundColor:[UIColor colorWithRed:58/255.0 green:138/255.0 blue:250/255.0 alpha:1.0]];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
            
        }];
        isSelect = @1;
    }
    else {
    sender.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isSelect = @0;
    }
    dic[@"itemIsSelect"] = isSelect;
}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


@end
