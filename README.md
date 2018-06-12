# CYUIViewTabbarButtons
多个按钮展示，和tabbar 差不多，一般在列表的上面显示

1. How to use
```
// 创建
_headerView = [[CYUIViewTabbarButtons alloc]initWithFrame:CGRectMake(0, 80, kScreenWidth , 40)];
_headerView.backgroundColor = [UIColor clearColor];
// 设置Indicator 指示的所在选中item的位置
_headerView.locationType = CYTabbarIndicatorLocationDown;
// 设置Indicator属性。不设置显示默认
_headerView.indicatorAttributes = @{CYTabIndicatorColor:[UIColor redColor],CYTabIndicatorViewHeight:@(5),CYTabIndicatorViewWidth:@(5),CYTabBoxBackgroundColor:[UIColor redColor],CYTabIndicatorCornerRadius:@(1.5)};
// 设置 未选中状态下按钮的属性
_headerView.normalAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:[UIColor redColor]};
// 设置 选中状态下按钮的属性

_headerView.selectedAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor purpleColor]};
// 设置 选中的显示的类型

_headerView.selectionType = CYTabbarSelectionIndicator;

_headerView.needTextGradient = NO;
// 这些按钮是否可以滚动

_headerView.scrollEnable = NO;
// 设置代理
_headerView.dataSource = self;
// 设置indicator 是否和item名字等宽
_headerView.indicatorEqualTitleWidth = NO;
```
