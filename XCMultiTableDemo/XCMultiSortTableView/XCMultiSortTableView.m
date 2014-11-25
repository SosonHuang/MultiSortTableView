//
//  XCMultiTableView.h
//  XCMultiTableDemo
//
//  Created by Kingiol on 13-7-20.
//  Copyright (c) 2014.11  daming. All rights reserved.
//

#import "XCMultiSortTableView.h"

#import "XCMultiSortTableViewDefault.h"
#import "XCMultiSortTableViewBGScrollView.h"

#import "UIView+XCMultiSortTableView.h"

#define AddHeightTo(v, h) { CGRect f = v.frame; f.size.height += h; v.frame = f; }

typedef NS_ENUM(NSUInteger, TableColumnSortType) {
    TableColumnSortTypeAsc,
    TableColumnSortTypeDesc,
    TableColumnSortTypeNone
};

@interface XCMultiTableView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

- (void)reset;
- (void)adjustView;
- (void)setUpTopHeaderScrollView;
- (void)accessColumnPointCollection;
- (void)buildSectionFoledStatus:(NSInteger)section;

- (CGFloat)accessContentTableViewCellWidth:(NSUInteger)column;
- (UITableViewCell *)leftHeaderTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)contentTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic,assign) UIButton *leftBtn;
@property (nonatomic,assign) UIButton *rightBtn;
@end

@implementation XCMultiTableView {
    XCMultiTableViewBGScrollView *topHeaderScrollView;
    XCMultiTableViewBGScrollView *contentScrollView;
    UITableView *leftHeaderTableView;
    UITableView *contentTableView;
    UIView *vertexView;
    UIView *subView;
    
    UIImageView *img;
   
    NSString *colStr;
    UIView *topView;
    CGFloat widthFour;
    CGFloat widthThree;
    CGFloat widthTwo;
    CGFloat widthOne;
    
    NSMutableDictionary *sectionFoldedStatus;
    NSArray *columnPointCollection;
    UIButton *firstButton;
    UIButton *twoButton;
    UIButton *newButton;
    NSMutableArray *leftHeaderDataArray;
    NSMutableArray *contentDataArray;
    NSMutableArray *newDataArray;
    NSMutableDictionary *columnTapViewDict;
    
    NSMutableDictionary *columnSortedTapFlags;
    
    BOOL responseToNumberSections;
    BOOL responseContentTableCellWidth;
    BOOL responseNumberofContentColumns;
    BOOL responseCellHeight;
    BOOL responseTopHeaderHeight;
    BOOL responseBgColorForColumn;
    BOOL responseHeaderBgColorForColumn;
}

@synthesize cellWidth, cellHeight, topHeaderHeight, leftHeaderWidth, sectionHeaderHeight, boldSeperatorLineWidth, normalSeperatorLineWidth,deleStr;
@synthesize boldSeperatorLineColor, normalSeperatorLineColor;
//@synthesize vertexViewWidth;
//@synthesize  vertexViewHeight;
@synthesize leftHeaderEnable;

