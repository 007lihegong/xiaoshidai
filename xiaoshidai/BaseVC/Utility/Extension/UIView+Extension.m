//
//  UIView+Extension.m
//  WeiBo
//
//  Created by 赵明 on 15/5/18.
//  Copyright (c) 2015年 ZM. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)
@dynamic width;
@dynamic height;
@dynamic origin;
@dynamic size;

- (void)setX:(CGFloat)X {
    CGRect frame = self.frame;
    frame.origin.x = X;
    self.frame = frame;
}
- (CGFloat)X {
    return self.frame.origin.x;
}
- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)centerX {
    return self.center.x;
}
- (CGFloat)centerY {
    return self.center.y;
}
- (CGFloat)Y {
    return self.frame.origin.y;
}
- (CGFloat)width {
    return self.frame.size.width;
}
- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)setY:(CGFloat)Y {
    CGRect frame = self.frame;
    frame.origin.y = Y;
    self.frame = frame;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
@end
