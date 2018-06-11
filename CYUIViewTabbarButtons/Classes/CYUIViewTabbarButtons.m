//
//  CYUIViewTabbarButtons.m
//  TabbarButton
//
//  Created by yanyan on 2018/6/8.
//  Copyright © 2018年 yanyan. All rights reserved.
//
#import "CYUIViewTabbarButtons.h"
#import "CYUICVCellTabbarButton.h"
#import "CYTabbarButtonItem.h"
CGFloat const CYTabbarViewDefaultHeight = 44.0f;
CGFloat const CYTabbarViewDefaultPadding = 10.0f;
CGFloat const CYTabbarSelectionBoxDefaultTop = 6.0f;
CGFloat const CYTabbarViewDefaultAnimateTime = .2f;
CGFloat const CYTabbarViewDefaultHorizontalInset = 7.5f;

const NSString *   CYTabIndicatorViewHeight = @"CYTabIndicatorViewHeight";
const NSString *   CYTabIndicatorViewWidth = @"CYTabIndicatorViewWidth";
const NSString *  CYTabIndicatorCornerRadius = @"CYTabIndicatorCornerRadius";
const NSString *   CYTabIndicatorColor = @"CYTabIndicatorColor";
const NSString *  CYTabBoxBackgroundColor = @"CYTabBoxBackgroundColor";
#define CMHEXCOLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]

@interface CYUIViewTabbarButtons()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UIView *indicatorView;

@property (strong, nonatomic) NSArray *tabbarTitles;


@property (assign, nonatomic) NSInteger previousSelectedIndex;
@property (assign, nonatomic) CGFloat curSelectedIndex;
@property (assign, nonatomic) BOOL isExecuting;
@end
@implementation CYUIViewTabbarButtons
@synthesize selectedIndex = _selectedIndex;
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    _scrollEnable = YES;
    _tabPadding = 5.0f;
    _needTextGradient = true;
    _indicatorEqualTitleWidth = NO;
    _curSelectedIndex = 0;
    _selectionType = CYTabbarSelectionIndicator;
    _locationType = CYTabbarIndicatorLocationDown;
    _contentInset = UIEdgeInsetsMake(.0f, CYTabbarViewDefaultHorizontalInset, 0, CYTabbarViewDefaultHorizontalInset);
    _indicatorAttributes = @{CYTabIndicatorColor:CMHEXCOLOR(0x3ebd6e),CYTabIndicatorViewHeight:@(2.0f),CYTabBoxBackgroundColor:CMHEXCOLOR(0x3ebd6e)};
    _normalAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:CMHEXCOLOR(0x6d7989),NSBackgroundColorAttributeName:[UIColor whiteColor]};
    _selectedAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:CMHEXCOLOR(0x3ebd6e),NSBackgroundColorAttributeName:[UIColor whiteColor]};
}


#pragma mark - UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tabbarTitles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CYUICVCellTabbarButton *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CYUICVCellTabbarButton class]) forIndexPath:indexPath];
    CYTabbarButtonItem *item = self.tabbarTitles[indexPath.row];
    NSLog(@"选中的start -- %ld",(long)_selectedIndex);

    if (indexPath.row == _selectedIndex) {
        if (!item.selected) {
            item.selected = YES;
        }
        NSLog(@"选中的 end -- %ld",(long)self.selectedIndex);

        [self updateTabWithCurrentCell:cell nextCell:nil progress:1.0f backwards:true];
        [self updateIndicatorWithCell:cell indexPath:indexPath animate:false];
    } else {
        if (item.selected) {
            item.selected = NO;
        }
        
    }
    cell.object = item;
    cell.title = item.title;
    cell.contentView.backgroundColor = item.isSelected? self.selectedAttributes[NSBackgroundColorAttributeName]:self.normalAttributes[NSBackgroundColorAttributeName];
    cell.textColor = item.isSelected ? self.selectedAttributes[NSForegroundColorAttributeName] : self.normalAttributes[NSForegroundColorAttributeName];
    cell.textFont = item.isSelected ? self.selectedAttributes[NSFontAttributeName] : self.normalAttributes[NSFontAttributeName];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 滚动的
    if (_scrollEnable) {
        NSString *tabTitle = [self titleAtIndex:indexPath.row];
        CGSize size = [tabTitle sizeWithAttributes:self.normalAttributes];
        CGSize selectedSize = [tabTitle sizeWithAttributes:self.selectedAttributes];
        size = selectedSize.width > size.width ? selectedSize : size;
        return CGSizeMake(size.width + CYTabbarViewDefaultPadding, MIN(size.height+CYTabbarViewDefaultPadding, collectionView.bounds.size.height));
    } else {
        CGSize size = [[self titleAtIndex:indexPath.row] sizeWithAttributes:self.normalAttributes];
        CGFloat width = floor((self.bounds.size.width - (self.tabPadding+CYTabbarViewDefaultPadding) * (self.tabbarTitles.count - 1) - collectionView.contentInset.left - collectionView.contentInset.right)/self.tabbarTitles.count);
        return CGSizeMake(width, MIN(size.height+CYTabbarViewDefaultPadding, collectionView.bounds.size.height));
        
    }
    
}

