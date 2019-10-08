//
//  ViewController.m
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/1/31.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "ViewController.h"
#import "GMPlayerView.h"
#import "GMPlayItemCollectionViewDataSource.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "GMBasicCompositionBuilder.h"
#import "GMComplexCompositionBuilder.h"
#import "GMCompositionService.h"
#import "AVPlayerItem+THAdditions.h"

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UICollectionViewDelegate>
@property (nonatomic, strong) GMPlayerView *playerView;

@property (nonatomic, strong) UICollectionView *playItemCollectionView;
@property (nonatomic, strong) GMPlayItemCollectionViewDataSource *dataSource;

@property (nonatomic, strong) AVQueuePlayer *player;

@property (nonatomic, strong) UIView *titleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}


- (void)setupViews{
    self.playerView = [[GMPlayerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.3)];
    self.playerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.playerView];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout. minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake(70, 70);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    self.playItemCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kScreenHeight * 0.3 + 50, kScreenWidth, 70) collectionViewLayout:layout];
    self.playItemCollectionView.backgroundColor = [UIColor yellowColor];
   
    
    [self.playItemCollectionView registerNib:[GMAddPlayItemCollectionViewCell nib] forCellWithReuseIdentifier:[GMAddPlayItemCollectionViewCell identify]];
    [self.playItemCollectionView registerNib:[GMVideoPlayItemCollectionViewCell nib] forCellWithReuseIdentifier:[GMVideoPlayItemCollectionViewCell identify]];
    [self.playItemCollectionView registerNib:[GMTransitionCollectionViewCell nib] forCellWithReuseIdentifier:[GMTransitionCollectionViewCell identify]];
    
    WS(weakSelf);
    self.dataSource = [GMPlayItemCollectionViewDataSource dataSourceWithCollecitonView:self.playItemCollectionView];
    self.dataSource.addPlayItemBlock = ^BOOL(NSString *__autoreleasing *firstAssetUrl, NSString *__autoreleasing *secondAssetUrl) {
       
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//资源类型为视频库
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.videoMaximumDuration = 60.0f;
        picker.mediaTypes = @[(NSString*)kUTTypeMovie];
        picker.delegate = weakSelf;

        [weakSelf presentViewController:picker animated:YES completion:nil];
    
        
        return NO;
    };
    
    self.playItemCollectionView.dataSource = self.dataSource;
    self.playItemCollectionView.delegate = self;
    
    [self.view addSubview:self.playItemCollectionView];
    
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [playBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [playBtn setTitle:@"播放" forState:UIControlStateNormal];
    
    [playBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [playBtn addTarget:self action:@selector(playBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    playBtn.frame = CGRectMake(50, kScreenHeight - 100, 100, 40);
    
    playBtn.layer.borderColor = [UIColor blackColor].CGColor;
    playBtn.layer.borderWidth = 0.5;
    
    [self.view addSubview:playBtn];
}

- (void)setupPlayer{
    
    GMCompositionService *service = [GMCompositionService shareInstance];
    
    [service updateComponsitionListWithPlayItems:self.dataSource.playItemList];
    
    NSArray <AVPlayerItem *>*playerItems = [service makePlayable];
    
    self.player = [AVQueuePlayer queuePlayerWithItems:playerItems];
    
    self.playerView.player = self.player;
    
    [self.titleView removeFromSuperview];
    
    self.titleView = [UIView new];
    
    self.titleView.frame = GM720pVideoRect;
    
    AVPlayerItem *playerItem = playerItems[0];
    
    if (playerItem.syncLayer) {
//            playerItem.syncLayer.bounds = GM720pVideoRect;
            
        [self.titleView.layer addSublayer:playerItem.syncLayer];
        
        CGFloat scale = fminf(self.view.boundsWidth / GM720pVideoSize.width, self.view.boundsHeight /GM720pVideoSize.height);
        CGRect videoRect = AVMakeRectWithAspectRatioInsideRect(GM720pVideoSize, self.playerView.bounds);
        self.titleView.center = CGPointMake( CGRectGetMidX(videoRect), CGRectGetMidY(videoRect));
        self.titleView.transform = CGAffineTransformMakeScale(scale, scale);
        

    }
    
    
    [self.view addSubview:self.titleView];
    

    
    [self.player play];
    
//
//    GMComplexCompositionBuilder *builder = [[GMComplexCompositionBuilder alloc] initWithPlayItems:self.dataSource.playItemList];
//    GMBasicComposition *composition = [builder buildComposition];
//    self.player = [AVPlayer playerWithPlayerItem:[composition makePlayable]];
//
//    self.playerView.player = self.player;
//
//    [self.player play];
}


- (void)prepareToPlay{
    
}



#pragma mark --
- (void)playBtnDidClicked:(UIButton *)sender{
    [self setupPlayer];
}


#pragma mark -- Notification
- (void)playerItemDidEnd:(NSNotification *)notification{
    AVPlayerItem *playerItem = notification.object;
    
    [playerItem.syncLayer removeFromSuperlayer];
    
    NSInteger index = [[self.player items] indexOfObject:playerItem];
    
    if (index + 1 < [self.player items].count) {
        AVPlayerItem *newPlayerItem = [self.player items][index + 1];
        
        if (newPlayerItem.syncLayer) {
            //            playerItem.syncLayer.bounds = GM720pVideoRect;
            
            [self.titleView.layer addSublayer:newPlayerItem.syncLayer];
            
            CGFloat scale = fminf(self.view.boundsWidth / GM720pVideoSize.width, self.view.boundsHeight /GM720pVideoSize.height);
            CGRect videoRect = AVMakeRectWithAspectRatioInsideRect(GM720pVideoSize, self.playerView.bounds);
            self.titleView.center = CGPointMake( CGRectGetMidX(videoRect), CGRectGetMidY(videoRect));
            self.titleView.transform = CGAffineTransformMakeScale(scale, scale);
        
        }
    }
    

}


#pragma mark-- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GMBasicPlayItem *playItem = [self.dataSource.playItemList objectAtIndex:indexPath.row];
    if (playItem.type == kPlayItem_UnKnown) {
        return;
    }
    if (playItem.type == kPlayItem_Transition) {
        //修改过渡的PlayItem
        GMTransitionPlayItem *transitionPlayItem = (GMTransitionPlayItem *)playItem;
        
         WS(weakSelf);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择过渡效果" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *dissolveAction = [UIAlertAction actionWithTitle:@"渐变效果" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            transitionPlayItem.transitionType = kVideoTransitionType_Dissolve;
            [weakSelf.playItemCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        }];
        UIAlertAction *pushAction = [UIAlertAction actionWithTitle:@"位移效果" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            transitionPlayItem.transitionType = kVideoTransitionType_Push;
            [weakSelf.playItemCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        }];
        UIAlertAction *wipeAction = [UIAlertAction actionWithTitle:@"擦除效果" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            transitionPlayItem.transitionType = kVideoTransitionType_Wipe;
            [weakSelf.playItemCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            transitionPlayItem.transitionType = kVideoTransitionType_None;
            [alertController dismissViewControllerAnimated:YES completion:^{
                [weakSelf.playItemCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            }];
        }];
        [alertController addAction:dissolveAction];
        [alertController addAction:pushAction];
        [alertController addAction:wipeAction];
        [alertController addAction:cancelAction];
        
       
        
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
        
    }
    
}


#pragma mark -- UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info{
    
    //打印出字典中的内容
    
    NSLog(@"get the media info: %@", info);
    
    //获取媒体类型
    
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    //判断是静态图像还是视频
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        
        AVAsset *asset = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        
        if (CMTimeGetSeconds(asset.duration) >= 3.0f  ) {
            GMVideoPlayItem *videoPlayItem = [GMVideoPlayItem new];
            videoPlayItem.videoArray = @[asset];
            
            [self.dataSource addPlayItemListObject:videoPlayItem];
        }else{
            NSLog(@"目前不允许小于3s");
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
