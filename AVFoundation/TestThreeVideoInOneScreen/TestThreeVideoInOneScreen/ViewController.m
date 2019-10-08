//
//  ViewController.m
//  TestThreeVideoInOneScreen
//
//  Created by 蔡浩铭 on 2019/1/18.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "GMUtils/GMUtils+HUD/GMUtils+HUD.h"

 #define THWeakSelf __weak __typeof__(self)
static const CGRect TH720pVideoRect = {{0.0f, 0.0f}, {1280.0f, 720.0f}};

@interface ViewController ()
{
    BOOL a ;
}

@property (nonatomic, strong) AVMutableComposition *composition;

@property (nonatomic, strong) NSArray *assetTracksArray;

@property (nonatomic, strong) AVMutableVideoComposition *videoCompostion;

@property (nonatomic, strong) NSArray *videoCompostionArray;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVPlayerItem *item ;

@property (nonatomic, strong) CALayer *titleLayer;

@property (strong, nonatomic) AVAssetExportSession *exportSession;

@property (strong, nonatomic) AVSynchronizedLayer *synchronizedLayer ;

@property (strong, nonatomic) UIView *titleView;


@property (weak, nonatomic) IBOutlet UIButton *exportBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self initialComposition];


    [self setVideoCompositionInstruction];


    //    self.synchronizedLayer = [AVSynchronizedLayer synchronizedLayerWithPlayerItem:self.item];
    
    self.titleLayer = [CALayer layer];
    //    (width / scale)
    //    ceil((width / scale) / 16) * 16
    self.titleLayer.frame = TH720pVideoRect;
    //    self.titleLayer.position = CGPointMake(CGRectGetMidX(TH720pVideoRect),
    //                                           CGRectGetMidY(TH720pVideoRect));
    
    [self.titleLayer addSublayer:[self buildLayer]];
    
    self.titleLayer.hidden = YES;
    
    
    [self makePlayable];
    
    

    self.player = [AVPlayer playerWithPlayerItem:self.item];


    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;

    playerLayer.backgroundColor = [UIColor whiteColor].CGColor;
    
    float scale = 1280.0 / 720.0;
    
    float width = [UIScreen mainScreen].bounds.size.width;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;

    playerLayer.frame =  CGRectMake(0, (screenSize.height - width / scale) / 2, width, ceil((width / scale) / 16) * 16);
    


    [self.view.layer addSublayer:playerLayer];

    




    
    //[self buildLayer];
    
    
   
//    [self.synchronizedLayer addSublayer:self.titleLayer];

//    [self.view.layer addSublayer:synchronizedLayer];
    [self addSynchronizedLayer:self.synchronizedLayer];

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    
//    [self.view.layer addSublayer:[self buildLayer]];
    
    
//    [self.player play];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addSynchronizedLayer:(AVSynchronizedLayer *)syncLayer{
    
    syncLayer.bounds = TH720pVideoRect;
    
    [self.titleView removeFromSuperview];
    
    self.titleView = [UIView new];
    self.titleLayer.frame = CGRectZero;
    [self.titleView.layer addSublayer:syncLayer];
    
    CGFloat scale = fminf(self.view.bounds.size.width / TH720pVideoRect.size.width, self.view.bounds.size.height / TH720pVideoRect.size.height);
    CGRect videoRect = AVMakeRectWithAspectRatioInsideRect(TH720pVideoRect.size, self.view.bounds);
    
    self.titleView.center = CGPointMake(CGRectGetMidX(videoRect), CGRectGetMidY(videoRect));
    self.titleView.transform = CGAffineTransformMakeScale(scale, scale);
    
    [self.view addSubview:self.titleView];
}


- (AVAssetTrack *)resource{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DefaultVideo" ofType:@"mp4"];
    return [[AVAsset assetWithURL:[NSURL fileURLWithPath:path]] tracksWithMediaType:AVMediaTypeVideo].firstObject;
}

- (void)initialComposition{
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    
    AVMutableCompositionTrack *aCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *bCompositionTrack= [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *cCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"01_nebula" ofType:@"mp4"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"03_nebula" ofType:@"mp4"];

    
    AVAsset *aAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:path1]];
    AVAsset *bAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:path1]];
    AVAsset *cAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:path]];
    
    
    AVAssetTrack *aTrack = [aAsset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    AVAssetTrack *bTrack = [bAsset tracksWithMediaType:AVMediaTypeVideo].firstObject ;
    AVAssetTrack *cTrack = [cAsset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    
    
    self.assetTracksArray = [NSArray arrayWithObjects:aTrack,bTrack,cTrack, nil];
    
    NSError *error = nil;
    
    CMTime time = CMTimeMake(3 * 600, 600);
    
    [aCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, time) ofTrack:aTrack atTime:kCMTimeZero error:&error];
    [bCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, time) ofTrack:bTrack atTime:kCMTimeZero error:&error];
    [cCompositionTrack insertTimeRange:CMTimeRangeMake(time, time) ofTrack:cTrack atTime:CMTimeMake(2 * 600, 600) error:&error];
    
