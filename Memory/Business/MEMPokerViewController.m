//
//  MEMPokerViewController.m
//  Memory
//
//  Created by owen on 2017/9/15.
//  Copyright © 2017年 owen. All rights reserved.
//

#import "MEMPokerViewController.h"
#import "UIView+ViewFrameGeometry.h"
#import "Memory-Swift.h"

static float const      kScaleParameter = 0.7;
static NSUInteger const kPokerCount = 5;

@interface MEMPokerViewController ()
@property (nonatomic, assign) BOOL tapActionEnabled;
@property (nonatomic, strong) NSMutableArray *pokerViews;
@property (nonatomic, assign) CGSize pokerSize;
@property (nonatomic, strong) UIView *selectedView;
@property (nonatomic, assign) CGPoint pokerPoint;
@end

@implementation MEMPokerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor color:0x010101];
    self.title = @"试试运气";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    for (UIImageView *view in _pokerViews) {
        [view removeFromSuperview];
    }
    [self pokerAnimation];
}

- (void)pokerAnimation
{
    self.tapActionEnabled = NO;
    self.pokerViews = [NSMutableArray array];
    CGSize  pokerSize;
    CGFloat pokerWidth = [UIScreen mainScreen].bounds.size.width - 150;
    _pokerSize = CGSizeMake(pokerWidth, pokerWidth * 4 / 3.0);
    _pokerPoint = CGPointMake(self.view.center.x, (self.view.height - _pokerSize.height) / 2 + _pokerSize.height + 30);
    
    for (NSUInteger i = 0; i < kPokerCount; i++) {
        UIImage *poker = [UIImage imageNamed:@"look_around_poker_bg"];
        UIImageView *pokerImageView = [[UIImageView alloc] initWithImage:poker];
        pokerImageView.layer.anchorPoint = CGPointMake(0.5, 1);
        pokerImageView.size = _pokerSize;
        pokerImageView.layer.position = _pokerPoint;
        pokerImageView.tag = i;
        pokerImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
        [pokerImageView addGestureRecognizer:tapGesture];
        [self.view addSubview:pokerImageView];
        [_pokerViews addObject:pokerImageView];
    }
    for (UIImageView *pokerImageView in _pokerViews) {
        [UIView animateWithDuration:0.25 animations:^{
            CGAffineTransform rotation = CGAffineTransformMakeRotation((-30 + 15 * pokerImageView.tag) / 180.0 * M_PI);
            [pokerImageView setTransform:rotation];
        }];
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
                            UIView *container = [[UIView alloc] init];
                            container.backgroundColor = [UIColor color:0x010101];
                            UIImageView *photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"beijing_%d",arc4random() % 20]]];
                            photoImageView.contentMode = UIViewContentModeScaleAspectFit;
                            container.size = _pokerSize;
                            photoImageView.size = _pokerSize;
                            [container addSubview:photoImageView];

                            [UIView transitionWithView:gesture.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                                if (gesture.view.subviews.count == 0) {
                                    [gesture.view addSubview:container];
                                }
                            } completion:^(BOOL finished) {
                                if (finished) {
                                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restartPockerAnimation)];
                                    [photoImageView addGestureRecognizer:tap];
                                    photoImageView.userInteractionEnabled = YES;
                                    self.selectedView = gesture.view;
                                    gesture.view.userInteractionEnabled = YES;
                                    _tapActionEnabled = NO;
                                }
                            }];
                        }
                    }];
                }
            }];
        }
    }];
}

- (void)restartPockerAnimation {
    [UIView animateWithDuration:0.25 animations:^{
        _selectedView.alpha = 0;
    } completion:^(BOOL finished) {
        for (UIView *view in _selectedView.subviews) {
            [view removeFromSuperview];
        }
        for (UIImageView *pokerImageView in _pokerViews) {
            pokerImageView.layer.anchorPoint = CGPointMake(0.5, 1);
            pokerImageView.layer.position = _pokerPoint;
            [UIView animateWithDuration:0.25 animations:^{
                CGAffineTransform rotation = CGAffineTransformMakeRotation(0);
                [pokerImageView setTransform:rotation];
                pokerImageView.alpha = 1;
            }];
            [UIView animateWithDuration:0.25 animations:^{
                CGAffineTransform rotation = CGAffineTransformMakeRotation((-30 + 15 * pokerImageView.tag) / 180.0 * M_PI);
                [pokerImageView setTransform:rotation];
            }];
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
