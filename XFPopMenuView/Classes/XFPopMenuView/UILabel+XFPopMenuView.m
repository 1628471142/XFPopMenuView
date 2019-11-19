//
//  UILabel+XFPopMenuView.m
//  XFMenuViewDemo
//
//  Created by 李雪峰 on 2019/5/9.
//  Copyright © 2019 李雪峰. All rights reserved.
//

#import "UILabel+XFPopMenuView.h"
#import <objc/runtime.h>
@implementation UILabel (XFPopMenuView)

 static NSString *titlesKey = @"UILabel+XFPopMenuViewtitles";
 static NSString *blockKey = @"UILabel+XFPopMenuViewblock";

- (void)setPopViewTitles:(NSArray *)popViewTitles{
    objc_setAssociatedObject(self, &titlesKey, popViewTitles, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setPopViewClickblock:(XFMenuPopViewClickBlock)popViewClickblock{
    objc_setAssociatedObject(self, &blockKey, popViewClickblock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray *)popViewTitles{
    return objc_getAssociatedObject(self, &titlesKey);
}

- (XFMenuPopViewClickBlock)popViewClickblock{
    return objc_getAssociatedObject(self, &blockKey);
}

- (void)addLongpressShowWithTitles:(NSArray *)titles click:(nonnull XFMenuPopViewClickBlock)block{
    
    self.userInteractionEnabled = YES;
    self.popViewTitles = titles;
    self.popViewClickblock = block;
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureEvent:)];
    longPress.minimumPressDuration = 0.8;
    [self addGestureRecognizer:longPress];
    
}

- (void)gestureEvent:(UIGestureRecognizer *)gesture{
    
    __weak UILabel *weakLab = self;
    [XFPopMenuView showWithTitles:self.popViewTitles forView:self click:^(NSInteger index, UIButton *btn) {
        if (weakLab.popViewClickblock) {
            weakLab.popViewClickblock(index, btn);
        }
    }];
    
}

- (void)addSingleTapShowWithTitles:(NSArray *)titles click:(nonnull XFMenuPopViewClickBlock)block{
    self.userInteractionEnabled = YES;
    self.popViewTitles = titles;
    self.popViewClickblock = block;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureEvent:)];
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

@end