@synthesize datasource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    
    
    if (self) {
        self.layer.borderColor = [[UIColor colorWithWhite:XCMultiTableView_BoraerColorGray alpha:1.0f] CGColor];
        self.layer.cornerRadius = XCMultiTableView_CornerRadius;
        self.layer.borderWidth = XCMultiTableView_BorderWidth;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        cellWidth = XCMultiTableView_DefaultCellWidth;
        cellHeight = XCMultiTableView_DefaultCellHeight;
        leftHeaderWidth = XCMultiTableView_DefaultLeftHeaderWidth;
        //        vertexViewWidth = XCMultiTableView_DefaultLeftHeaderWidth;
        //        vertexViewHeight = XCMultiTableView_DefaultTopHeaderHeight;
        topHeaderHeight = XCMultiTableView_DefaultTopHeaderHeight;
        sectionHeaderHeight = XCMultiTableView_DefaultSectionHeaderHeight;
        
        boldSeperatorLineWidth = XCMultiTableView_DefaultBoldLineWidth;
        normalSeperatorLineWidth = XCMultiTableView_DefaultNormalLineWidth;
        
        boldSeperatorLineColor = [UIColor colorWithWhite:XCMultiTableView_DefaultLineGray alpha:1.0];
        normalSeperatorLineColor = [UIColor colorWithWhite:XCMultiTableView_DefaultLineGray alpha:1.0];
        
        vertexView = [[UIView alloc] initWithFrame:CGRectZero];
        vertexView.backgroundColor = [UIColor clearColor];
        vertexView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:vertexView];
        
        topHeaderScrollView = [[XCMultiTableViewBGScrollView alloc] initWithFrame:CGRectZero];
        topHeaderScrollView.backgroundColor = [UIColor clearColor];
        topHeaderScrollView.parent = self;
        topHeaderScrollView.delegate = self;
        topHeaderScrollView.showsHorizontalScrollIndicator = NO;
        topHeaderScrollView.showsVerticalScrollIndicator = NO;
        topHeaderScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:topHeaderScrollView];
        
        leftHeaderTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        leftHeaderTableView.dataSource = self;
        leftHeaderTableView.delegate = self;
        leftHeaderTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        leftHeaderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        leftHeaderTableView.backgroundColor = [UIColor clearColor];
        [self addSubview:leftHeaderTableView];
        
        contentScrollView = [[XCMultiTableViewBGScrollView alloc] initWithFrame:CGRectZero];
        contentScrollView.backgroundColor = [UIColor clearColor];
        contentScrollView.parent = self;
        contentScrollView.delegate = self;
        contentScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:contentScrollView];
        
        contentTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        contentTableView.dataSource = self;
        contentTableView.delegate = self;
        contentTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        contentTableView.backgroundColor = [UIColor clearColor];
        [contentScrollView addSubview:contentTableView];
        
        leftHeaderTableView.showsVerticalScrollIndicator =NO;
        //         contentTableView.showsVerticalScrollIndicator =NO;
        contentScrollView.showsVerticalScrollIndicator = YES;
        contentScrollView.bounces = NO;
        topHeaderScrollView.bounces = NO;
        contentTableView.bounces = YES;
        
        
        contentTableView.layer.borderWidth = 1;
        contentTableView.layer.borderColor = [boldSeperatorLineColor CGColor];
        
        leftHeaderTableView.layer.borderWidth = 1;
        leftHeaderTableView.layer.borderColor = [boldSeperatorLineColor CGColor];
        
        //        topHeaderScrollView.layer.borderWidth = 1;
        //        topHeaderScrollView.layer.borderColor = [boldSeperatorLineColor CGColor];
        //
        //        vertexView.layer.borderWidth = 1;
        //        vertexView.layer.borderColor = [boldSeperatorLineColor CGColor];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(doRotateAction:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        
        
        [self addLeftAndRightBtn];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat superWidth = self.bounds.size.width;
    CGFloat superHeight = self.bounds.size.height;
    
    if (leftHeaderEnable) {
        
        //        vertexViewWidth = leftHeaderWidth;
        //        vertexViewHeight = topHeaderHeight;
        
        vertexView.frame = CGRectMake(0, 0, leftHeaderWidth, topHeaderHeight );
        topHeaderScrollView.frame = CGRectMake(leftHeaderWidth + boldSeperatorLineWidth, 0, superWidth - leftHeaderWidth - boldSeperatorLineWidth, topHeaderHeight);
        leftHeaderTableView.frame = CGRectMake(0, topHeaderHeight + boldSeperatorLineWidth + 10, leftHeaderWidth, superHeight - topHeaderHeight - boldSeperatorLineWidth);
        contentScrollView.frame = CGRectMake(leftHeaderWidth + boldSeperatorLineWidth, topHeaderHeight + boldSeperatorLineWidth + 10, superWidth - leftHeaderWidth - boldSeperatorLineWidth, superHeight - topHeaderHeight - boldSeperatorLineWidth);
        
        contentTableView.frame = CGRectMake(leftHeaderWidth + boldSeperatorLineWidth, topHeaderHeight + boldSeperatorLineWidth + 10, superWidth - leftHeaderWidth - boldSeperatorLineWidth, superHeight - topHeaderHeight - boldSeperatorLineWidth);
    }else {
        topHeaderScrollView.frame = CGRectMake(0, 0, superWidth, topHeaderHeight);
        contentScrollView.frame = CGRectMake(0, topHeaderHeight + boldSeperatorLineWidth, superWidth, superHeight - topHeaderHeight - boldSeperatorLineWidth);
    }
    
    [self adjustView];
}

- (void)reloadData {
    [self reset];
    
    
    [leftHeaderTableView reloadData];
    [contentTableView reloadData];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //
    //    CGContextSetLineWidth(context, boldSeperatorLineWidth );
    //    CGContextSetAllowsAntialiasing(context, false);
    //    CGContextSetStrokeColorWithColor(context, [boldSeperatorLineColor CGColor]);
    //
    //    if (leftHeaderEnable) {
    //        CGFloat x = leftHeaderWidth + boldSeperatorLineWidth / 2.0f;
    //        CGContextMoveToPoint(context, x, 134.0f);
    //        CGContextAddLineToPoint(context, x, self.bounds.size.height);
    //        CGFloat y = topHeaderHeight + boldSeperatorLineWidth / 2.0f;
    //        CGContextMoveToPoint(context, 0.0f, y);
    //        CGContextAddLineToPoint(context, self.bounds.size.width, y);
    //    }else {
    //        CGFloat y = topHeaderHeight + boldSeperatorLineWidth / 2.0f;
    //        CGContextMoveToPoint(context, 0.0f, y);
    //        CGContextAddLineToPoint(context, self.bounds.size.width, y);
    //    }
    //
    //    CGContextStrokePath(context);
}

- (void)dealloc {
    topHeaderScrollView = nil;
    contentScrollView = nil;
    leftHeaderTableView = nil;
    contentTableView = nil;
    vertexView = nil;
    columnPointCollection = nil;
}

#pragma mark - property