#pragma mark - UICollectionViewDeleagte
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.isExecuting = YES;
    [self setSelectedIndex:indexPath.row animated:YES];
    [collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isExecuting = NO;
        
    });
    if (self.block_IndexPathSelected) {
        self.block_IndexPathSelected(indexPath);
    }
}

#pragma mark - Public Method

- (void)setDataSource:(id<CYUIViewTabbarDataSource>)dataSource
{
    NSParameterAssert(dataSource);
    _dataSource = dataSource;
    [self reloadData];
}

- (void)reloadData
{
    NSAssert([_dataSource respondsToSelector:@selector(tabbarTitlesForTabbarBottons:)], @"Method must be implement");
    self.tabbarTitles = [_dataSource tabbarTitlesForTabbarBottons:self];
    [self.collectionView reloadData];
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    _contentInset = contentInset;
    contentInset.bottom += [self.indicatorAttributes[CYTabIndicatorViewHeight] floatValue];
    self.collectionView.contentInset = contentInset;
}

- (void)setScrollEnable:(BOOL)scrollEnable
{
    _scrollEnable = scrollEnable;
    self.collectionView.scrollEnabled = scrollEnable;
}
//间距
- (void)setTabPadding:(CGFloat)tabPadding
{
    _tabPadding = tabPadding;
    [self.collectionView reloadData];
}
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:NO];
}
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated
{
    [self updateTabbarForTabbarOffset:index];
    [self setSelectedWithIndex:index];
    if (animated) {
        [UIView animateWithDuration:CYTabbarViewDefaultAnimateTime animations:^{
            [self updateTabbarForIndex:index animated:false];
        }];
    } else {
        [self updateTabbarForIndex:index animated:animated];
        
    }
    
}
- (void)setSelectionType:(CYTabbarSelectionType)selectionType
{
    _selectionType = selectionType;
    if (selectionType == CYTabbarSelectionBox) {
        self.indicatorView.backgroundColor = [_indicatorAttributes[CYTabBoxBackgroundColor] colorWithAlphaComponent:0.6];
        self.indicatorView.layer.cornerRadius = 3.0f;
        
    } else if (selectionType == CYTabbarSelectionIndicator) {
        self.indicatorView.backgroundColor = _indicatorAttributes[CYTabIndicatorColor];
    }
}

- (void)setIndicatorAttributes:(NSDictionary *)indicatorAttributes
{
    NSDictionary *defaultAttributes = @{CYTabIndicatorColor:CMHEXCOLOR(0x3ebd6e),CYTabIndicatorViewHeight:@(2.0f),CYTabBoxBackgroundColor:[UIColor orangeColor]};
    if (_indicatorAttributes) {
        defaultAttributes = _indicatorAttributes;
    }
    NSMutableDictionary *resultAttributes = [NSMutableDictionary dictionaryWithDictionary:defaultAttributes];
    [resultAttributes addEntriesFromDictionary:indicatorAttributes];
    _indicatorAttributes = [resultAttributes copy];
    if (_indicatorAttributes[CYTabIndicatorCornerRadius]) {
        self.indicatorView.layer.cornerRadius = [_indicatorAttributes[CYTabIndicatorCornerRadius] floatValue];
        self.indicatorView.layer.masksToBounds = YES;
        
    }
    if (_indicatorAttributes[CYTabIndicatorColor]) {
        _indicatorView.backgroundColor = _indicatorAttributes[CYTabIndicatorColor];
        
    }
}

