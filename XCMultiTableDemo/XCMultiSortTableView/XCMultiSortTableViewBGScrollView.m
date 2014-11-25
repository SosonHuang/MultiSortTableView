//
//  XCMultiTableViewBGScrollView.m
//  XCMultiTableDemo
//
//  Created by Kingiol on 13-7-20.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import "XCMultiSortTableViewBGScrollView.h"

#import "UIView+XCMultiSortTableView.h"

@implementation XCMultiTableViewBGScrollView {
    NSMutableArray *lines;
}

@synthesize parent;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
#pragma mark 修改顶部的线

- (void)reDraw {
    

    if (lines == nil) lines = [[NSMutableArray alloc] initWithCapacity:20];
    
    for (UIView *view in lines) {
        [view removeFromSuperview];
    }
    
    [lines removeAllObjects];

    
    UIView *hidView = [[UIView alloc] initWithFrame:CGRectMake(0.0f - parent.normalSeperatorLineWidth, 0, parent.normalSeperatorLineWidth, self.bounds.size.height)];
    hidView.backgroundColor = parent.normalSeperatorLineColor;
    hidView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    [self addSubview:hidView];
    [lines addObject:hidView];

    UIView *line = nil;
    CGFloat x = 0.0f;
    NSUInteger columnCount = [parent.datasource arrayDataForTopHeaderInTableView:parent].count;
    
//    NSUInteger columnCount = 4;
    NSLog(@"%d",columnCount);
    for (int i = 0; i < columnCount; i++) {
        CGFloat width;
        
        
        if ([parent.datasource respondsToSelector:@selector(tableView:contentTableCellWidth:)]) {
            width = [parent.datasource tableView:parent contentTableCellWidth:i];
        }else {
            width = parent.cellWidth;
        }
        
        x += width + parent.normalSeperatorLineWidth;
        
        line = [self addVerticalLineWithWidth:parent.normalSeperatorLineWidth bgColor:parent.normalSeperatorLineColor atX:x atY:120];
        [lines addObject:line];
    }
    
    

}



- (void)newReDraw {
    if (lines == nil) lines = [[NSMutableArray alloc] initWithCapacity:20];
    
    for (UIView *view in lines) {
        [view removeFromSuperview];
    }
    
    [lines removeAllObjects];
    
    
    UIView *hidView = [[UIView alloc] initWithFrame:CGRectMake(0.0f - parent.normalSeperatorLineWidth, 0, parent.normalSeperatorLineWidth, self.bounds.size.height)];
    hidView.backgroundColor = parent.normalSeperatorLineColor;
    hidView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    [self addSubview:hidView];
    [lines addObject:hidView];
    
    UIView *line = nil;
    CGFloat x = 0.0f;
    NSUInteger columnCount = [parent.datasource arrayDataForTopHeaderInTableView:parent].count;
    
    //    NSUInteger columnCount = 4;
    NSLog(@"%d",columnCount);
    for (int i = 0; i < columnCount; i++) {
        CGFloat width;
        
        
        if ([parent.datasource respondsToSelector:@selector(tableView:contentTableCellWidth:)]) {
            width = [parent.datasource tableView:parent contentTableCellWidth:i];
        }else {
            width = parent.cellWidth;
        }
        
        x += width + parent.normalSeperatorLineWidth;
        
        if ([parent.deleStr isEqualToString:@"30"]) {
             line = [self addVerticalLineWithWidth:0 bgColor:parent.normalSeperatorLineColor atX:x atY:0];
            
            
            parent.deleStr  = @"10";
        }else{
         line = [self addVerticalLineWithWidth:parent.normalSeperatorLineWidth bgColor:parent.normalSeperatorLineColor atX:x atY:0];
       
        }
        
        [lines addObject:line];
    }
    
    
    
}

- (void)dealloc {
    lines = nil;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, parent.normalSeperatorLineWidth);
    CGContextSetAllowsAntialiasing(context, false);
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
    
    NSUInteger columnCount = [parent.headData count];
    for (int i = 0; i <= columnCount; i++) {
        CGFloat x = i * parent.cellWidth;
        CGContextMoveToPoint(context, x, 0.0f);
        CGContextAddLineToPoint(context, x, self.bounds.size.height);
    }
    
    CGContextStrokePath(context);

}
 */

@end
