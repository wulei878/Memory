//
//  MEMPockerViewController.m
//  Memory
//
//  Created by owen on 2017/9/15.
//  Copyright © 2017年 owen. All rights reserved.
//

#import "MEMPockerViewController.h"
#import "UIView+ViewFrameGeometry.h"

static float const      kScaleParameter = 0.7;
static NSUInteger const kPokerCount = 5;

@interface MEMPockerViewController ()
@property (nonatomic, assign) BOOL tapActionEnabled;
@property (nonatomic, strong) UIView *mainView;
@end

@implementation MEMPockerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)pokerAnimation
{
    self.tapActionEnabled = NO;
    
    self.mainView.layer.cornerRadius = 3;
    self.mainView.layer.borderWidth = 5;
    UIImage *poker = [UIImage imageNamed:@"look_around_poker_bg"];
    CGSize  pokerSize;
    CGPoint pokerPoint;
    
    pokerSize = CGSizeMake(296 * kScaleParameter, 393 * kScaleParameter);
    self.mainView.size = CGSizeMake(296, 393);
    pokerPoint = CGPointMake(self.view.center.x, (self.view.height - pokerSize.height) / 2 + pokerSize.height + 30);
    
    for (NSUInteger i = 0; i < kPokerCount; i++) {
        UIImageView *pokerImageView = [[UIImageView alloc] initWithImage:poker];
        pokerImageView.layer.anchorPoint = CGPointMake(0.5, 1);
        pokerImageView.size = pokerSize;
        pokerImageView.layer.position = pokerPoint;
        pokerImageView.tag = i + 1;
        pokerImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
        [pokerImageView addGestureRecognizer:tapGesture];
        [self.view addSubview:pokerImageView];
    }
}

- (void)event:(UITapGestureRecognizer *)gesture
{
    if (self.tapActionEnabled) {
        return;
    }
    
    self.tapActionEnabled = YES;
    
    gesture.view.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        for (UIView * pokerView in weakSelf.view.subviews) {
            if (pokerView.tag != gesture.view.tag) {
                [pokerView setAlpha:0];
            }
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.5 animations:^{
                CGAffineTransform rotation = CGAffineTransformMakeRotation(0);
                [gesture.view setTransform:rotation];
            } completion:^(BOOL finished) {
                if (finished) {
                    gesture.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
                    gesture.view.layer.position = CGPointMake(gesture.view.layer.position.x, gesture.view.layer.position.y - gesture.view.height / 2);
                    [UIView animateWithDuration:0.5 animations:^{
                        gesture.view.transform = CGAffineTransformMakeScale(1 / kScaleParameter, 1 / kScaleParameter);
                    } completion:^(BOOL finished) {
                        if (finished) {
//                            weakSelf.mainViewBottom = gesture.view.bottom;
//                            [weakSelf loadMainView:^(LoadMainViewError error) {
//                                weakSelf.mainView.transform = CGAffineTransformMakeScale(kScaleParameter, kScaleParameter);
//                                weakSelf.mainView.origin = CGPointMake(0, 0);
//                                gesture.view.layer.cornerRadius = 3;
//                                gesture.view.layer.borderWidth = 5;
//                                gesture.view.layer.borderColor = [RGBCOLOR(0x3d, 0xcb, 0xff) CGColor];
//                                gesture.view.layer.masksToBounds = YES;
//                                
//                                [UIView transitionWithView:gesture.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
//                                    if (gesture.view.subviews.count == 0) {
//                                        [gesture.view addSubview:weakSelf.mainView];
//                                    }
//                                } completion:^(BOOL finished) {
//                                    if (finished) {
//                                        gesture.view.userInteractionEnabled = YES;
//                                        [gesture.view removeGestureRecognizer:gesture];
//                                    }
//                                }];
//                            }];
                        }
                    }];
                }
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
