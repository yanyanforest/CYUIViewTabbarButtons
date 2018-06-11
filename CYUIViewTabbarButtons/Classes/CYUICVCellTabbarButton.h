//
//  CYUICVCellTabbarButton.h
//  TabbarButton
//
//  Created by yanyan on 2018/6/8.
//  Copyright © 2018年 yanyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYUICVCellTabbarButton : UICollectionViewCell
@property(nonatomic,strong)id object;
@property (strong, nonatomic, nullable) UIColor *textColor;
@property (strong, nonatomic, nullable) UIFont *textFont;

//@property (strong, nonatomic, nullable) UIColor *selectedTextColor;

//@property (strong, nonatomic, nullable) UIFont *selectedTextFont;

@property (nonatomic, copy, nullable) NSString *title;
@end
