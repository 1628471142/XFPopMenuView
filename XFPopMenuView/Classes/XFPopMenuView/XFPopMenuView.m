//
//  XFPopMenuView.m
//  XFPopMenuViewDemo
//
//  Created by 李雪峰 on 2019/5/8.
//  Copyright © 2019 李雪峰. All rights reserved.
//
#define AngleHeight 10
#import "XFPopMenuView.h"

@implementation XFPopMenuView
@synthesize titles = _titles;
@synthesize font = _font;
@synthesize horizontalPadding = _horizontalPadding;
@synthesize verticalPadding = _verticalPadding;
@synthesize position = _position;

static XFPopMenuView * _instance = nil;

+ (XFPopMenuView *)shareInstance{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _instance = [[self alloc] init];
        _instance.buttons = [[NSMutableArray alloc] init];
        [_instance setBackgroundColor:[UIColor whiteColor]];
        _instance.coverView = [[XFCoverView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        __weak XFPopMenuView * weakInstance = _instance;
        _instance.coverView.touchBlock = ^{
            [weakInstance hide];
        };
    });
    return _instance;
}

#pragma mark ------ setter
- (void)setVerticalPadding:(CGFloat)verticalPadding{
    if (verticalPadding != _verticalPadding) {
        _verticalPadding = verticalPadding;
        [self addSubButtons:_titles];
    }
}

- (void)setHorizontalPadding:(CGFloat)horizontalPadding{
    if (horizontalPadding != _horizontalPadding) {
        _horizontalPadding = horizontalPadding;
        [self addSubButtons:_titles];
    }
}

- (void)setFont:(UIFont *)font{
    if (font != _font && _font != nil) {
        if (_font != nil) {
            _font = font;
            [self addSubButtons:_titles];
        }
        _font = font;
    }
}

- (void)setTitles:(NSArray *)titles{
    if (titles != _titles) {
        if (_titles != nil) {
            _titles = titles;
            [self addSubButtons:_titles];
        }
        _titles = titles;
    }
}

- (void)setPosition:(XFMenuPosition)position{
    if (position != _position) {
        _position = position;
        [self addSubButtons:_titles];
    }
}

#pragma mark ------ getter
- (CGFloat)verticalPadding{
    if (_verticalPadding == 0) {
        _verticalPadding = 10;
    }
    return _verticalPadding;
}

- (CGFloat)horizontalPadding{
    if (_horizontalPadding == 0) {
        _horizontalPadding = 15;
    }
    return _horizontalPadding;
}

- (UIFont *)font{
    if (_font == nil) {
        _font = [UIFont systemFontOfSize:15];
    }
    return _font;
}

+ (void)showWithTitles:(NSArray *)titles forView:(nonnull UIView *)view click:(nonnull XFMenuPopViewClickBlock)block{
    
    XFPopMenuView * popMenuView = [XFPopMenuView shareInstance];
    popMenuView.offsetX = 0;
    popMenuView.targetView = view;
    popMenuView.titles = titles;
    popMenuView.clickBlock = block;
    [popMenuView addSubButtons:titles];
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window]?:[UIApplication sharedApplication].keyWindow;
    [window addSubview:popMenuView.coverView];
    [window addSubview:popMenuView];
    [window bringSubviewToFront:popMenuView];
    [popMenuView setNeedsDisplay];

}

- (void)addSubButtons:(NSArray *)titles{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttons removeAllObjects];
    
    // 计算相对位置，判断是否需要调整箭头方向
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window]?:[UIApplication sharedApplication].keyWindow;
    CGRect startRect = [_targetView convertRect:_targetView.bounds toView:window];
    if (startRect.origin.y + startRect.size.height/2.0 < [UIScreen mainScreen].bounds.size.height/2.0) {
        if (_position != XFMenuPositionBottom) {
            self.position = XFMenuPositionBottom;
        }else{
            [self configPopViewFrameWithTitles:titles startRect:startRect];
        }
    }else{
        if (_position != XFMenuPositionTop) {
            self.position = XFMenuPositionTop;
        }else{
            [self configPopViewFrameWithTitles:titles startRect:startRect];
        }
    }

}

