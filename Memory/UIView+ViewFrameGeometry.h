//
//  UIView+ViewFrameGeometry.h
//  Memory
//
//  Created by owen on 2017/9/14.
//  Copyright © 2017年 owen. All rights reserved.
//

#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (ViewFrameGeometry)
@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;//左下角坐标
@property (readonly) CGPoint bottomRight;//右下角坐标
@property (readonly) CGPoint topRight;//右上角坐标

@property CGFloat height;//控件高
@property CGFloat width;//控件宽

@property CGFloat top;//控件顶部y值
@property CGFloat left;//控件左边距x值

@property CGFloat bottom;//控件底部y值
@property CGFloat right;//控件右边距x值

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

@end