- (void)setDatasource:(id<XCMultiTableViewDataSource>)datasource_ {
    if (datasource != datasource_) {
        datasource = datasource_;
        
        responseToNumberSections = [datasource_ respondsToSelector:@selector(numberOfSectionsInTableView:)];
        responseContentTableCellWidth = [datasource_ respondsToSelector:@selector(tableView:contentTableCellWidth:)];
        responseNumberofContentColumns = [datasource_ respondsToSelector:@selector(arrayDataForTopHeaderInTableView:)];
        responseCellHeight = [datasource_ respondsToSelector:@selector(tableView:cellHeightInRow:InSection:)];
        responseTopHeaderHeight = [datasource_ respondsToSelector:@selector(topHeaderHeightInTableView:)];
        responseBgColorForColumn = [datasource_ respondsToSelector:@selector(tableView:bgColorInSection:InRow:InColumn:)];
        responseHeaderBgColorForColumn = [datasource_ respondsToSelector:@selector(tableView:headerBgColorInColumn:)];
        
        [self reset];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableView *target = nil;
    if (tableView == leftHeaderTableView) {
        target = contentTableView;
    }else if (tableView == contentTableView) {
        target = leftHeaderTableView;
    }else {
        target = nil;
    }
    [target selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //            deleStr = @"10";
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, [tableView rectForHeaderInSection:section].size.height)];;
    if (tableView == leftHeaderTableView) {
        UITapGestureRecognizer *leftRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftHeaderTap:)];
        
        //TODO:sectionColor  yellow
        view.backgroundColor = [UIColor yellowColor];
        if (section == 0) {
            UILabel *label = [[UILabel alloc] init];
            label.text = @"基本信息";
            label.font = [UIFont systemFontOfSize:10];
            label.frame = CGRectMake(5,5, 50, 10);
            [view addSubview:label];
        }
        
        if (section == 1) {
            UILabel *label = [[UILabel alloc] init];
            label.text = @"消失了一个";
            label.font = [UIFont systemFontOfSize:10];
            label.frame = CGRectMake(5,5, 50, 10);
            [view addSubview:label];
        }
        
        if (section == 2) {
            UILabel *label = [[UILabel alloc] init];
            label.text = @"AAAAAAA";
            label.font = [UIFont systemFontOfSize:10];
            label.frame = CGRectMake(5,5, 50, 10);
            [view addSubview:label];
        }
        
        
        view.tag = section;
        [view addGestureRecognizer:leftRecognizer];
    }else {
        
        NSUInteger count = [datasource arrayDataForTopHeaderInTableView:self].count;
        //        NSLog(@"有几个%d",count);
        
        
        for (int i = 0; i < count; i++) {
            CGFloat cellW = [self accessContentTableViewCellWidth:i];
            CGFloat cellH = [tableView rectForHeaderInSection:section].size.height;
            
            CGFloat width = [[columnPointCollection objectAtIndex:i] floatValue];
            subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellW, cellH)];
            subView.center = CGPointMake(width, cellH / 2.0f);
            subView.clipsToBounds = YES;
            
            subView.backgroundColor = [UIColor grayColor];
            
            
            NSString *tagStr = [NSString stringWithFormat:@"%d_%d", section, i];
            subView.tag = (int)tagStr;
            
            NSString *columnStr = [NSString stringWithFormat:@"%d_%d", section, i];
            [columnTapViewDict setObject:subView forKey:columnStr];
            
            
            if ([columnSortedTapFlags objectForKey:columnStr] == nil) {
                [columnSortedTapFlags setObject:[NSNumber numberWithInt:TableColumnSortTypeNone] forKey:columnStr];
            }
            
            
            //            UITapGestureRecognizer *contentHeaderGecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentHeaderTap:)];
            //
            //            [subView addGestureRecognizer:contentHeaderGecognizer];
            
            [view addSubview:subView];
        }
        
        if (newButton.tag == 0 && [deleStr isEqualToString:@"30"]) {
            subView.backgroundColor = [UIColor clearColor];
            
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oneData) name:@"oneData" object:nil];
        
        //        if (count == 1 && [deleStr isEqualToString:@"30"]) {
        //            subView.backgroundColor = [UIColor clearColor];
        //
        //        }
        //        if ([colStr isEqualToString:@"20"]) {
        //            subView.backgroundColor = [UIColor clearColor];
        //            [self changeData];
        //        }
        //
        //
        //        index = count;
        //
        //        NSLog(@"%d",count);
        
    }
    
    return view;
    
    
}


