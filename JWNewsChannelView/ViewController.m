//
//  ViewController.m
//  JWNewsChannelView
//
//  Created by zypsusu on 15/8/7.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "ViewController.h"
#import "JWNewsChannelView.h"

@interface ViewController ()<NSCoding>
@property (nonatomic, weak) JWNewsChannelView *newsChannelView;
@property (nonatomic, strong) NSMutableArray *newsArrayList;
@end

@implementation ViewController

- (IBAction)clickBtn{
    
    // 判断沙盒中是否存在plist，有就直接读取，没有就加载bundle中的plist
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] ;
    NSString *filePath = [path stringByAppendingPathComponent:@"MyDefaultsNewsNavItems.plist"];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:filePath];
    NSLog(@"%@", array);
    if (array.count < 1) {
        // 读取bundle中plist文件，获取数据
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MyDefaultsNewsNavItems" ofType:@"plist"];
        array = [NSMutableArray arrayWithContentsOfFile:path];
        NSLog(@"%@", array);
    }
    [self showJWNewsChannelViewWithArray:array];
}

/**
 *  显示标签页面
 *
 *  @param array 获取到的数组用来给标签页面中的标签赋值
 */
- (void)showJWNewsChannelViewWithArray:(NSMutableArray *)array{
    
//    JWNewsChannelView *newsChannelView = [[JWNewsChannelView alloc] initWithFrame:CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    JWNewsChannelView *newsChannelView = [[JWNewsChannelView alloc] init];
    newsChannelView.alpha = 0;
    newsChannelView.array = array;
    NSLog(@"%@", array);
    [newsChannelView.backBtn addTarget:self action:@selector(channelViewCallOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newsChannelView];
    self.newsChannelView = newsChannelView;
    
    // 设置展现动画
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        newsChannelView.alpha = 1.0;
        [newsChannelView setFrame:CGRectMake(0, 0, newsChannelView.bounds.size.width, newsChannelView.bounds.size.height)];
        
    } completion:^(BOOL finished){
    }];

}

// 点击标签页面返回按钮触发，回调新的数组
- (void)channelViewCallOut{
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [self.newsChannelView setFrame:CGRectMake(0, - self.newsChannelView.bounds.size.height, self.newsChannelView.bounds.size.width, self.newsChannelView.bounds.size.height)];
        self.newsChannelView.alpha = 0;
        
    } completion:^(BOOL finished){
           // 写入plist，刷新频道标签
        self.newsArrayList = self.newsChannelView.array;
        NSLog(@"%@", self.newsChannelView.array);
        NSLog(@"%@", self.newsArrayList);
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] ;
        NSString *filePath = [path stringByAppendingPathComponent:@"MyDefaultsNewsNavItems.plist"];
        NSLog(@"%@", filePath);
        [self.newsArrayList writeToFile:filePath atomically:YES];
        [self.newsChannelView removeFromSuperview];
        
#warning TODO 刷新新闻界面的标签
//        [self clickBtn];
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// 懒加载
- (NSMutableArray *)newsArrayList{
    if (!_newsArrayList) {
        _newsArrayList = [NSMutableArray array];
    }
    return _newsArrayList;
}

@end
