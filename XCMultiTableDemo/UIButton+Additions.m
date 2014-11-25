//
//  UIButton+EHAdditions.m
//  EHHeater
//
//  Created by Nathan on 14-9-19.
//  Copyright (c) 2014年 XPG. All rights reserved.
//

#import "UIButton+Additions.h"

@implementation UIButton (Additions)

+ (instancetype)roundRectButtonWithTitle:(NSString *)string backgroundColor:(UIColor *)color cornerRadius:(CGFloat)radius
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:string forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = color;
    button.layer.cornerRadius = radius;
    button.layer.masksToBounds = YES;
    return button;
}

@end
