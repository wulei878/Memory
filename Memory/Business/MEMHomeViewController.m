//
//  MEMHomeViewController.m
//  Memory
//
//  Created by Owen on 2017/9/15.
//  Copyright © 2017年 owen. All rights reserved.
//

#import "MEMHomeViewController.h"
#import "UIView+ViewFrameGeometry.h"
#import "Memory-Swift.h"
#import <Masonry/Masonry.h>
#import <Lottie/Lottie.h>
#import "MEMMediaPickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface MEMHomeViewController ()<UIViewControllerTransitioningDelegate,AVAudioPlayerDelegate,IDMPhotoBrowserDelegate>
@property (nonatomic, strong) NSArray *destinations;
@property (nonatomic, strong) NSMutableArray *destArray;
@property (nonatomic, strong) UIImageView *mapView;
@property (nonatomic, assign) CGFloat widthScale;
@property (nonatomic, strong) UIImageView *planeImageView;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation MEMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我们的旅行";
    self.view.backgroundColor = [UIColor color:0xf6f6f6];
    UIImageView *mapView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map"]];
    mapView.width = self.view.width;
    CGSize originSize = CGSizeMake(610, 465);
    _widthScale = mapView.size.width / originSize.width;
    [self.view addSubview:mapView];
    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(self.view.mas_width).multipliedBy(465 / 610.0);
    }];
    self.mapView = mapView;
    mapView.userInteractionEnabled = YES;
    [self playMusic];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    for (UIView *view in _mapView.subviews) {
        [view removeFromSuperview];
    }
    [self locationPointAnimation];
    [self resetPlane];
}

- (void)locationPointAnimation {
    _destArray = [NSMutableArray array];
    for (int i = 0; i < self.destinations.count; i++) {
        UIImageView *dest = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location"]];
        if (i == 0) {
            dest.origin = CGPointMake(445 * _widthScale, 0);
        } else if (i == 1) {
            dest.origin = CGPointMake(454 * _widthScale, 0);
        } else if (i == 2) {
            dest.origin = CGPointMake(475 * _widthScale, 0);
        } else if (i == 3) {
            dest.origin = CGPointMake(502 * _widthScale, 0);
        } else if (i == 4) {
            dest.origin = CGPointMake(272 * _widthScale, 0);
        } else if (i == 5) {
            dest.origin = CGPointMake(20, 0);
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoLocation:)];
        [dest addGestureRecognizer:tap];
        dest.userInteractionEnabled = YES;
        dest.tag = i;
        [_destArray addObject:dest];
        [_mapView addSubview:dest];
    }
    for (int i = 0;i < _destArray.count;i++) {
        UIImageView *dest = _destArray[i];
        CGFloat dis = -dest.height;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if (i == 0) {
                dest.origin = CGPointMake(445 * _widthScale, 175 * _widthScale + dis);
            } else if (i == 1) {
                dest.origin = CGPointMake(454 * _widthScale, 189 * _widthScale + dis);
            } else if (i == 2) {
                dest.origin = CGPointMake(475 * _widthScale, 275 * _widthScale + dis);
            } else if (i == 3) {
                dest.origin = CGPointMake(502 * _widthScale, 177 * _widthScale + dis);
            } else if (i == 4) {
                dest.origin = CGPointMake(272 * _widthScale, 377 * _widthScale + dis);
            } else if (i == 5) {
                dest.origin = CGPointMake(20, _mapView.height - dest.height - 20);
            }
        } completion:nil];
    }
}

- (void)resetPlane {
    if (_planeImageView) {
        [_planeImageView removeFromSuperview];
    }
    UIImageView *planeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plane"]];
    planeImageView.center = CGRectGetCenter(((UIView *)_destArray[0]).frame);
    [_mapView addSubview:planeImageView];
    planeImageView.alpha = 0;
    self.planeImageView = planeImageView;
}

