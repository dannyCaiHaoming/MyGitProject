//
//  GMPlayItemCollectionViewDataSource.h
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/1/31.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GMBasicPlayItem.h"
#import "GMVideoPlayItem.h"
#import "GMTransitionPlayItem.h"
#import "GMAddPlayItem.h"
#import "GMVideoPlayItemCollectionViewCell.h"
#import "GMAddPlayItemCollectionViewCell.h"
#import "GMTransitionCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef BOOL(^GMAddPlayItemBlock)(NSString **firstAssetUrl,NSString **secondAssetUrl);

@interface GMPlayItemCollectionViewDataSource : NSObject<UICollectionViewDataSource>
{
    NSMutableArray *playItemList_;
}

@property (nonatomic, readonly,strong) NSArray <GMBasicPlayItem *>*playItemList;

+ (instancetype)dataSourceWithCollecitonView:(UICollectionView *)collectionView;

- (void)addPlayItemListObject:(GMBasicPlayItem *)playItem;

- (void)removePlayItemListObject:(GMBasicPlayItem *)playItem;

@property (nonatomic, copy) GMAddPlayItemBlock addPlayItemBlock;


@end

NS_ASSUME_NONNULL_END
