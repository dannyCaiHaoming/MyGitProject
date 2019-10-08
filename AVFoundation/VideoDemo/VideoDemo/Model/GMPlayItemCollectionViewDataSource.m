//
//  GMPlayItemCollectionViewDataSource.m
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/1/31.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "GMPlayItemCollectionViewDataSource.h"


static NSString * const GMVideoPlayItemCollectionViewCellID = @"GMVideoPlayItemCollectionViewCellID";
static NSString * const GMAddPlayItemCollectionViewCellID = @"GMAddPlayItemCollectionViewCellID";
static NSString * const GMTransitionPlayItemCollectionViewCellID = @"GMTransitionPlayItemCollectionViewCellID";


@interface GMPlayItemCollectionViewDataSource()

@property (nonatomic, weak) UICollectionView *collectionView;


@end

@implementation GMPlayItemCollectionViewDataSource

+ (instancetype)dataSourceWithCollecitonView:(UICollectionView *)collectionView{
    GMPlayItemCollectionViewDataSource *dataSource = [[GMPlayItemCollectionViewDataSource alloc] initWithCollectionView:collectionView];
    return dataSource;
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView{
    if (self = [super init]) {
        playItemList_ = [NSMutableArray arrayWithObjects:[GMAddPlayItem initialAddPlayItem], nil];
        self.collectionView = collectionView;
    }
    return self;
}

- (NSArray <GMBasicPlayItem *>*)playItemList{
    return (NSArray *)playItemList_;
}

- (void)addPlayItemListObject:(GMBasicPlayItem *)playItem{
    if (playItemList_ && playItem && playItem.type != kPlayItem_UnKnown) {
        
        if (playItem.type == kPlayItem_Video) {
            
            //先移除最后一个Add Item，然后添加不生效的Transition Item
            
            [playItemList_ removeLastObject];
            if (playItemList_.count != 0) {
                GMTransitionPlayItem *transitionPlayItem = [GMTransitionPlayItem initialTransitionPlayItem];
                [playItemList_ addObject:transitionPlayItem];
            }
        }
        
        float videoCount = 0;
        for (GMBasicPlayItem *item in playItemList_) {
            if (item.type == kPlayItem_Video) {
                videoCount++;
            }
        }
        
        CMTime startTime = CMTimeMakeWithSeconds(3 * videoCount, NSEC_PER_SEC);
//        CMTime durationTime = CMTimeMakeWithSeconds(3 , NSEC_PER_SEC);
        playItem.startTime = startTime;
//        playItem.durationTime = durationTime;
        
        [playItemList_ addObject:playItem];
        
        
        GMAddPlayItem *addPlayItem = [GMAddPlayItem initialAddPlayItem];
        [playItemList_ addObject:addPlayItem];
        
        
        //Todo:在添加一个视频item之后，需要在之前插入一个过渡的Item
        [self.collectionView reloadData];
    }
}

- (void)removePlayItemListObject:(GMBasicPlayItem *)playItem{
    if (playItem && playItem.type != kPlayItem_UnKnown) {
        
        //需要把前面的Transition Item也去掉
        if (playItem.type == kPlayItem_Video) {
            NSInteger index = [playItemList_ indexOfObject:playItem];
            if (index > 1) {
                [playItemList_ removeObjectAtIndex:index];
                [playItemList_ removeObjectAtIndex:index - 1];
            }
        }
        
        GMAddPlayItem *addPlayItem = [GMAddPlayItem initialAddPlayItem];
        [playItemList_ addObject:addPlayItem];
        
        [self.collectionView reloadData];
    }
}

#pragma mark -- UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return playItemList_.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GMBasicPlayItem *playItem = [playItemList_ objectAtIndex:indexPath.item];
    
    if (playItem.type == kPlayItem_Add) {
        //添加的Cell
        GMAddPlayItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[GMAddPlayItemCollectionViewCell identify] forIndexPath:indexPath];
        [cell.addBtn removeTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    if (playItem.type == kPlayItem_Video) {
        //Video的Cell
        GMVideoPlayItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[GMVideoPlayItemCollectionViewCell identify] forIndexPath:indexPath];
        
//        AVAssetImageGenerator
        
        dispatch_async(dispatch_get_main_queue(), ^{
            AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:[(GMVideoPlayItem *)playItem videoArray].firstObject];
            CGImageRef imageRef = [imageGenerator copyCGImageAtTime:kCMTimeZero actualTime:nil error:nil];
            cell.thumbImageView.image = [UIImage imageWithCGImage:imageRef];
        });
        
        return cell;
    }
    if (playItem.type == kPlayItem_Transition) {
        //过渡的Cell
        GMTransitionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[GMTransitionCollectionViewCell identify] forIndexPath:indexPath];
        
        cell.descriptionLabel.text = @"";
        
        NSString *description = @"没有效果";
        
        GMTransitionPlayItem *trasitionPlayItem = (GMTransitionPlayItem *)playItem;

        if (trasitionPlayItem.transitionType == kVideoTransitionType_Dissolve) {
            description = @"渐变效果";
        }
        if (trasitionPlayItem.transitionType == kVideoTransitionType_Push) {
            description = @"位移效果";
        }
        if (trasitionPlayItem.transitionType == kVideoTransitionType_Wipe) {
            description = @"擦除效果";
        }
        
        
        
        cell.descriptionLabel.text = description;
        
        return cell;
    }
    
    return nil;
}


- (void)addBtnAction{
    
    NSString *first = nil;
    NSString *second = nil;
    
    BOOL success = self.addPlayItemBlock(&first, &second);
    if (success) {
        GMVideoPlayItem *videoPlayItem = [GMVideoPlayItem new];
        
        AVAsset *asset1 ;
        AVAsset *asset2 ;
        if (first) {
            asset1 = [AVAsset assetWithURL:[NSURL fileURLWithPath:first]];
            videoPlayItem.videoArray = @[asset1];
        }
        if (second) {
            asset2 = [AVAsset assetWithURL:[NSURL fileURLWithPath:second]];
            videoPlayItem.videoArray = @[asset1,asset2];
        }
        [self addPlayItemListObject:videoPlayItem];
    }
}

@end
