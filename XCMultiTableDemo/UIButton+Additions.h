      //
//  UIButton+EHAdditions.h
//  EHHeater
//
//  Created by Nathan on 14-9-19.
//  Copyright (c) 2014年 XPG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Additions)

+ (instancetype)roundRectButtonWithTitle:(NSString *)string backgroundColor:(UIColor *)color cornerRadius:(CGFloat)radius;

@end
