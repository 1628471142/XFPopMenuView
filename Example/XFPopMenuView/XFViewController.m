//
//  XFViewController.m
//  XFPopMenuView
//
//  Created by 953894805@qq.com on 05/09/2019.
//  Copyright (c) 2019 953894805@qq.com. All rights reserved.
//

#import "XFViewController.h"
#import "XFPopMenuView.h"
#import "UILabel+XFPopMenuView.h"
@interface XFViewController ()

@end

@implementation XFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 200, 60)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"我是一个label";
    [lab setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:lab];
    [lab addLongpressShowWithTitles:@[@"我是机灵鬼",@"我是老二",@"我是老三"] click:^(NSInteger index, UIButton *btn) {
        NSLog(@"我点击了%ld，我叫%@",index,btn.titleLabel.text);
    }];
}

- (void)btnClick:(UIButton *)btn{
    [XFPopMenuView showWithTitles:@[@"复制",@"翻译",@"粘贴"] forView:btn click:^(NSInteger index, UIButton *btn) {
        NSLog(@"我点击了%ld，我叫%@",index,btn.titleLabel.text);
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(350, 400, 50, 50)];
    [btn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [XFPopMenuView showWithTitles:@[@"复制",@"翻译",@"粘贴"] forView:btn click:^(NSInteger index, UIButton *btn) {
        NSLog(@"我点击了%ld，我叫%@",index,btn.titleLabel.text);
    }];
    [XFPopMenuView shareInstance].titles = @[@"复制",@"多选",@"粘贴"];
}

@end