- (void)setNormalAttributes:(NSDictionary *)normalAttributes
{
    NSDictionary *defaultAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:[UIColor blackColor]};
    if (_normalAttributes) {
        defaultAttributes = _normalAttributes;
    }
    
    NSMutableDictionary *resultAttributes = [NSMutableDictionary dictionaryWithDictionary:defaultAttributes];
    [resultAttributes addEntriesFromDictionary:normalAttributes];
    _normalAttributes = [resultAttributes copy];
}

- (void)setSelectedAttributes:(NSDictionary *)selectedAttributes
{
    NSDictionary *defaultAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:[UIColor orangeColor]};
    if (_selectedAttributes) {
        defaultAttributes = _selectedAttributes;
    }
    NSMutableDictionary *resultAttributes = [NSMutableDictionary dictionaryWithDictionary:defaultAttributes];
    [resultAttributes addEntriesFromDictionary:selectedAttributes];
    _selectedAttributes = [resultAttributes copy];
}

#pragma mark - Private Method
// 设置选中的item的属性selected
- (void)setSelectedWithIndex:(NSInteger)index
{
    for (int i = 0 ; i < self.tabbarTitles.count; i++) {
        CYTabbarButtonItem *item = self.tabbarTitles[i];
        if (index < self.tabbarTitles.count && self.tabbarTitles.count > 0 && index == i) {
                    _selectedIndex = index;
                    item.selected = YES;
                } else {
                    item.selected = NO;
                }
    }
}

- (void)updateTabbarForIndex:(NSInteger)index animated:(BOOL)animated
{
    CYUICVCellTabbarButton *cell = [self cellAtIndex:index];
    if (cell) {
        _previousSelectedIndex = _curSelectedIndex;
        _curSelectedIndex = index;

        CYUICVCellTabbarButton *preCell = [self cellAtIndex:_previousSelectedIndex];
        if (preCell) {
            preCell.textFont = self.normalAttributes[NSFontAttributeName];
            preCell.textColor = self.normalAttributes[NSForegroundColorAttributeName];
        }
        cell.textColor = self.selectedAttributes[NSForegroundColorAttributeName];
        cell.textFont = self.selectedAttributes[NSFontAttributeName];
        [self updateIndicatorWithCell:cell indexPath:[NSIndexPath indexPathForRow:index inSection:0] animate:animated];
        
    }
}
- (void)updateIndicatorWithCell:(CYUICVCellTabbarButton *)cell indexPath:(NSIndexPath *)indexPath animate:(BOOL)animate
{
    CGFloat originX = cell.frame.origin.x;
    CGFloat width = cell.frame.size.width;
    if (_indicatorEqualTitleWidth) {
        NSString *tabTitle = [self titleAtIndex:indexPath.row];
        CGSize size = [tabTitle sizeWithAttributes:self.selectedAttributes];
        originX = originX + cell.frame.size.width/2 - size.width/2.0;
        width = size.width;
    }
    if (![self.collectionView.visibleCells containsObject:cell]) { //fix edge
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:false];
        
    }
    if (animate) {
        [UIView animateWithDuration:CYTabbarViewDefaultAnimateTime animations:^{
            [self updateIndicatorFrameWithOriginX:originX width:width];
         
            }];
    } else {
        [self updateIndicatorFrameWithOriginX:originX width:width];
    }
    
         
}
//更新Indicator View 的位置和宽度
- (void)updateIndicatorFrameWithOriginX:(CGFloat)originX width:(CGFloat)width
{
    width = width - 2*self.tabPadding;
    originX = originX + self.tabPadding;
    CGFloat indicatorHeight = [self.indicatorAttributes[CYTabIndicatorViewHeight] floatValue];
    if (_selectionType == CYTabbarSelectionIndicator) {
        if (_locationType != CYTabbarIndicatorLocationNone) {
            if (self.indicatorAttributes[CYTabIndicatorViewWidth]) {
                CGFloat indicatorWidth = [self.indicatorAttributes[CYTabIndicatorViewWidth] floatValue];
                self.indicatorView.frame = CGRectMake(originX + width /2 - indicatorWidth/2, _locationType == CYTabbarIndicatorLocationDown ?  self.bounds.size.height - indicatorHeight : 0, indicatorWidth, indicatorHeight);
            } else {
                self.indicatorView.frame = CGRectMake(originX, _locationType == CYTabbarIndicatorLocationDown ?  self.bounds.size.height - indicatorHeight : 0, width, indicatorHeight);
            }
            
        }
    } else if (_selectionType == CYTabbarSelectionBox) {
        self.indicatorView.frame = CGRectMake(originX-CYTabbarViewDefaultPadding/2, CYTabbarSelectionBoxDefaultTop, width+CYTabbarViewDefaultPadding, self.collectionView.frame.size.height-2*CYTabbarSelectionBoxDefaultTop);
    }
    CGFloat scrollViewX = MAX(0, originX+width/2 - self.collectionView.bounds.size.width / 2.0f);
    [self.collectionView scrollRectToVisible:CGRectMake(scrollViewX, self.collectionView.frame.origin.y, self.collectionView.frame.size.width - self.contentInset.left - self.contentInset.right, self.collectionView.frame.size.height) animated:false];
}