-(void)oneData
{
    deleStr = @"50";
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeightInIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSUInteger rows = 0;
    if (![self foldedInSection:section]) {
        rows = [self rowsInSection:section];
    }
    NSLog(@"%d",rows);
    return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return [self numberOfSections];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == leftHeaderTableView) {
        return [self leftHeaderTableView:tableView cellForRowAtIndexPath:indexPath];
    }else {
        return [self contentTableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

-(void)addLeftAndRightBtn
{
    
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.backgroundColor = [UIColor redColor];
    [_leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.frame = CGRectMake(0, self.bounds.size.height/2, 30, 30);
    
    [self addSubview:_leftBtn];
    
    
    
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.backgroundColor = [UIColor redColor];
    [_rightBtn addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.frame = CGRectMake(self.bounds.size.width -30, self.bounds.size.height/2, 30, 30);
    [self addSubview:_rightBtn];
    
    
}


-(void)leftBtn:(UIButton *)btn
{
    
    
    CGPoint offset = contentScrollView.contentOffset;
    
    offset.x -= 121;
    
    UIEdgeInsets edge = contentScrollView.contentInset;
    if (offset.x < -edge.left) {
        offset.x = -edge.left;
    } else if (offset.x > contentScrollView.contentSize.width - contentScrollView.bounds.size.width + edge.right) {
        offset.x = contentScrollView.contentSize.width - contentScrollView.bounds.size.width + edge.right;
    }
    
    [contentScrollView setContentOffset:offset animated:YES];
}

-(void)rightBtn:(UIButton *)btn
{
    CGPoint offset = contentScrollView.contentOffset;
    
    offset.x += 121;
    
    UIEdgeInsets edge = contentScrollView.contentInset;
    if (offset.x < -edge.left) {
        offset.x = -edge.left;
    } else if (offset.x > contentScrollView.contentSize.width - contentScrollView.bounds.size.width + edge.right) {
        offset.x = contentScrollView.contentSize.width - contentScrollView.bounds.size.width + edge.right;
    }
    
    
    if(offset.x < 0)
    {
        offset.x = 0;
    }
    [contentScrollView setContentOffset:offset animated:YES];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIScrollView *target = nil;
    if (scrollView == leftHeaderTableView) {
        target = contentTableView;
    }else if (scrollView == contentTableView) {
        target = leftHeaderTableView;
    }else if (scrollView == contentScrollView) {
        target = topHeaderScrollView;
    }else if (scrollView == topHeaderScrollView) {
        target = contentScrollView;
    }
    target.contentOffset = scrollView.contentOffset;
    
    
    if (scrollView.contentOffset.x > 240) {
        _rightBtn.hidden = YES;
    }else{
        _rightBtn.hidden = NO;
    }
    
    
    if (scrollView.contentOffset.x < 1) {
        _leftBtn.hidden = YES;
    }else{
        _leftBtn.hidden = NO;
    }
    
    
    //
    //    if(scrollView.contentOffset.y > 120 && scrollView.contentOffset.y <200){
    //
    //
    //        NSLog(@"200");
    //
    //        vertexViewHeight = 240-scrollView.contentOffset.y;
    //
    //        firstButton.frame = CGRectMake(0, 0, vertexViewWidth, vertexViewHeight/2);
    //        twoButton.frame = CGRectMake(0, vertexViewHeight/2, vertexViewWidth, vertexViewHeight/2);
    //
    //    topHeaderHeight = 240-scrollView.contentOffset.y ;
    //
    //
    //     [self layoutSubviews];
    //
    //
    //    }
    //
    //
    //
    //    if(scrollView.contentOffset.y == 0  ){
    //
    //        NSLog(@"200");
    //
    //        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut
    //                         animations:^{
    //                             topHeaderHeight = 120 ;
    //
    //                              [self layoutSubviews];
    //                         }
    //
    //                         completion:^(BOOL finished){
    //
    //                         }
    //
    //         ];
    //
    //
    //
    //
    //
    //    }
    
    
}

#pragma mark - private method

- (void)reset {
    
    columnTapViewDict = [NSMutableDictionary dictionary];
    columnSortedTapFlags = [NSMutableDictionary dictionary];
    
    [self accessDataSourceData];
    
    vertexView.backgroundColor = [UIColor  redColor];
    firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, leftHeaderWidth, topHeaderHeight/2);
    [firstButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    firstButton.backgroundColor = [UIColor greenColor];
    [firstButton setTitle:@"！！对比" forState:UIControlStateNormal];
    [vertexView addSubview:firstButton];
    
    twoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    twoButton.frame = CGRectMake(0, topHeaderHeight/2, leftHeaderWidth, topHeaderHeight/2);
    [twoButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [twoButton setTitle:@"~~~~对比" forState:UIControlStateNormal];
    [vertexView addSubview:twoButton];
    
    
    //    vertexView.backgroundColor = [self headerBgColorColumn:-1];
    [self accessColumnPointCollection];
    [self buildSectionFoledStatus:-1];
    [self setUpTopHeaderScrollView];
    
    [contentScrollView newReDraw];
    
}
-(void)btnAction:(UIButton*)btn
{
    NSLog(@"123");
}
- (void)adjustView {
    
    CGFloat width = 0.0f;
    
    NSUInteger count = [datasource arrayDataForTopHeaderInTableView:self].count;
    
    if (count < 4 && count ==3 ) {
        count = 4;
    }else if (count < 3 && count ==2 ) {
        count = 3;
    }else if (count < 2 && count ==1 ) {
        count = 2;
    }
    
    for (int i = 1; i <= count + 1; i++) {
        if (i == count + 1) {
            width += normalSeperatorLineWidth;
        }else {
            width += normalSeperatorLineWidth + [self accessContentTableViewCellWidth:i - 1];
        }
    }
     contentTableView.hidden = NO;
    if ([deleStr isEqualToString:@"50"]) {
        count = 1;
        
        width = normalSeperatorLineWidth + [self accessContentTableViewCellWidth: 1];
        
                deleStr = @"30";
        
        contentTableView.hidden = YES;
    }
    
    
    NSLog(@"width:%f, height:%f", self.frame.size.width, self.frame.size.height);
    
    topHeaderScrollView.contentSize = CGSizeMake(width, topHeaderHeight);
    contentScrollView.contentSize = CGSizeMake(width, self.bounds.size.height - topHeaderHeight - boldSeperatorLineWidth);
    
    contentTableView.frame = CGRectMake(0.0f, 0.0f, width, self.bounds.size.height - topHeaderHeight - boldSeperatorLineWidth);
}

- (void)buildSectionFoledStatus:(NSInteger)section {
    if (sectionFoldedStatus == nil) sectionFoldedStatus = [NSMutableDictionary dictionary];
    
    NSUInteger sections = [self numberOfSections];
    for (int i = 0; i < sections; i++) {
        if (section == -1) {
            [sectionFoldedStatus setObject:[NSNumber numberWithBool:NO] forKey:[self sectionToString:i]];
        }else if (i == section) {
            if ([self foldedInSection:section]) {
                [sectionFoldedStatus setObject:[NSNumber numberWithBool:NO] forKey:[self sectionToString:section]];
            }else {
                [sectionFoldedStatus setObject:[NSNumber numberWithBool:YES] forKey:[self sectionToString:section]];
            }
            break;
        }
    }
}

- (void)setUpTopHeaderScrollView {
    
    NSUInteger count = [datasource arrayDataForTopHeaderInTableView:self].count;
    
    [topView removeFromSuperview];
    //    topView = nil;
    
    
    for(topView in [topHeaderScrollView subviews])
    {
        [topView removeFromSuperview];
    }
    
//    for (int i = 0; i < 4; i++) {
//        
//
            widthOne = 61;
    
            widthTwo = 182;
    
            widthThree = 303;
    
            widthFour = 424;
  
    for (int i = 0; i < count; i++) {
        
        CGFloat topHeaderW = [self accessContentTableViewCellWidth:i];
        CGFloat topHeaderH = [self accessTopHeaderHeight];
        
        CGFloat widthP = [[columnPointCollection objectAtIndex:i] floatValue];
        
//        if (i ==0 ) {
//            widthOne = widthP;
//            NSLog(@"%f",widthOne);
//        }
//        if (i ==1 ) {
//            widthTwo = widthP;
//            NSLog(@"%f",widthTwo);
//        }
//        if (i ==2 ) {
//            widthThree = widthP;
//        }
//        if (i ==3 ) {
//            widthFour = widthP;
//        }
        topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, topHeaderW, topHeaderH)];
        topView.clipsToBounds = YES;
        topView.center = CGPointMake(widthP, topHeaderH / 2.0f);
        topView.tag = i;
        
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [imageBtn setImage:[UIImage imageNamed:[[datasource arrayDataForTopHeaderInTableView:self] objectAtIndex:i][0]] forState:UIControlStateNormal];
        
        imageBtn.tag = i;
        
        [imageBtn addTarget:self action:@selector(imageBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        imageBtn.frame = CGRectMake(0,0,topView.frame.size.width, topView.frame.size.height);
        [topView addSubview:imageBtn];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"closeIcon.png"] forState:UIControlStateNormal];
        
        button.tag = i;
        
        [button addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
        
        button.frame = CGRectMake(topView.frame.size.width -30,20,30 , 30);
        [topView addSubview:button];
        
        if ([deleStr isEqualToString:@"50"]) {
            [button removeFromSuperview];
            
        }
        //        UITapGestureRecognizer *topHeaderGecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentHeaderTap:)];
        //
        //        [topView addGestureRecognizer:topHeaderGecognizer];
        
        NSString *columnStr = [NSString stringWithFormat:@"-1_%d", i];
        [columnTapViewDict setObject:topView forKey:columnStr];
        
        if ([columnSortedTapFlags objectForKey:columnStr] == nil) {
            [columnSortedTapFlags setObject:[NSNumber numberWithInt:TableColumnSortTypeNone] forKey:columnStr];
        }
        
        [topHeaderScrollView addSubview:topView];
    }
    
    if (count < 4 && count == 3) {
        
        [self addImage:4 width:widthFour btnTag:4] ;
        
    }else if (count < 3 && count == 2) {
        
        [self addImage:3 width:widthThree btnTag:3];
        
    }else if (count < 2  && count == 1) {
        
        [self addImage:2 width:widthTwo btnTag:2];
        
    }else  if (count < 1 && count == 0 ) {
        
        [self addImage:1 width:widthOne btnTag:1];
        
    }
    
    if ([deleStr isEqualToString:@"50"]) {
        
        [topView removeFromSuperview];
        [self addImage:1 width:widthOne btnTag:0] ;
//        deleStr = @"30";
        
    }
    //    topHeaderScrollView.contentSize = CGSizeMake(485-120, topHeaderHeight);
    
    [self adjustView];
    
    [topHeaderScrollView reDraw];
    
}

-(void)imageBtn:(UIButton *)btn
{
    //    NSString *abc = [NSString stringWithFormat:@"%d",btn.tag];
    
    NSLog(@"%f", btn.frame.origin.x);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imageData" object:btn];
    
    if(btn.tag ==0){
        NSLog(@"点击第一个");
    }
    if(btn.tag ==1){
        NSLog(@"点击第2个");
    }
    if(btn.tag ==2){
        NSLog(@"点击第3个");
    }
    if(btn.tag ==3){
        NSLog(@"点击第4个");
    }
}
-(void)deleteButton:(UIButton*)btn
{
    NSString *abc = [NSString stringWithFormat:@"%d",btn.tag];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteData" object:abc];
}
-(void)addBtn:(UIButton*)btn
{
    //    [datasource arrayDataForTopHeaderInTableView:self].count;
    NSString *abc = [NSString stringWithFormat:@"%d",btn.tag];
    NSLog(@"%d",btn.tag);
    //    if ([deleStr isEqualToString: @"30" ]  && btn.tag == 0) {
    //        abc = @"1";
    //    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addData" object:abc];
}
-(void)addImage:(int)index width:(CGFloat)width btnTag:(int)tag;
{
    
    CGFloat topHeaderW = [self accessContentTableViewCellWidth:index];
    CGFloat topHeaderH = [self accessTopHeaderHeight];
    
    CGFloat widthP = width;
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, topHeaderW, topHeaderH)];
    topView.clipsToBounds = YES;
    topView.center = CGPointMake(widthP, topHeaderH / 2.0f);
    topView.tag = index;
    
    newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [newButton setTitle:@"点击增加手表" forState:UIControlStateNormal];
    newButton.frame = CGRectMake(0, 0, topView.frame.size.width, topView.frame.size.height);
    
    [newButton addTarget:self action:@selector(addBtn:) forControlEvents:UIControlEventTouchUpInside];
    newButton.tag = tag ;
    
    UIColor *color = [self headerBgColorColumn:index];
    topView.backgroundColor = color;
    newButton.backgroundColor = [UIColor redColor];
    
    [topView addSubview:newButton];
    
    
    UITapGestureRecognizer *topHeaderGecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentHeaderTap:)];
    
    [topView addGestureRecognizer:topHeaderGecognizer];
    
    NSString *columnStr = [NSString stringWithFormat:@"-1_%d", index];
    [columnTapViewDict setObject:topView forKey:columnStr];
    
    if ([columnSortedTapFlags objectForKey:columnStr] == nil) {
        [columnSortedTapFlags setObject:[NSNumber numberWithInt:TableColumnSortTypeNone] forKey:columnStr];
    }
    
    [topHeaderScrollView addSubview:topView];
}
- (void)accessColumnPointCollection {
    NSUInteger columns = responseNumberofContentColumns ? [datasource arrayDataForTopHeaderInTableView:self].count : 0;
    if (columns == 0) @throw [NSException exceptionWithName:nil reason:@"number of content columns must more than 0" userInfo:nil];
    NSMutableArray *tmpAry = [NSMutableArray array];
    CGFloat widthColumn = 0.0f;
    CGFloat widthP = 0.0f;
    for (int i = 0; i < columns; i++) {
        CGFloat columnWidth = [self accessContentTableViewCellWidth:i];
        widthColumn += (normalSeperatorLineWidth + columnWidth);
        widthP = widthColumn - columnWidth / 2.0f;
        [tmpAry addObject:[NSNumber numberWithFloat:widthP]];
    }
    columnPointCollection = [tmpAry copy];
}

