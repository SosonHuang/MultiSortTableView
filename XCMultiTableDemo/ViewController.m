/*
 *  ViewController.m
 *  XCMultiTableDemo
 *
 * Created by Kingiol on 2013-07-19.
 * Copyright (c) 2014.11  daming. All rights reserved.
 *
 *
 */
#import "ViewController.h"

#import "UIButton+Additions.h"

#define foo4random() (1.0 * (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX)
#import "XCMultiSortTableView.h"

@interface ViewController () <XCMultiTableViewDataSource,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)	NSArray			*colorSchemes;
@property (nonatomic, strong)	NSDictionary	*contents;
@property (nonatomic, strong)	id				currentPopTipViewTarget;
@property (nonatomic, strong)	NSDictionary	*titles;
@property (nonatomic, strong)	NSMutableArray	*visiblePopTipViews;
@end

@implementation ViewController {
    NSMutableArray *headData;
    NSMutableArray *leftTableData;
    NSMutableArray *rightTableData;
    NSString *oneStr;
    NSMutableArray *newTableData;
    XCMultiTableView *tableView;
    CMPopTipView *popTipView;
   
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self initData];
    
    tableView = [[XCMultiTableView alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, 320, 568), 0.0f, 0.0f)];
    tableView.leftHeaderEnable = YES;
    tableView.datasource = self;
    [self.view addSubview:tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteData:) name:@"deleteData" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addData:) name:@"addData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageData:) name:@"imageData" object:nil];
    
    

}


-(void)imageData:(NSNotification*) notification{
   
    
    UIButton *btn = [notification object];
    
    [self btnMove:btn];
}