- (CYUICVCellTabbarButton *)cellAtIndex:(NSInteger)index
{
    if (index >= 0 && index < self.tabbarTitles.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        return (CYUICVCellTabbarButton *)[self.collectionView cellForItemAtIndexPath:indexPath];
    }
    return nil;
}


- (NSString *)titleAtIndex:(NSInteger)index
{
    if (index < self.tabbarTitles.count && self.tabbarTitles.count > 0) {
        return [self.tabbarTitles[index] valueForKey:@"title"];
    }
    return @"";
    
}

- (void)updateTabbarForTabbarOffset:(CGFloat)tabOffset
{
    float address;
    CGFloat progress = (CGFloat)modff(tabOffset, &address);
    BOOL isBackwards = !(tabOffset >= self.previousSelectedIndex);
    
    if (tabOffset < .0f) {

        CYUICVCellTabbarButton *cell = [self cellAtIndex:0];
        [self updateTabWithCurrentCell:cell nextCell:cell progress:1.0f backwards:false];
        [self updateTabIndicatorWithCurrentCell:cell nextCell:cell progress:1.0f];
        [self setSelectedWithIndex:0];

    } else if (tabOffset > self.tabbarTitles.count - 1) {
        
        CYUICVCellTabbarButton *cell = [self cellAtIndex:self.tabbarTitles.count - 1];
        if (![self.collectionView.visibleCells containsObject:cell]) { //fix edge
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.tabbarTitles.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:false];
            return;
        }
        [self updateTabWithCurrentCell:cell nextCell:cell progress:1.0f backwards:false];
        [self updateTabIndicatorWithCurrentCell:cell nextCell:cell progress:1.0f];
        [self setSelectedWithIndex:self.tabbarTitles.count - 1];
    } else {
        
        if (fabs(progress) != .0f) {
            NSInteger currentTabIndex = isBackwards ? ceil(tabOffset) : floor(tabOffset);
            NSInteger nextTabIndex = MAX(0, MIN(self.tabbarTitles.count - 1, isBackwards ? floor(tabOffset) : ceil(tabOffset)));
            CYUICVCellTabbarButton *currentCell = [self cellAtIndex:currentTabIndex];
            CYUICVCellTabbarButton *nextCell = [self cellAtIndex:nextTabIndex];
            if (![self.collectionView.visibleCells containsObject:currentCell] && ![self.collectionView.visibleCells containsObject:nextCell]) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentTabIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
                [self.collectionView setNeedsLayout];
            }
            if ((currentCell && nextCell) && currentCell != nextCell) {
                [self updateTabWithCurrentCell:currentCell nextCell:nextCell progress:progress backwards:isBackwards];
                [self updateTabIndicatorWithCurrentCell:currentCell nextCell:nextCell progress:progress];
            }
        } else {
            NSInteger index = ceil(tabOffset);
            CYUICVCellTabbarButton *cell = [self cellAtIndex:index];
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
            if (cell && indexPath) {
                [self updateIndicatorWithCell:cell indexPath:indexPath animate:true];
                [self setSelectedWithIndex:index];
                [self.collectionView setNeedsLayout];
            } else {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            }
        }
    }
}

