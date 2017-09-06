//
//  CollectionViewCell.h
//  HealthFemale
//
//  Created by chenjie on 17/2/21.
//  Copyright © 2017年 chenjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectionViewCell;

@protocol  CollectionViewCellDelegate

@optional
- (void)collectioncellTaped:(CollectionViewCell*)cell;

@end

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic,   weak) id <CollectionViewCellDelegate> cellTapDelegate;//代理
@property (nonatomic, strong) UIScrollView *contentScrollView; //用于实现缩放功能的UISCrollView
@property (nonatomic, strong) UIView       *showView;//这个就是现实PDF文件内容的视图

@end
