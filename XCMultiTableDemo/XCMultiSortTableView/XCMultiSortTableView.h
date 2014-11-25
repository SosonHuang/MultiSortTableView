//
//  XCMultiTableView.h
//  XCMultiTableDemo
//
//  Created by Kingiol on 13-7-20.
//  Copyright (c) 2014.11  daming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CMPopTipView.h"
typedef NS_ENUM(NSUInteger, SortColumnType) {
    SortColumnTypeInteger,
    SortColumnTypeFloat,
    SortColumnTypeDate,
};

@protocol XCMultiTableViewDataSource;

@interface XCMultiTableView : UIView <CMPopTipViewDelegate>

@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat topHeaderHeight;
@property (nonatomic, assign) CGFloat leftHeaderWidth;
@property (nonatomic, assign) CGFloat sectionHeaderHeight;
@property (nonatomic, assign) CGFloat boldSeperatorLineWidth;
@property (nonatomic, assign) CGFloat normalSeperatorLineWidth;
@property (nonatomic, strong) NSString *deleStr;
@property (nonatomic, strong) UIColor *boldSeperatorLineColor;
@property (nonatomic, strong) UIColor *normalSeperatorLineColor;
//@property int vertexViewWidth;
//@property int vertexViewHeight;
//@property int scrollNumber;
@property (nonatomic, assign) BOOL leftHeaderEnable;

@property (nonatomic, weak) id<XCMultiTableViewDataSource> datasource;


- (void)reloadData;

@end

@protocol XCMultiTableViewDataSource <NSObject>

@required
- (NSArray *)arrayDataForTopHeaderInTableView:(XCMultiTableView *)tableView;
- (NSArray *)arrayDataForLeftHeaderInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section;
//- (NSArray *)arrayDataForContentInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section;

- (NSArray *)arrayNewDataForContentInTableView:(XCMultiTableView *)tableView;



@optional
- (NSUInteger)numberOfSectionsInXCTableView:(XCMultiTableView *)tableView;
- (CGFloat)tableView:(XCMultiTableView *)tableView contentTableCellWidth:(NSUInteger)column;
- (CGFloat)tableView:(XCMultiTableView *)tableView cellHeightInRow:(NSUInteger)row InSection:(NSUInteger)section;
- (CGFloat)topHeaderHeightInTableView:(XCMultiTableView *)tableView;
- (UIColor *)tableView:(XCMultiTableView *)tableView bgColorInSection:(NSUInteger)section InRow:(NSUInteger)row InColumn:(NSUInteger)column;
- (UIColor *)tableView:(XCMultiTableView *)tableView headerBgColorInColumn:(NSUInteger)column;

@end
