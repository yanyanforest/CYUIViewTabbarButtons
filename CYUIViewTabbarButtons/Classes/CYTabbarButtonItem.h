//
//  CYTabbarButtonItem.h
//  TabbarButton
//
//  Created by yanyan on 2018/6/8.
//  Copyright © 2018年 yanyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYTabbarButtonItem : NSObject
@property (assign,nonatomic, getter=isSelected)BOOL selected;

@property (copy,nonatomic) NSString *title;

@end