-(void)btnMove:(UIButton *)sender
{
    [self dismissAllPopTipViews];
    
    if (sender == self.currentPopTipViewTarget) {
        // Dismiss the popTipView and that is all
        self.currentPopTipViewTarget = nil;
    }
    else {
        
        
        UIView *view = [[UIView alloc] init];
        
        view.frame = CGRectMake(0, 0, 200, 167);
        view.backgroundColor = [UIColor clearColor];
        
        
//        UILabel *label = [[UILabel alloc] init];
//        label.frame = CGRectMake(0,0 , 90, 30);
//        label.backgroundColor = [UIColor redColor];
////        label.text =@"123";
//        [view addSubview:label];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0,0 , 90, 30);
        btn.backgroundColor = [UIColor redColor];
       [btn.titleLabel setTextColor:[UIColor blackColor]];
        
        [btn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
//        btn.titleLabel.textColor = [UIColor redColor];
        [btn addTarget:self action:@selector(clearData:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"清除此位置" forState:UIControlStateNormal];
        btn.tag = sender.tag;
        [view addSubview:btn];
        
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(110,0 , 90, 30);
        btn1.backgroundColor = [UIColor redColor];
        [btn1.titleLabel setTextColor:[UIColor blackColor]];
        
        [btn1 setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        //        btn.titleLabel.textColor = [UIColor redColor];
        [btn1 addTarget:self action:@selector(addNewData:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setTitle:@"换手表" forState:UIControlStateNormal];
        btn1.tag = sender.tag;
        [view addSubview:btn1];
        
        UITableView * table = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 200, 130)  style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        
        [view addSubview:table];
        

        
        popTipView = [[CMPopTipView alloc] initWithCustomView:view];
        
        popTipView.delegate = self;
        
        popTipView.animation = arc4random() % 2;
        popTipView.has3DStyle = (BOOL)(arc4random() % 2);
        
        popTipView.dismissTapAnywhere = YES;
//        [popTipView autoDismissAnimated:YES atTimeInterval:3.0];
        
        if ([sender isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)sender;
            [popTipView presentPointingAtView:button inView:self.view animated:YES];
        }
        else {
            UIBarButtonItem *barButtonItem = (UIBarButtonItem *)sender;
            [popTipView presentPointingAtBarButtonItem:barButtonItem animated:YES];
        }
        popTipView.backgroundColor = [UIColor whiteColor];
        [self.visiblePopTipViews addObject:popTipView];
        self.currentPopTipViewTarget = sender;
    }
    

}
-(void)addNewData:(UIButton*)btn
{
    int a = btn.tag;
    
//    [headData removeObjectAtIndex:a];
//    [newTableData removeObjectAtIndex:a];
//    
//    
//    [headData addObject:@[@"1.jpg",@"123123"]];
//    NSArray *arr4 = @[@"4",@"4",@"4",@"4"];
//    [newTableData addObject:arr4];
    
    [headData replaceObjectAtIndex:a withObject:@[@"1215.jpg",@"545"]];
    [newTableData replaceObjectAtIndex:a withObject:@[@"3",@"3",@"3",@"3"]];

     
    [popTipView removeFromSuperview];

    
    [tableView reloadData];
}
-(void)clearData:(UIButton*)btn
{
    
    if (btn.tag  ==0 ) {
        [headData removeObjectAtIndex:0];
        [newTableData removeObjectAtIndex:0];
        
    }else if (btn.tag  ==1) {
        [headData removeObjectAtIndex:1];
        [newTableData removeObjectAtIndex:1];
        
    }else if (btn.tag  ==2) {
        [headData removeObjectAtIndex:2];
        [newTableData removeObjectAtIndex:2];
        
    }else if (btn.tag  ==3) {
        [headData removeObjectAtIndex:3];
        [newTableData removeObjectAtIndex:3];
        
    }
    
    if (headData.count == 0) {
        [headData addObject:@[@"wechat-1.jpg",@"请点击图片"]];
        NSMutableArray *arr4 = [NSMutableArray arrayWithCapacity:10];;
        [newTableData addObject:arr4];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"oneData" object:nil];
    }
    
    [popTipView removeFromSuperview];
    [tableView reloadData];
    
    
    
}
- (void)dismissAllPopTipViews
{
    while ([self.visiblePopTipViews count] > 0) {
        CMPopTipView *popTipView = [self.visiblePopTipViews objectAtIndex:0];
        [popTipView dismissAnimated:YES];
        [self.visiblePopTipViews removeObjectAtIndex:0];
    }
}
#pragma mark - CMPopTipViewDelegate methods

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    [self.visiblePopTipViews removeObject:popTipView];
    self.currentPopTipViewTarget = nil;
        
}


#pragma mark - UIViewController methods

- (void)willAnimateRotationToInterfaceOrientation:(__unused UIInterfaceOrientation)toInterfaceOrientation duration:(__unused NSTimeInterval)duration
{
    for (CMPopTipView *popTipView in self.visiblePopTipViews) {
        id targetObject = popTipView.targetObject;
        [popTipView dismissAnimated:NO];
        
        if ([targetObject isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)targetObject;
            [popTipView presentPointingAtView:button inView:self.view animated:NO];
        }
        else {
            UIBarButtonItem *barButtonItem = (UIBarButtonItem *)targetObject;
            [popTipView presentPointingAtBarButtonItem:barButtonItem animated:NO];
        }
    }
}

-(void)addData:(NSNotification*) notification
{
    NSString *str = [notification object];
    
    if ([str isEqualToString:@"0"]) {
        [newTableData removeAllObjects];
          [headData removeAllObjects];
    }
    
     oneStr = str;
    [headData addObject:@[@"1.jpg",@"123123"]];
    NSArray *arr4 = @[@"4",@"4",@"4",@"4"];
    [newTableData addObject:arr4];
    
    [tableView reloadData];
}

-(void)deleteData:(NSNotification*) notification
{
    
     NSString *str = [notification object];
   
    NSLog(@"%@",str);
    
    if ([str isEqualToString:@"0"]) {
         [headData removeObjectAtIndex:0];
        [newTableData removeObjectAtIndex:0];
        
      
    }else if ([str isEqualToString:@"1"]) {
         [headData removeObjectAtIndex:1];
        [newTableData removeObjectAtIndex:1];

    }else if ([str isEqualToString:@"2"]) {
        [headData removeObjectAtIndex:2];
        [newTableData removeObjectAtIndex:2];

    }else if ([str isEqualToString:@"3"]) {
        
        [headData removeObjectAtIndex:3];
        [newTableData removeObjectAtIndex:3];

    }
    
    if (headData.count == 0) {
        [headData addObject:@[@"wechat-1.jpg",@"请点击图片"]];
        NSMutableArray *arr4 = [NSMutableArray arrayWithCapacity:10];;
        [newTableData addObject:arr4];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"oneData" object:nil];
    }
    
    
     [tableView reloadData];

}
- (void)initData {
    headData = [NSMutableArray arrayWithCapacity:10];
    
    // headData 头部栏~~~~*****************************************
    [headData addObject:@[@"1.jpg",@"123123"]];
    [headData addObject:@[@"1.jpg",@"123123"]];
    [headData addObject:@[@"1.jpg",@"123123"]];
    [headData addObject:@[@"1.jpg",@"123123"]];
    
//    [headData addObject:@[@"weibo.png",@"123123"]];
    
    
     // leftTableData 左部栏~~~~*****************************************
    leftTableData = [NSMutableArray arrayWithCapacity:100];
    NSMutableArray *one = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 2; i++) {
        [one addObject:[NSString stringWithFormat:@"ki-%d", i]];
    }
    [leftTableData addObject:one];
    NSMutableArray *two = [NSMutableArray arrayWithCapacity:20];
    for (int i = 2; i < 4; i++) {
        [two addObject:[NSString stringWithFormat:@"ki-%d", i]];
    }
    [leftTableData addObject:two];
 
    
    NSArray *arr1 = @[@"1",@"1",@"1",@"1"];
     NSArray *arr2 = @[@"2",@"2",@"2",@"2"];
     NSArray *arr3 = @[@"3",@"3",@"3",@"3"];
     NSArray *arr4 = @[@"4",@"4",@"4",@"4"];
    
    newTableData = [NSMutableArray arrayWithCapacity:100];
    
    
    
    [newTableData addObject:arr1];
    [newTableData addObject:arr2];
    [newTableData addObject:arr3];
    [newTableData addObject:arr4];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XCMultiTableViewDataSource