//    [aCompositionTrack insertTimeRange:CMTimeRangeMake(time, time) ofTrack:cTrack atTime:CMTimeMake(5 * 600, 600) error:&error];
    
    
    self.composition = composition;
    
}


- (void)setVideoCompositionInstruction{
    
    self.videoCompostion =                                  // 1
    [AVMutableVideoComposition
     videoCompositionWithPropertiesOfAsset:self.composition];
    
    
    NSArray *compositionInstruction = self.videoCompostion.instructions;
    
    for (AVMutableVideoCompositionInstruction *vci in compositionInstruction) {
        
        vci.backgroundColor = [UIColor clearColor].CGColor;
        
        CMTimeRange timeRange = vci.timeRange;
        
        CGSize videoSize = self.videoCompostion.renderSize;
        
        if (vci.layerInstructions.count == 2) {
            ///两个视频叠加
            
            AVMutableVideoCompositionLayerInstruction *aVideoCompositionLayerInstruction = (AVMutableVideoCompositionLayerInstruction *)vci.layerInstructions[0];
            AVMutableVideoCompositionLayerInstruction *bVideoCompositionLayerInstruction = (AVMutableVideoCompositionLayerInstruction *)vci.layerInstructions[1];
            
            [aVideoCompositionLayerInstruction setCropRectangle:CGRectMake(0, 0, videoSize.width, videoSize.height / 2) atTime:kCMTimeZero];

            
            [bVideoCompositionLayerInstruction setCropRectangle:CGRectMake(0, 0, videoSize.width, videoSize.height / 2) atTime:kCMTimeZero];
            [bVideoCompositionLayerInstruction setTransform:CGAffineTransformMakeTranslation(0, videoSize.height / 2) atTime:kCMTimeZero];
            
            
        }
        if (vci.layerInstructions.count == 3) {
            ///2个视频过渡到1个视频
            
            
            AVMutableVideoCompositionLayerInstruction *aVideoCompositionLayerInstruction = (AVMutableVideoCompositionLayerInstruction *)vci.layerInstructions[0];
            AVMutableVideoCompositionLayerInstruction *bVideoCompositionLayerInstruction = (AVMutableVideoCompositionLayerInstruction *)vci.layerInstructions[1];
            
            [aVideoCompositionLayerInstruction setCropRectangle:CGRectMake(0, 0, videoSize.width, videoSize.height / 2) atTime:timeRange.start];
            
            [bVideoCompositionLayerInstruction setTransform:CGAffineTransformMakeTranslation(0, videoSize.height / 2) atTime:timeRange.start];
            [bVideoCompositionLayerInstruction setCropRectangle:CGRectMake(0, 0, videoSize.width, videoSize.height / 2) atTime:timeRange.start];
            

            

            [aVideoCompositionLayerInstruction setOpacityRampFromStartOpacity:1.0
                                         toEndOpacity:0.0
                                            timeRange:timeRange];
            [bVideoCompositionLayerInstruction setOpacityRampFromStartOpacity:1.0
                                                                 toEndOpacity:0.0
                                                                    timeRange:timeRange];
            
            

            
            
        }
        
        if (vci.layerInstructions.count == 1) {
            //只有一个
            
            if (!a) {
                a = YES;
                
            }else{
                return;
            }
            AVMutableVideoCompositionLayerInstruction *aVideoCompositionLayerInstruction = (AVMutableVideoCompositionLayerInstruction *)vci.layerInstructions[0];


            

            CGAffineTransform identityTransform = CGAffineTransformIdentity;

            CGAffineTransform toStartTransform =
            CGAffineTransformMakeTranslation((videoSize.width - 0) * 1.1, 0.0);


            
//            [aVideoCompositionLayerInstruction setTransform:toStartTransform atTime:timeRange.start];
            [aVideoCompositionLayerInstruction setTransformRampFromStartTransform:identityTransform toEndTransform:toStartTransform timeRange:timeRange];
//            [aVideoCompositionLayerInstruction setCropRectangleRampFromStartCropRectangle:CGRectMake(0, 0, videoSize.width, videoSize.height) toEndCropRectangle:CGRectMake(videoSize.width, 0, 0, videoSize.height) timeRange:timeRange];

            
            
        }
        

    }

    
}


- (CALayer *)makeTextLayer {
    CGFloat fontSize = 150.0;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    NSDictionary *att = @{NSFontAttributeName : font,NSForegroundColorAttributeName:(id)[UIColor redColor].CGColor};
    
//    NSString *text = @"测试测试";
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"测试测试" attributes:att];
    
    CGSize textsize = [@"测试测试" sizeWithAttributes:att];
    
    CATextLayer *layer = [CATextLayer layer];
    layer.string = string;
    layer.bounds = CGRectMake(0, 0, textsize.width, textsize.height);
    layer.position = CGPointMake(CGRectGetMidX(TH720pVideoRect), CGRectGetMidY(TH720pVideoRect));
    layer.backgroundColor = [UIColor clearColor].CGColor;
    
    return layer;
}


