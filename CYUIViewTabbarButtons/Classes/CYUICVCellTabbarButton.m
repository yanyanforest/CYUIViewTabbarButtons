//
//  CYUICVCellTabbarButton.m
//  TabbarButton
//
//  Created by yanyan on 2018/6/8.
//  Copyright © 2018年 yanyan. All rights reserved.
//

#import "CYUICVCellTabbarButton.h"
@interface CYUICVCellTabbarButton()
@property (strong, nonatomic) UILabel *titleLabel;

@end
@implementation CYUICVCellTabbarButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [UILabel new];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        NSDictionary *views = NSDictionaryOfVariableBindings(_titleLabel);
        NSString *verticalConstraints = [NSString stringWithFormat:@"V:|-%f-[_titleLabel]-%f-|", .0,.0];
        NSString *horizontalConstraints = [NSString stringWithFormat:@"H:|-%f-[_titleLabel]-%f-|",.0,.0];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraints options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalConstraints options:0 metrics:nil views:views]];
    }
    return self;
}

- (void)prepareForReuse
{
    self.title = nil;
    self.textColor = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    self.titleLabel.font = textFont;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.titleLabel.textColor = textColor;
}


@end