- (CGFloat)accessContentTableViewCellWidth:(NSUInteger)column {
    return responseContentTableCellWidth ? [datasource tableView:self contentTableCellWidth:column] : cellWidth;
}

- (UITableViewCell *)leftHeaderTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *inde = @"leftHeaderTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inde];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inde];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addBottomLineWithWidth:normalSeperatorLineWidth bgColor:normalSeperatorLineColor];
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat cellH = [self cellHeightInIndexPath:indexPath];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftHeaderWidth, cellH)];
    view.clipsToBounds = YES;
    
    UILabel *label =  [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = [[leftHeaderDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [label sizeToFit];
    label.center = CGPointMake(leftHeaderWidth / 2.0f, cellH / 2.0f);
    
    UIColor *color = [self bgColorInSection:indexPath.section InRow:indexPath.row InColumn:-1];
    view.backgroundColor = color;
    label.backgroundColor = color;
    
    [view addSubview:label];
    
    [cell.contentView addSubview:view];
    
    AddHeightTo(cell, normalSeperatorLineWidth);
    
    return cell;
}

- (UITableViewCell *)contentTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger count = [datasource arrayDataForTopHeaderInTableView:self].count;
    static NSString *cellID = @"contentTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addBottomLineWithWidth:normalSeperatorLineWidth bgColor:normalSeperatorLineColor];
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //    NSMutableArray *ary = [[contentDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSMutableArray *ary1 = newDataArray[0];
    
    NSMutableArray * ary2 =ary1[0];
    
    for (int i = 0; i < count; i++) {
        
        CGFloat cellW = [self accessContentTableViewCellWidth:i];
        CGFloat cellH = [self cellHeightInIndexPath:indexPath];
        
        CGFloat width = [[columnPointCollection objectAtIndex:i] floatValue];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellW, cellH)];
        view.center = CGPointMake(width, cellH / 2.0f);
        view.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        //        NSLog(@"%@",ary);
        //        label.text = [NSString stringWithFormat:@"%@", [ary objectAtIndex:i]];
        
        if (ary2.count !=0 ) {
            label.text = [NSString stringWithFormat:@"%@", [ary1 objectAtIndex:i][i]];
        }
        
        [label sizeToFit];
        label.center = CGPointMake(cellW / 2.0f, cellH / 2.0f);
        
        //        UIColor *color = [self bgColorInSection:indexPath.section InRow:indexPath.row InColumn:i];
        //
        //        view.backgroundColor = color;
        //        label.backgroundColor = color;
        
        [view addSubview:label];
        
        [cell.contentView addSubview:view];
    }
    
    AddHeightTo(cell, normalSeperatorLineWidth);
    
    return cell;
}

