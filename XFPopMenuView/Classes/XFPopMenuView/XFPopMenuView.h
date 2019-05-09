//
//  XFPopMenuView.h
//  XFPopMenuViewDemo
//
//  Created by 李雪峰 on 2019/5/8.
//  Copyright © 2019 李雪峰. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^XFMenuPopViewClickBlock)(NSInteger index,UIButton * _Nullable btn);

typedef NS_ENUM(NSUInteger, XFMenuPosition) {
    XFMenuPositionTop,
    XFMenuPositionBottom
};

NS_ASSUME_NONNULL_BEGIN

@interface XFPopMenuView : UIView

/**
 遮罩层（触摸事件，移除菜单视图的图层）
 */
@property (nonatomic, strong) UIView * coverView;

/**
 触发视图，为该视图添加菜单栏
 */
@property (nonatomic, strong) UIView * targetView;

/**
 标签名称数组
 */
@property (nonatomic, strong) NSArray * titles;

/**
 标签按钮数组，如需单独修改按钮颜色等特殊需求，可取出调整属性
 */
@property (nonatomic, strong) NSMutableArray<UIButton *> * buttons;

/**
 标签按钮字体大小
 */
@property (nonatomic, strong) UIFont * font;

/**
 水平内边距
 */
@property (nonatomic, assign) CGFloat horizontalPadding;

/**
 竖直内边距
 */
@property (nonatomic, assign) CGFloat verticalPadding;

/**
 菜单栏位置
 */
@property (nonatomic, assign,readonly) XFMenuPosition position;

/**
 按钮点击回调
 */
@property (nonatomic, copy) XFMenuPopViewClickBlock clickBlock;


+ (XFPopMenuView *)shareInstance;


/**
 初始化方法，并添加在window上

 @param titles 标签数组
 @param view 触发视图，为该视图添加菜单栏
 @param block 按钮点击回调
 */
+ (void)showWithTitles:(NSArray *)titles forView:(nonnull UIView *)view click:(nonnull XFMenuPopViewClickBlock)block;

+ (void)hide;

@end

NS_ASSUME_NONNULL_END
