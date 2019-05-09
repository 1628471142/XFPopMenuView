//
//  UILabel+XFPopMenuView.h
//  XFMenuViewDemo
//
//  Created by 李雪峰 on 2019/5/9.
//  Copyright © 2019 李雪峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFPopMenuView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (XFPopMenuView)

@property (nonatomic, strong) NSArray *popViewTitles;
@property (nonatomic, copy) XFMenuPopViewClickBlock popViewClickblock;


// 快速给label添加长按手势，弹出菜单栏
- (void)addLongpressShowWithTitles:(NSArray *)titles click:(nonnull XFMenuPopViewClickBlock)block;

@end

NS_ASSUME_NONNULL_END