- (CALayer *)buildLayer{
    CALayer *parentLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, 0, 720);
    parentLayer.position = CGPointZero;
    parentLayer.anchorPoint = CGPointZero;
    parentLayer.masksToBounds = YES;
    
    CALayer *textLayer = [self makeTextLayer];
    [parentLayer addSublayer:textLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    animation.toValue =  [NSValue valueWithCGRect:CGRectMake(0, 0, 1280.0 * 1.1,720.0)];
    animation.beginTime = 3;
    animation.duration = 2.0f;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    animation.fillMode = kCAFillModeForwards;



    [parentLayer addAnimation:animation forKey:nil];
    
    return parentLayer;
}


- (NSURL *)exportURL {                                                      // 5
    NSString *filePath = nil;
    NSUInteger count = 0;
    do {
        filePath = NSTemporaryDirectory();
        NSString *numberString = count > 0 ?
        [NSString stringWithFormat:@"-%li", (unsigned long) count] : @"";
        NSString *fileNameString =
        [NSString stringWithFormat:@"Masterpiece-%@.m4v", numberString];
        filePath = [filePath stringByAppendingPathComponent:fileNameString];
        count++;
    } while ([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    
    return [NSURL fileURLWithPath:filePath];
}

- (AVPlayerItem *)makePlayable{
    self.item = [AVPlayerItem playerItemWithAsset:[self.composition copy]];
    
    self.item.videoComposition = self.videoCompostion;
    
    if (self.titleLayer) {
        self.synchronizedLayer = [AVSynchronizedLayer synchronizedLayerWithPlayerItem:self.item];
        [self.synchronizedLayer addSublayer:self.titleLayer];
        
    }
    return self.item;
}


- (AVAssetExportSession *)makeExportable{
    CALayer *animationLayer = [CALayer layer];
    animationLayer.frame = TH720pVideoRect;
    
    CALayer *videoLayer = [CALayer layer];
    videoLayer.frame = TH720pVideoRect;
    
    [animationLayer addSublayer:videoLayer];
    [animationLayer addSublayer:self.titleLayer];
    

    AVVideoCompositionCoreAnimationTool *animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:animationLayer];
    
    AVMutableVideoComposition *mvc =
    (AVMutableVideoComposition *)[self.videoCompostion copy];
    mvc.animationTool = animationTool;
    
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:[self.composition copy] presetName:AVAssetExportPresetHighestQuality];
    session.videoComposition = mvc;
    return session;
}

- (void)writeExportedVideoToAssetsLibrary {
    NSURL *exportURL = self.exportSession.outputURL;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:exportURL]) {  // 3
        
        [library writeVideoAtPathToSavedPhotosAlbum:exportURL               // 4
                                    completionBlock:^(NSURL *assetURL,
                                                      NSError *error) {
                                        
                                        if (error) {                                                    // 5
                                            
                                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Write Failed"
                                                                                                message:@"Unable to write to Photos library."
                                                                                               delegate:nil cancelButtonTitle:@"OK"
                                                                                      otherButtonTitles:nil, nil];
                                            [alertView show];
                                        }
                                        
                                        [[NSFileManager defaultManager] removeItemAtURL:exportURL       // 6
                                                                                  error:nil];
                                        
                                        [GMUtils hideAllWaitingHUDInKeyWindow];
                                        
                                        if (!error) {
                                            [GMUtils showQuickTipWithText:@"导出成功"];
                                        }
                                    }];
    } else {
        NSLog(@"Video could not be exported to assets library.");
    }
}


- (IBAction)playBtnDidTouched:(id)sender {
    

    
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        
        self.titleLayer.hidden = NO;
        self.exportBtn.enabled = NO;
        
        if ([self.titleLayer.superlayer class] != [AVSynchronizedLayer class]) {
            [self makePlayable];
            [self.player replaceCurrentItemWithPlayerItem:self.item];
            [self addSynchronizedLayer:self.synchronizedLayer];
        }
        
        [self.player pause];
        [self.player seekToTime:kCMTimeZero];
        [self.player play];
    }
   
}

- (IBAction)exportBtnDidTouched:(id)sender {
    

    [GMUtils showWaitingHUDInKeyWindow];
    
    if (!self.exportSession) {
        self.exportSession = [self makeExportable];
        self.exportSession.outputURL = [self exportURL];
        self.exportSession.outputFileType = AVFileTypeMPEG4;
    }
    
    THWeakSelf weakSelf = self;
    [self.exportSession exportAsynchronouslyWithCompletionHandler:^{        // 2
        
        dispatch_async(dispatch_get_main_queue(), ^{                        // 1
            AVAssetExportSessionStatus status = weakSelf.exportSession.status;
            if (status == AVAssetExportSessionStatusCompleted) {
                [self writeExportedVideoToAssetsLibrary];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Export Failed"
                                                                    message:@"The request export failed."
                                                                   delegate:nil cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                [alertView show];

            }
        });
    }];
    
  
    
}

- (void)playerDidReachEnd:(NSNotification *)notification{
    
    self.exportBtn.enabled = YES;
    
}

@end