- (void)gotoLocation:(UITapGestureRecognizer *)tap {
    UIView *start = (UIView *)_destArray[0];
    CGPoint startPoint = CGRectGetCenter(start.frame);
    CGPoint endPoint = CGRectGetCenter(tap.view.frame);
    CGFloat angle = atan((endPoint.y - startPoint.y) / (endPoint.x - startPoint.x));
    if (endPoint.y < startPoint.y && endPoint.x < startPoint.x) {
        angle = -angle;
    } else if (endPoint.y > startPoint.y && endPoint.x < startPoint.x) {
        angle -= M_PI / 2;
    } else if (endPoint.y > startPoint.y && endPoint.x > startPoint.x) {
        angle += M_PI / 2;
    }
    NSLog(@"%f",angle);
    [UIView animateWithDuration:0.2 animations:^{
        _planeImageView.alpha = 1;
        start.alpha = 0;
        tap.view.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
            [_planeImageView setTransform:rotation];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _planeImageView.center = endPoint;
            } completion:^(BOOL finished) {
                NSString *prefix = [self getImagePrefix:tap.view.tag];
                NSMutableArray *tempArray = [NSMutableArray array];
                for (int i = 0;;i++) {
                    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",prefix,i]];
                    if (!image) {
                        break;
                    } else {
                        [tempArray addObject:image];
                    }
                }
                if (tempArray.count == 0) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"这里还没有图片哦，快叫程序员哥哥添加吧！" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                    [self resetPlane];
                    for (UIView *view in _destArray) {
                        view.alpha = 1;
                    }
                    return;
                }
                NSArray *photos = [IDMPhoto photosWithImages:tempArray];
                MEMMediaPickerViewController *browser = [[MEMMediaPickerViewController alloc] initWithPhotos:photos];
                browser.delegate = self;
                [self presentViewController:browser animated:YES completion:nil];
            }];
        }];
    }];
}

- (NSArray *)destinations {
    return @[@"北京",@"天津",@"南京",@"大连",@"云南",@"马尔代夫"];
}

- (NSString *)getImagePrefix:(NSInteger)tag {
    NSString *prefix = @"";
    switch (tag) {
        case 0:
        prefix = @"beijing_";
        break;
        case 1:
        prefix = @"tianjin_";
        break;
        case 2:
        prefix = @"nanjing_";
        break;
        case 3:
        prefix = @"dalian_";
        break;
        case 4:
        prefix = @"yunnan_";
        break;
        case 5:
        prefix = @"madai_";
        break;
        default:
        break;
    }
    return prefix;
}

- (void)playMusic {
    // 1.获取要播放音频文件的URL
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:arc4random() % 2 == 0 ? @"01" : @"02" withExtension:@".mp3"];
    // 2.创建 AVAudioPlayer 对象
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
    // 3.打印歌曲信息
    NSString *msg = [NSString stringWithFormat:@"音频文件声道数:%ld\n 音频文件持续时间:%g",self.audioPlayer.numberOfChannels,self.audioPlayer.duration];
    NSLog(@"%@",msg);
    // 4.设置循环播放
    self.audioPlayer.numberOfLoops = -1;
    self.audioPlayer.delegate = self;
    // 5.开始播放
    [self.audioPlayer play];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    LOTAnimationTransitionController *animationController = [[LOTAnimationTransitionController alloc] initWithAnimationNamed:@"vcTransition1"
                                                                                                              fromLayerNamed:@"outLayer"
                                                                                                                toLayerNamed:@"inLayer"
                                                                                                     applyAnimationTransform:NO];
    return animationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    LOTAnimationTransitionController *animationController = [[LOTAnimationTransitionController alloc] initWithAnimationNamed:@"vcTransition2"
                                                                                                              fromLayerNamed:@"outLayer"
                                                                                                                toLayerNamed:@"inLayer"
                                                                                                     applyAnimationTransform:NO];
    return animationController;
}

- (void)willDisappearPhotoBrowser:(IDMPhotoBrowser *)photoBrowser {
    [self resetPlane];
    for (UIView *view in _destArray) {
        view.alpha = 1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