- (void) updateTabWithCurrentCell:(CYUICVCellTabbarButton *)currentCell nextCell:(CYUICVCellTabbarButton *)nextCell progress:(CGFloat)progress backwards:(BOOL)backwards
{
    if (backwards) {
        CYUICVCellTabbarButton *temp = nextCell;
        nextCell = currentCell;
        currentCell = temp;
    }
    if (!_needTextGradient) {
        currentCell.textColor = progress > .8f ? self.normalAttributes[NSForegroundColorAttributeName] : self.selectedAttributes[NSForegroundColorAttributeName];
        nextCell.textColor = progress >= .8f ?  self.selectedAttributes[NSForegroundColorAttributeName] : self.normalAttributes[NSForegroundColorAttributeName];
        
    } else {
        currentCell.textColor = [self getColorOfPercent:progress between:self.normalAttributes[NSForegroundColorAttributeName] and:self.selectedAttributes[NSForegroundColorAttributeName]];
        nextCell.textColor = [self getColorOfPercent:progress between:self.selectedAttributes[NSForegroundColorAttributeName] and:self.normalAttributes[NSForegroundColorAttributeName]];
    }
}

- (void)updateTabIndicatorWithCurrentCell:(CYUICVCellTabbarButton *)currentCell nextCell:(CYUICVCellTabbarButton *)nextCell progress:(CGFloat)progress
{
    if (!self.tabbarTitles.count) {
        return;
    }
    CGFloat maxX = MAX(nextCell.frame.origin.x, currentCell.frame.origin.x);
    CGFloat minX = MIN(nextCell.frame.origin.x, currentCell.frame.origin.x);
    BOOL isBack = (nextCell.frame.origin.x == minX);
    if (isBack) {
        CYUICVCellTabbarButton *temp = nextCell;
        nextCell = currentCell;
        currentCell = temp;
    }
    CGFloat currentTabWidth = currentCell.frame.size.width;
    CGFloat nextTabWidth = nextCell.frame.size.width;
    CGFloat widthDiff = (nextTabWidth - currentTabWidth) * progress;
    
    CGFloat newX = minX + ((maxX - minX) * progress);
    CGFloat newWidth = currentTabWidth + widthDiff;
    if (_indicatorEqualTitleWidth) {
        NSIndexPath *indexPath = [_collectionView indexPathForCell:nextCell];
        NSString *tabTitle = [self titleAtIndex:indexPath.row];
        CGSize size = [tabTitle sizeWithAttributes:self.normalAttributes];
        newX = minX + ((maxX - minX) * progress) + nextCell.frame.size.width/2 - size.width/2.0;
        newWidth = size.width;//currentTabWidth + widthDiff;
    }
    [self updateIndicatorFrameWithOriginX:newX width:newWidth];
}

- (UIColor *)getColorOfPercent:(CGFloat)percent between:(UIColor *)color1 and:(UIColor *)color2
{
    CGFloat red1, green1, blue1, alpha1;
    [color1 getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    CGFloat red2, green2, blue2, alpha2;
    [color2 getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    CGFloat p1 = percent;
    CGFloat p2 = 1.0 - percent;
    UIColor *mid = [UIColor colorWithRed:red1*p1+red2*p2 green:green1*p1+green2*p2 blue:blue1*p1+blue2*p2 alpha:1.0f];
    return mid;
}
#pragma mark - - --------- - -
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (!self.collectionView.superview) {
        [self addSubview:self.collectionView];
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false;
        NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView);
        NSString *verticalConstraints = [NSString stringWithFormat:@"V:|-%f-[_collectionView]-%f-|", .0,.0];
        NSString *horizontalConstraints = [NSString stringWithFormat:@"H:|-%f-[_collectionView]-%f-|",.0,.0];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraints options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalConstraints options:0 metrics:nil views:views]];
    }
    if (!self.indicatorView.superview) {
        [self.collectionView addSubview:self.indicatorView];
    }
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[CYUICVCellTabbarButton class] forCellWithReuseIdentifier:NSStringFromClass([CYUICVCellTabbarButton class])];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.scrollEnabled = _scrollEnable;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.contentInset = self.contentInset;
    }
    return _collectionView;
}

- (UIView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [UIView new];
        _indicatorView.userInteractionEnabled = false;
        _indicatorView.backgroundColor = _indicatorAttributes[CYTabIndicatorColor];
        
    }
    return _indicatorView;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
