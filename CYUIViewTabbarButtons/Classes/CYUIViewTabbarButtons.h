//
//  CYUIViewTabbarButtons.h
//  TabbarButton
//
//  Created by yanyan on 2018/6/8.
//  Copyright © 2018年 yanyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYTabbarButtonItem.h"
// 选中的指示框，可选类型，box 和 下划线类似
typedef NS_ENUM(NSInteger,CYTabbarSelectionType) {
    CYTabbarSelectionIndicator,
    CYTabbarSelectionBox,
};
// 指示的位置
typedef NS_ENUM(NSInteger, CYTabbarIndicatorType) {
    CYTabbarIndicatorLocationDown,//
    CYTabbarIndicatorLocationUp,//
    CYTabbarIndicatorLocationNone//
};
typedef void (^Block_Indexpath) (NSIndexPath  * _Nonnull indexPath);
//  
extern NSString *CYTabIndicatorViewHeight;
extern NSString *CYTabIndicatorViewWidth;
extern NSString *CYTabIndicatorColor;
extern NSString *CYTabBoxBackgroundColor;
extern NSString *CYTabIndicatorCornerRadius;


@class CYUIViewTabbarButtons;
@protocol CYUIViewTabbarDataSource <NSObject>
- (NSArray<CYTabbarButtonItem *> *)tabbarTitlesForTabbarBottons:(CYUIViewTabbarButtons *)tabbarView;

@end

@interface CYUIViewTabbarButtons : UIView
@property(nonatomic,weak) id<CYUIViewTabbarDataSource> dataSource;
@property(nonatomic,strong)Block_Indexpath _Nullable block_IndexPathSelected;
@property(nonatomic,assign)BOOL indicatorEqualTitleWidth;//是否和 title等宽,反之与cell等宽
/**
 Whether the user need color Gradient,Default is true
 */
@property (assign, nonatomic) BOOL needTextGradient;

/**
 Specifies the type of selection
 Default is CMTabbarSelectionIndicator
 */
@property (assign, nonatomic) CYTabbarSelectionType selectionType;
/**
 Specifies the type of indication
 Default is CMTabbarIndicatorLocationDown
 */
@property (assign, nonatomic) CYTabbarIndicatorType locationType;
/**
 The attributes for the tab indicator
     (CMTabIndicatorViewHeight,
     CMTabIndicatorViewWidth,
     CMTabIndicatorColor,
     CMTabBoxBackgroundColor)
 */
@property (strong, nonatomic) NSDictionary * _Nullable indicatorAttributes;
/**
 The attributes for tabs (NSForegroundColorAttributeName, NSFontAttributeName, NSBackgroundColorAttributeName)
 */
@property (strong, nonatomic) NSDictionary * _Nullable normalAttributes;
/**
 The attributes for selected tabs (NSForegroundColorAttributeName, NSFontAttributeName, NSBackgroundColorAttributeName)
 */
@property (strong, nonatomic) NSDictionary * _Nullable selectedAttributes;
/**
 Whether the user can scroll the tabbar
 */
@property (assign, nonatomic) BOOL scrollEnable;
/**
 padding Value,Default is 5.0
 */
@property (assign, nonatomic) CGFloat tabPadding;

/**
 Content Inset
 */
@property (assign, nonatomic) UIEdgeInsets contentInset;

/**
 Set the current selected tab
 */
@property(nonatomic,assign)NSInteger selectedIndex;
-(void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;
- (void)reloadData;

@end