#pragma mark - GestureRecognizer

- (void)leftHeaderTap:(UITapGestureRecognizer *)recognizer {
    
    @synchronized(self) {
        NSUInteger section = recognizer.view.tag;
        [self buildSectionFoledStatus:section];
        
        [leftHeaderTableView beginUpdates];
        [contentTableView beginUpdates];
        
        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:10];
        
        
        for (int i = 0; i < [self rowsInSection:section]; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        
        if ([self foldedInSection:section]) {
            [leftHeaderTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [contentTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }else {
            [leftHeaderTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [contentTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
        
        [leftHeaderTableView endUpdates];
        [contentTableView endUpdates];
    }
}

- (void)contentHeaderTap:(UITapGestureRecognizer *)recognizer {
    
    //TODO: 头部点击
    UIView *view = recognizer.view;
    
    NSIndexPath *indexPath = [self accessUIViewVirtualTag:view];
    
    NSUInteger length = [indexPath length];
    
    if (length != 2) return;
    
    NSInteger section = indexPath.section;
    NSInteger column = indexPath.row;
    
    NSString *columnStr = [NSString stringWithFormat:@"%d_%d", section, column];
    
    
    
    
    
    if (column == 0 ) {
        NSLog(@"点击第一个");
        
        
        
        
    }
    if (column == 1) {
        NSLog(@"点击第2个");
    }
    if (column == 2) {
        NSLog(@"点击第3个");
    }
    if (column == 3) {
        NSLog(@"点击第4个");
    }
    
    
    //    NSString *abc = [NSString stringWithFormat:@"%d",column];
    //
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"addData" object:abc];
    
    NSInteger columnFlag = [[columnSortedTapFlags objectForKey:columnStr] integerValue];
    
    
    NSLog(@"%d",columnFlag);
    //    if (section == -1) {
    //        NSUInteger rows = [self numberOfSections];
    //
    //        TableColumnSortType newType = TableColumnSortTypeNone;
    //
    //        if (columnFlag == TableColumnSortTypeNone || columnFlag == TableColumnSortTypeDesc) {
    //            newType = TableColumnSortTypeAsc;
    //        }else {
    //            newType = TableColumnSortTypeDesc;
    //        }
    //
    //        for (int i = 0; i < rows; i++) {
    //            NSIndexPath *iPath = [NSIndexPath indexPathForRow:column inSection:i];
    //
    //            NSString *str = [NSString stringWithFormat:@"%d_%d", iPath.section, iPath.row];
    //            [columnSortedTapFlags setObject:[NSNumber numberWithInt:columnFlag] forKey:str];
    //
    //            [self singleHeaderClick:iPath];
    //        }
    //        [columnSortedTapFlags setObject:[NSNumber numberWithInt:newType] forKey:columnStr];
    
    //    }else {
    //        [self singleHeaderClick:indexPath];
    //    }
    
    [leftHeaderTableView reloadData];
    [contentTableView reloadData];
    
}

- (void)singleHeaderClick:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger column = indexPath.row;
    
    NSString *columnStr = [NSString stringWithFormat:@"%d_%d", section, column];
    NSInteger columnFlag = [[columnSortedTapFlags objectForKey:columnStr] integerValue];
    
    NSArray *leftHeaderDataInSection = [leftHeaderDataArray objectAtIndex:section];
    NSArray *contentDataInSection = [contentDataArray objectAtIndex:section];
    
    NSArray *sortContentData = [contentDataInSection sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSComparisonResult result =  [[obj1 objectAtIndex:column] compare:[obj2 objectAtIndex:column]];
        
        return result;
    }];
    
    NSMutableArray *sortIndexAry = [NSMutableArray array];
    for (int i = 0; i < sortContentData.count; i++) {
        id objI = [sortContentData objectAtIndex:i];
        for (int j = 0; j < contentDataInSection.count; j++) {
            id objJ = [contentDataInSection objectAtIndex:j];
            if (objI == objJ) {
                [sortIndexAry addObject:[NSNumber numberWithInt:j]];
                break;
            }
        }
    }
    
    NSMutableArray *sortLeftHeaderData = [NSMutableArray array];
    for (id index in sortIndexAry) {
        int i = [index intValue];
        [sortLeftHeaderData addObject:[leftHeaderDataInSection objectAtIndex:i]];
    }
    
    if (columnFlag == TableColumnSortTypeNone || columnFlag == TableColumnSortTypeDesc) {
        columnFlag = TableColumnSortTypeAsc;
    }else {
        columnFlag = TableColumnSortTypeDesc;
        NSEnumerator *leftReverseEnumerator = [sortLeftHeaderData reverseObjectEnumerator];
        NSEnumerator *contentReverseEvumerator = [sortContentData reverseObjectEnumerator];
        sortLeftHeaderData = [NSMutableArray arrayWithArray:[leftReverseEnumerator allObjects]];
        sortContentData = [NSArray arrayWithArray:[contentReverseEvumerator allObjects]];
    }
    
    [leftHeaderDataArray replaceObjectAtIndex:section withObject:sortLeftHeaderData];
    [contentDataArray replaceObjectAtIndex:section withObject:sortContentData];
    
    [columnSortedTapFlags setObject:[NSNumber numberWithInt:columnFlag] forKey:columnStr];
    
}

#pragma mark - other method

- (NSUInteger)rowsInSection:(NSUInteger)section {
    return [[leftHeaderDataArray objectAtIndex:section] count];
}

- (NSUInteger)numberOfSections {
    NSUInteger sections = responseToNumberSections ? [datasource numberOfSectionsInXCTableView:self] : 1;
    return sections < 1 ? 1 : sections;
}

- (NSString *)sectionToString:(NSUInteger)section {
    return [NSString stringWithFormat:@"%d", section];
}

- (BOOL)foldedInSection:(NSUInteger)section {
    return [[sectionFoldedStatus objectForKey:[self sectionToString:section]] boolValue];
}

- (CGFloat)cellHeightInIndexPath:(NSIndexPath *)indexPath {
    return responseCellHeight ? [datasource tableView:self cellHeightInRow:indexPath.row InSection:indexPath.section] : cellHeight;
}

- (CGFloat)accessTopHeaderHeight {
    return responseTopHeaderHeight ? [datasource topHeaderHeightInTableView:self] : topHeaderHeight;
}

- (UIColor *)bgColorInSection:(NSUInteger)section InRow:(NSUInteger)row InColumn:(NSUInteger)column {
    return responseBgColorForColumn ? [datasource tableView:self bgColorInSection:section InRow:row InColumn:column] : [UIColor clearColor];
}

- (UIColor *)headerBgColorColumn:(NSUInteger)column {
    return responseHeaderBgColorForColumn ? [datasource tableView:self headerBgColorInColumn:column] : [UIColor clearColor];
}

- (void)accessDataSourceData {
    
    leftHeaderDataArray = [NSMutableArray array];
    contentDataArray = [NSMutableArray array];
    newDataArray = [NSMutableArray array];
    NSUInteger sections = [datasource numberOfSectionsInXCTableView:self];
    for (int i = 0; i < sections; i++) {
        [leftHeaderDataArray addObject:[datasource arrayDataForLeftHeaderInTableView:self InSection:i]];
        //        [contentDataArray addObject:[datasource arrayDataForContentInTableView:self InSection:i]];
    }
    
    //     [contentDataArray addObject:datasource ar]
    
    [newDataArray addObject:[datasource arrayNewDataForContentInTableView:self]];
    
    NSLog(@"%@",newDataArray);
    
}

- (NSIndexPath *)accessUIViewVirtualTag:(UIView *)view {
    for (NSString *key in [columnTapViewDict allKeys]) {
        UIView *vi = [columnTapViewDict objectForKey:key];
        if (vi == view) {
            NSArray *sep = [key componentsSeparatedByString:@"_"];
            NSUInteger section = [[sep objectAtIndex:0] integerValue];
            NSUInteger row = [[sep objectAtIndex:1] integerValue];
            
            return [NSIndexPath indexPathForRow:row inSection:section];
        }
    }
    return nil;
}

- (void)dismissAllPopTipViews
{
    
}
-(void)doRotateAction:(NSNotification *) notification
{
    if ([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown) {
        
        _rightBtn.hidden = NO;
        _leftBtn.hidden = NO;
    }else{
        _rightBtn.hidden = YES;
        _leftBtn.hidden = YES;
    }
    
}


@end