- (void)configPopViewFrameWithTitles:(NSArray *)titles startRect:(CGRect)startRect{
    CGFloat width = 0;
    NSString * firstTitle = [titles firstObject];
    CGFloat titleHeight = [firstTitle sizeWithAttributes:@{NSFontAttributeName:self.font}].height;
    // 按钮位置相对menuView的纵向偏移
    CGFloat offsetY = self.position == XFMenuPositionTop ? 0 : AngleHeight;
    for (int i = 0; i < titles.count; i ++) {
        NSString * title = [titles objectAtIndex:i];
        CGSize titleSize  = [title sizeWithAttributes:@{NSFontAttributeName:self.font}];
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(width, offsetY, titleSize.width + self.horizontalPadding*2, self.verticalPadding*2 + titleSize.height)];
        width = width + titleSize.width + self.horizontalPadding*2;
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = self.font;
        [btn setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3]] forState:UIControlStateHighlighted];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.buttons addObject:btn];
        if (i != titles.count - 1) {
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(width - 0.5, offsetY, 0.5, self.verticalPadding*2 + titleSize.height)];
            [line setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.7]];
            [self addSubview:line];
        }
    }
    CGFloat selfHeight = titleHeight + self.verticalPadding*2 + AngleHeight;
    // menuView相对目标视图的纵向偏移
    CGFloat y = self.position == XFMenuPositionTop ? startRect.origin.y - selfHeight : startRect.origin.y + startRect.size.height;
    CGFloat x = round(startRect.origin.x + startRect.size.width/2 - width/2);
    y = round(y);
    CGFloat w = round(width);
    CGFloat h = round(selfHeight);
    if (x < 15) {
        _offsetX = 15 - x;
        x = 15;
    }
    if (x + w > [UIScreen mainScreen].bounds.size.width - 15) {
        _offsetX = [UIScreen mainScreen].bounds.size.width - 15 - x - w;
        x = x + _offsetX;
    }
    CGRect endFrame = CGRectMake(x,y,w,h);
    [self setFrame:endFrame];
}


- (void)btnClickEvent:(UIButton *)btn{
    if (_clickBlock) {
        _clickBlock(btn.tag,btn);
    }
    [XFPopMenuView hide];
}

+ (void)hide{
    [[self shareInstance] hide];
}

- (void)hide{
    [self.coverView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGFloat viewW = rect.size.width;
    CGFloat viewH = rect.size.height;
    
    CGFloat strokeWidth = 0.1;
    CGFloat borderRadius = 8;
    // 三角水平位置中点
    CGFloat angleX = viewW/2 - _offsetX;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineJoin(context, kCGLineJoinRound); //
    CGContextSetLineWidth(context, strokeWidth); // 设置画笔宽度
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor); // 设置画笔颜色
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor); // 设置填充颜色
    
    CGContextBeginPath(context);
    
    if (self.position == XFMenuPositionTop) {
        CGContextMoveToPoint(context, 0, borderRadius);
        CGContextAddArcToPoint(context, 0, viewH - AngleHeight, borderRadius, viewH - AngleHeight, borderRadius);
        // 画三角部分
        CGContextAddLineToPoint(context, angleX - AngleHeight, viewH - AngleHeight);
        CGContextAddLineToPoint(context, angleX, viewH);
        CGContextAddLineToPoint(context, angleX + AngleHeight, viewH - AngleHeight);
        
        CGContextAddArcToPoint(context, viewW, viewH - AngleHeight, viewW,viewH - AngleHeight - borderRadius, borderRadius);
        CGContextAddArcToPoint(context, viewW, 0, viewW-borderRadius, 0, borderRadius);
        CGContextAddArcToPoint(context, 0, 0, 0, borderRadius, borderRadius);
    }
    
    if (self.position == XFMenuPositionBottom) {
        CGContextMoveToPoint(context, 0, borderRadius + AngleHeight);
        CGContextAddArcToPoint(context, 0, viewH, borderRadius, viewH, borderRadius);
        CGContextAddArcToPoint(context, viewW, viewH, viewW,viewH - borderRadius, borderRadius);
        CGContextAddArcToPoint(context, viewW, AngleHeight, viewW-borderRadius, AngleHeight, borderRadius);
        CGContextAddLineToPoint(context, angleX + AngleHeight, AngleHeight);
        CGContextAddLineToPoint(context, angleX, 0);
        CGContextAddLineToPoint(context, angleX - AngleHeight, AngleHeight);
        CGContextAddArcToPoint(context, 0, AngleHeight, 0, borderRadius + AngleHeight, borderRadius);
    }
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
}

- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end


@implementation XFCoverView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.touchBlock) {
        self.touchBlock();
    }
    
}

@end
