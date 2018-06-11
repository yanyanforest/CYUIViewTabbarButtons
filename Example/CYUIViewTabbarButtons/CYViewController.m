//
//  CYViewController.m
//  CYUIViewTabbarButtons
//
//  Created by yanyanforest@163.com on 06/11/2018.
//  Copyright (c) 2018 yanyanforest@163.com. All rights reserved.
//

#import "CYViewController.h"
#import <CYUIViewTabbarButtons/CYUIViewTabbarButtons.h>
#import "CYUIViewTabbarButtons.h"
#define kScreenWidth [[UIScreen mainScreen]bounds].size.width

@interface CYViewController ()
@property(nonatomic,strong)CYUIViewTabbarButtons *headerView;
@property(nonatomic,strong)CYUIViewTabbarButtons *headerView1;
@property(nonatomic,strong)CYUIViewTabbarButtons *headerView2;
@property(nonatomic,strong)CYUIViewTabbarButtons *headerView3;

@property(nonatomic,strong)NSMutableArray *datasource;
@property(nonatomic,strong)NSMutableArray *datasource3;
@end

@implementation CYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSArray *titleArr = @[@"全部",@"待支付",@"已支付"];
    self.datasource = [NSMutableArray array];
    self.datasource3 = [NSMutableArray array];
    for (int i = 0; i< 3; i++) {
        CYTabbarButtonItem *item = [[CYTabbarButtonItem alloc]init];
        item.title = titleArr[i];
        item.selected = NO;
        [self.datasource addObject:item];
    }
    NSArray *titleArr3 = @[@"全部",@"待支付",@"已支付",@"待评价",@"退款",@"已完成"];
    
    for (int i = 0; i< 15; i++) {
        CYTabbarButtonItem *item = [[CYTabbarButtonItem alloc]init];
        NSInteger index = i % titleArr3.count;
        item.title = [NSString stringWithFormat:@"%d%@",i,titleArr3[index]];
        item.selected = NO;
        [self.datasource3 addObject:item];
    }
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.headerView1];
    [self.view addSubview:self.headerView2];
    [self.view addSubview:self.headerView3];
    [self.headerView1 reloadData];
    [self.headerView reloadData];
    [self.headerView2 reloadData];


}
-(IBAction)refreshView
{
    //    [self.datasource removeAllObjects];
    //    NSArray *titleArr = @[@"全部",@"待支付",@"已支付",@"待评价",@"退款",@"已完成"];
    //    NSInteger count = random()%titleArr.count;
    //    if (count <= 2) {
    //        count = 3;
    //    }
    //    for (int i = 0; i< count; i++) {
    //        CYTabbarButtonItem *item = [[CYTabbarButtonItem alloc]init];
    //        item.tabTitle = titleArr[i];
    //        if (i == 0) {
    //            item.selected = YES;
    //        } else {
    //        item.selected = NO;
    //        }
    //        [self.datasource addObject:item];
    //    }
    //    [self.headerView setSelectedIndex:0 animated:YES];
    //    self.headerView.selectedIndex = 0;
    //    self.headerView2.selectedIndex = 2;
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            self.headerView1.selectedIndex = 1;
    //            [self.headerView1 reloadData];
    //
    //        });
    //    });
    //
    //    [self.headerView reloadData];
    //    [self.headerView2 reloadData];
    //    [self.headerView3 setSelectedIndex:0 animated:YES];
    self.headerView3.selectedIndex = 0;
    [self.headerView3 reloadData];
}
- (IBAction)randomSelected:(id)sender{
    //    NSInteger selectedIndex = random() % self.datasource3.count;
    //    NSLog(@"随机选中 ----- %ld",selectedIndex);
    self.headerView3.selectedIndex = 0;
    [self.headerView3 reloadData];
    //    self.headerView.selectedIndex = random() % 3;
    //    self.headerView1.selectedIndex = random()%self.datasource.count;
    
}
- (CYUIViewTabbarButtons *)headerView
{
    if (!_headerView) {
        CGFloat fontSize = 13;
        _headerView = [[CYUIViewTabbarButtons alloc]initWithFrame:CGRectMake(0, 80, kScreenWidth , 40)];
        _headerView.backgroundColor = [UIColor clearColor];
        _headerView.locationType = CYTabbarIndicatorLocationDown;
        _headerView.indicatorAttributes = @{CYTabIndicatorColor:[UIColor redColor],CYTabIndicatorViewHeight:@(5),CYTabIndicatorViewWidth:@(5),CYTabBoxBackgroundColor:[UIColor redColor],CYTabIndicatorCornerRadius:@(1.5)};
        _headerView.normalAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:[UIColor redColor]};
        _headerView.selectedAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor purpleColor]};
        _headerView.selectionType = CYTabbarSelectionIndicator;
        _headerView.needTextGradient = NO;
        _headerView.scrollEnable = NO;
        _headerView.dataSource = self;
        
        _headerView.indicatorEqualTitleWidth = NO;
        
        UIView *line1View = [[UIView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 2 )/ 3.0, 10, 1, 20)];
        line1View.backgroundColor = [UIColor colorNamed:@"#f5f5f5"];
        [_headerView addSubview:line1View];
    }
    _headerView.block_IndexPathSelected = ^(NSIndexPath * _Nonnull indexPath) {
        NSLog(@"--- 选中");
    };
    
    return _headerView;
}