- (NSArray *)arrayDataForTopHeaderInTableView:(XCMultiTableView *)tableView {
    return [headData copy];
}
- (NSArray *)arrayDataForLeftHeaderInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    NSLog(@"%@",[leftTableData objectAtIndex:section]);
    return [leftTableData objectAtIndex:section];
}

-(NSArray*)arrayNewDataForContentInTableView:(XCMultiTableView *)tableView
{
    return [newTableData copy];
}

- (NSUInteger)numberOfSectionsInXCTableView:(XCMultiTableView *)tableView {
     NSLog(@"%lu",(unsigned long)[leftTableData count]);
    return [leftTableData count];
}

- (CGFloat)tableView:(XCMultiTableView *)tableView contentTableCellWidth:(NSUInteger)column {
    if (column == 0) {
        return 120.0f;
    }
    return 120.0f;
}


- (CGFloat)tableView:(XCMultiTableView *)tableView cellHeightInRow:(NSUInteger)row InSection:(NSUInteger)section {
    if (section == 0) {
        return 60.0f;
    }else {
        return 30.0f;
    }
}

- (UIColor *)tableView:(XCMultiTableView *)tableView bgColorInSection:(NSUInteger)section InRow:(NSUInteger)row InColumn:(NSUInteger)column {
//    if (row == 1 && section == 0) {
//        return [UIColor blueColor];
//    }
    return [UIColor clearColor];
}

- (UIColor *)tableView:(XCMultiTableView *)tableView headerBgColorInColumn:(NSUInteger)column {
//    if (column == -1) {
//        return [UIColor redColor];
//    }else if (column == 1) {
//        return [UIColor grayColor];
//    }
    return [UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"mytable"];
    if(nil == cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"mytable"];
    }
    
    NSArray *array1 = @[@"手表1",@"手表2",@"手表3",@"手表4",@"手表5"];
    
    cell.textLabel.text = array1[indexPath.row];
//    cell.textLabel.text            = [array1 objectAtIndex:2];
//    cell.detailTextLabel.text    = @"test again";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
 
        return @"替换为（最近对比的手表）";
  
}



@end