- (NSArray<NSDictionary *> *)tabbarTitlesForTabbarBottons:(CYUIViewTabbarButtons *)tabbarView
{
    if ([tabbarView isEqual:_headerView3]) {
        return self.datasource3;
    }
    return self.datasource;
}
-(CYUIViewTabbarButtons *)headerView1
{
    if (!_headerView1) {
        _headerView1 = [[CYUIViewTabbarButtons alloc]initWithFrame:CGRectMake(0, 150, kScreenWidth , 40)];
        _headerView1.backgroundColor = [UIColor clearColor];
        _headerView1.locationType = CYTabbarIndicatorLocationDown;
        //        _headerView1.indicatorAttributes = @{CYTabIndicatorColor:[UIColor redColor],CYTabIndicatorViewHeight:@(3),CYTabBoxBackgroundColor:[UIColor redColor],CYTabIndicatorCornerRadius:@(1.5)};
        //        _headerView1.normalAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        _headerView1.selectedAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor redColor]};
        _headerView1.selectionType = CYTabbarSelectionIndicator;
        _headerView1.needTextGradient = NO;
        _headerView1.scrollEnable = NO;
        _headerView1.dataSource = self;
        
        _headerView1.indicatorEqualTitleWidth = NO;
        
        _headerView1.block_IndexPathSelected = ^(NSIndexPath * _Nonnull indexPath) {
            NSLog(@"--- 选中  1");
        };
    }
    
    return _headerView1;
    
}
-(CYUIViewTabbarButtons *)headerView2
{
    if (!_headerView2) {
        _headerView2 = [[CYUIViewTabbarButtons alloc]initWithFrame:CGRectMake(0, 250, kScreenWidth , 40)];
        _headerView2.backgroundColor = [UIColor clearColor];
        _headerView2.selectedAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:19]};
        _headerView2.selectionType = CYTabbarSelectionBox;
        _headerView2.dataSource = self;
        _headerView2.block_IndexPathSelected = ^(NSIndexPath * _Nonnull indexPath) {
            NSLog(@"--- 选中  2");
        };
    }
    return _headerView2;
}
-(CYUIViewTabbarButtons *)headerView3
{
    if (!_headerView3) {
        _headerView3 = [[CYUIViewTabbarButtons alloc]initWithFrame:CGRectMake(0, 350, kScreenWidth , 40)];
        _headerView3.backgroundColor = [UIColor clearColor];
        _headerView3.selectedAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:19]};
        _headerView3.selectionType = CYTabbarSelectionBox;
        _headerView3.dataSource = self;
        _headerView3.block_IndexPathSelected = ^(NSIndexPath * _Nonnull indexPath) {
            NSLog(@"------------------");
        };
    }
    return _headerView3;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
